pragma solidity ^0.5.0;


library safeMath {
  
    /* 
    * @dev mul for two unsigned integers, reverts on overflow
    */
    function emul(uint256 a, uint256 b) internal pure returns(uint256){
        if (a == 0){
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }

    /* 
    * @dev division of two unsigned integers, reverts on division by zero
    */
    function ediv(uint256 a, uint256 b) internal pure returns(uint256){
        require ( b > 0);
        uint256 c = a  / b ;
        return c;
    }


    /*
    * @dev substract of two unsigned integers, reverts on overflow
    */
    function esub(uint256 a , uint256 b) internal pure returns(uint256){
        require (b <= a);
        uint256 c = a - b;
        return c;
    }
    

        /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function eadd(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }
}

contract demoInterface{
    
    //total amount of tokens
    function totalSupply() public view returns (uint256);
    
    //@param_owner The address from which the balance will be retrived
    //@return The balance
    function balanceOf(address _owner) public view returns (uint256 balance);
    
    //@notice send '_value'  token to '_to' from msg.sender
    //@param _to The address of the recipient
    //@param _value The amount of token to be transaferred
    //@param Whether the transafer was successful or not
    function transfer(address _to, uint256 _value) public returns (bool success);
    
     //@notice  send '_value' token to '_to' from '_from' on condition it is approved by '_from'
    //@param _from The address of the sender
    //@param _to The address of recipient
    //@param _value The amount of token to be transaffered
    //@returns Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    
    
    //@notice 'msg.sender' approves '_spender' to spend _value tokens
    //@param _spender The address of the account able to transfer the tokens
    //@param _value The amount of tokens to be approved for transfer
    //@returns Whether the approval was successful or not
    function approve(address _spender, uint256 _value) public returns (bool success);
    
    
    //@param _spender The address of the account able to transfer the tokens
    //@param _value The amount of tokens to be approved for transfer
    //@param _extraData Any data to be send along with the it 
    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success);
    
    //@param _owner The address of the account owing tokens
    //@param _spender The address of the account able to transfer the tokens
    //@returns Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) public returns (uint256 remaining);
    
    //@param _value tokens from the system irreversible
    function burn(uint256 _value) public returns (bool success);

    //@param _newOwner address of new owener
    //@param _owner address of current owner
    function transferOwnership(address _newOwner) public returns(bool success);
    
    
    //@param _target address where new minted token to add
    //@param _value amount of token owner want to generate
    function mintToken(address _target, uint256 _value) public returns(bool success);
    
    
    function mintableToken() public returns(uint256 remaining);

    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed from, uint256 value);

}

contract tokenRecipient {
    function receiveApproval(address _from, uint256 _value, address _token, bytes memory _extraData) public;
}


