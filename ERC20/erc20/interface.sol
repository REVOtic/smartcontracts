pragma solidity ^0.4.21;


contract demoInterface{
    
    //total amount of tokens
    function totalSupply() constant public returns (uint256 _totalSupply);
    
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
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success);
    
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
    
    
    function mintableToken() public constant returns(uint256 remaining);

    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed from, uint256 value);

}
