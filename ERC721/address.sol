pragma solidity >=0.4.0 <0.6.0;

/**
 * 
 * utility library of inline functions on addresses
*/

library Address{
    
    /**
     * Returns wether the target address in contract or not
     * @dev This function will return false if invoked during the constructor of a contract
     * as the code is not created until after the constructor finishes
     * @param account address of the account to check 
     * @return whether target address is a contract
    */
    
    function isContract(address account) internal view returns (bool){
        uint256 size;
        assembly {size := extcodesize(account)}
        return size > 0;
    }
}
 