contract ABCxyzToken is demoInterface{
    using safeMath for uint256;
    
    string public constant name = "ABC XYZ Coin";  // Name of the Coin
    string public constant symbol = "ABCxyz"; // Sysmbol/ abbrevation of coin
    uint8 public constant decimals = 18; // 18 decimal places, the same as ETH
    uint256 public initialSupply = 10000000;
    uint256 _totalSupply;
    address public _ownerAddress;
    uint256 private upperLimit = 1000000000; 
    uint256 public ceilingSupply;
    
    mapping (address => uint256) public _balanceOf;
    mapping (address => mapping(address => uint256)) public _allowance;
    
    // storing owners address
    constructor() public { 
        _ownerAddress = msg.sender; 
        _totalSupply = initialSupply * 10 ** uint256(decimals);
        ceilingSupply = upperLimit * 10 ** uint256(decimals);
        _balanceOf[msg.sender] = _totalSupply;
    }
    
    
    // @onlyOwner modifier that can be used in define 
    //function which only owner of the smartcontract can call
    modifier onlyOwner{
        require(msg.sender == _ownerAddress);
        _;
    }

    
    /**
     * Gives you the totalsupply of the coin 
     * 
     * returns total coin created
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    
        /**
     * 
     * retunrs balance of particular address
     * 
     * @param _addr The address of the user whos balance need to be checked
     */ 
    function balanceOf(address _addr) public view returns (uint) {
        return _balanceOf[_addr];
    }
    
    
    /**
     * Internal function to be call by internally only
    */
    function _transfer(address _from, address _to, uint _value) internal{

        //Check is sender has enough balance
        require(_balanceOf[_from] >= _value);
        //check for overflows
        require(_balanceOf[_to].eadd(_value) > _balanceOf[_to]);
        //Save this for an assertion in the future
        uint previousBalances = _balanceOf[_from].eadd(_balanceOf[_to]);
        // remove balance from sender
        _balanceOf[_from] = _balanceOf[_from].esub(_value);
        //add balance to recipient
        _balanceOf[_to] = _balanceOf[_to].eadd(_value);
        
        // for loggin information
        emit Transfer(_from, _to, _value);
        
        //assert are use for static analysis to find bug in the code
        assert(_balanceOf[_from].eadd(_balanceOf[_to]) == previousBalances);
    }
    
    /**
     * Transfer tokens
     * send '_value' token to '_to' from your account
     * @param _to address of recipient
     * @param _value the amount to send
    */
    function transfer(address _to, uint256 _value) public returns (bool success){
        //condition for checking valid address
        if ( _value > 0 ){
            _transfer(msg.sender, _to, _value);
            return true;
        }
        return false;
    }

    /**
     * Transfer tokens from other address
     * Send '_value' tokens to '_to', in behalf of '_from'
     * 
     * @param _from The address of the sender
     * @param _to The address of recipient
     * @param _value the amount to send
     * 
    */
    
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(_value <= _allowance[_from][msg.sender]);   //check allowance
        _allowance[_from][msg.sender] = _allowance[_from][msg.sender].esub(_value);
        _transfer(_from, _to, _value);
        return true;
    }
    
    
    /**
     * Set allowance for other address 
     * 
     * Allows '_spender' to spend no more than '_value' tokens in your behalf
     * 
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
    */
    
    function approve(address _spender, uint256 _value) public returns (bool success){
        _allowance[msg.sender][_spender] = _value;
        return true;
    }
    
    
    /**
     * Set allowance for other address and notify
     * 
     * Allows '_spender' to spend no more than '_value' tokens in your behalf, and then ping the contract about it
     * 
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     * @param _extraData some extra information to send to the approved contract
    */
    
    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success){
        if (approve(_spender, _value)){
            tokenRecipient(_spender).receiveApproval(msg.sender, _value, address(this), _extraData);
            return true;
        }
        
    }
    
    
    
    /**
     *  Set the allowance 
     * 
     * returns Amount of remaining tokens allowed to spent
     * 
     * @param _owner The address of account owing token
     * @param _spender The address of the account able to transfer the tokens
     */
    
    function allowance(address _owner, address _spender) public returns (uint256 remaining){
        return _allowance[_owner][_spender];
    }
    
    /**
     * 
     * Destroy tokens
     * Remove '_value' tokens from the system irreversibly
     * 
     * @param _value the amount of money to burn
     */
    
    function burn(uint256 _value) public returns (bool success){
        require(_balanceOf[msg.sender] >= _value); // check if sender has enough
        
        _balanceOf[msg.sender] = _balanceOf[msg.sender].esub(_value);
        _totalSupply = _totalSupply.esub(_value);
        emit Burn(msg.sender, _value);
        return true;
    }
    
    
     
    /**
     * Transfer ownership of contract to another account
     * 
     * 
     * 
     * oaddress the address of the owner
     * naddress the address of new owner of the smartcontract
    */
    function transferOwnership(address _newOwner) onlyOwner public returns(bool success){
        _ownerAddress = _newOwner;
        return true;
    }
    
    /**
     * Create new token other then initial token
     * 
     * Add _value of token into _target account
     * 
     * @param _target adress where new minted token to be created
     * @param _value amount of token to be created
    */
    function mintToken(address _target, uint256 _value) onlyOwner public returns(bool success){
        require (_totalSupply <= ceilingSupply);
        _balanceOf[_target] = _balanceOf[_target].eadd(_value);
        _totalSupply = _totalSupply.eadd(_value);
        emit Transfer(address(0), _ownerAddress, _value);
        emit Transfer(_ownerAddress, _target, _value);
        return true;
    }
    
    /**
     * Total mintableToken pending in the system 
     * 
     * 
    */
    function mintableToken() public returns(uint256 remaining){
        uint256 remain = ceilingSupply.esub(_totalSupply);
        return remain;
    }
    
}