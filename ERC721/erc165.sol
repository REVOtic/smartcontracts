pragma solidity >=0.4.0 <0.6.0;

import "./ierc165.sol";


contract ERC165 is IERC165{
    bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
    
    /**
     * 0x01ffc9a7 === bytes4(keccak256('supportsInterface(bytes4)'))
     * 
    */
    
    /**
     * @dev a mapping of interface id to whether or not it's supported
     */
     
    mapping (bytes4 => bool) private _supportedInterfaces;
    
    
    /**
     * @dev A contract implementing supportsInterfaceWithLookup
     * implement ERC165 itself
     */
    
    constructor () internal{
        _registerInterface(_InterfaceId_ERC165);
    }
    
    /**
     * @dev implement supportsInterface(bytes4) using a lookup table
     * 
     */
    
    function supportsInterface(bytes4 interfaceId) external view returns(bool){
        return _supportedInterfaces[interfaceId];
    }
    
    
    function _registerInterface(bytes4 interfaceId) internal{
        require(interfaceId != 0xffffffff);
        _supportedInterfaces[interfaceId] = true;
    }
}