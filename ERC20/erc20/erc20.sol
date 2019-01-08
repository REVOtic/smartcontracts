pragma solidity ^0.4.21;

import "./interface.sol";
import "../math/safeMath.sol";

interface tokenRecipient {
    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
}


contract ABCxyzToken is demoInterface{
    using safeMath for uint256;
    
    string public constant name = "ABC XYZ Coin";  // Name of the Coin
    string public constant symbol = "ABCxyz"; // Sysmbol/ abbrevation of coin
    uint8 public constant decimals = 18; // 18 decimal places, the same as ETH
    uint256 public initialSupply = 10000000;
    uint256 public totalSupply;
    address public _ownerAddress;
    uint256 private upperLimit = 1000000000; 
    uint256 public ceilingSupply;
    
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping(address => uint256)) public allowance;
    
    // storing owners address
    constructor() public { 
        _ownerAddress = msg.sender; 
        totalSupply = initialSupply * 10 ** uint256(decimals);
        ceilingSupply = upperLimit * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
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
    function totalSupply() public constant returns (uint256 _totalSupply) {
        return totalSupply;
    }
    
        /**
     * 
     * retunrs balance of particular address
     * 
     * @param _addr The address of the user whos balance need to be checked
     */ 
    function balanceOf(address _addr) public constant returns (uint balance) {
        return balanceOf[_addr];
    }
    
    
    /**
     * Internal function to be call by internally only
    */
    function _transfer(address _from, address _to, uint _value) internal{
        // Prevent transfer to 0x0 address. Use burn() instead
        require(_to != 0x0);
        //Check is sender has enough balance
        require(balanceOf[_from] >= _value);
        //check for overflows
        require(balanceOf[_to].eadd(_value) > balanceOf[_to]);
        //Save this for an assertion in the future
        uint previousBalances = balanceOf[_from].eadd(balanceOf[_to]);
        // remove balance from sender
        balanceOf[_from] = balanceOf[_from].esub(_value);
        //add balance to recipient
        balanceOf[_to] = balanceOf[_to].eadd(_value);
        
        // for loggin information
        emit Transfer(_from, _to, _value);
        
        //assert are use for static analysis to find bug in the code
        assert(balanceOf[_from].eadd(balanceOf[_to]) == previousBalances);
    }
    
    /**
     * Transfer tokens
     * send '_value' token to '_to' from your account
     * @param _to address of recipient
     * @param _value the amount to send
    */
    function transfer(address _to, uint256 _value) public returns (bool success){
        //condition for checking valid address
        if ( _value > 0 && msg.sender != 0x0){
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
        require(_value <= allowance[_from][msg.sender]);   //check allowance
        allowance[_from][msg.sender] = allowance[_from][msg.sender].esub(_value);
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
        allowance[msg.sender][_spender] = _value;
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
    
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success){
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)){
            spender.receiveApproval(msg.sender, _value, this, _extraData);
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
        return allowance[_owner][_spender];
    }
    
    /**
     * 
     * Destroy tokens
     * Remove '_value' tokens from the system irreversibly
     * 
     * @param _value the amount of money to burn
     */
    
    function burn(uint256 _value) public returns (bool success){
        require(balanceOf[msg.sender] >= _value); // check if sender has enough
        
        balanceOf[msg.sender] = balanceOf[msg.sender].esub(_value);
        totalSupply = totalSupply.esub(_value);
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
        require (totalSupply <= ceilingSupply);
        balanceOf[_target] = balanceOf[_target].eadd(_value);
        totalSupply = totalSupply.eadd(_value);
        emit Transfer(0, _ownerAddress, _value);
        emit Transfer(_ownerAddress, _target, _value);
        return true;
    }
    
    /**
     * Total mintableToken pending in the system 
     * 
     * 
    */
    function mintableToken() public constant returns(uint256 remaining){
        uint256 remain = ceilingSupply.esub(totalSupply);
        return remain;
    }
    
}