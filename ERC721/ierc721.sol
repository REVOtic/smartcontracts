pragma solidity >=0.4.0 <0.6.0;


// importing erc 165 interface
import "./ierc165.sol";

/**
 * @title ERC 721 non-fungible token standard basic interface
 * 
*/


contract IERC721 is IERC165{
    
  function balanceof(address owner) public view returns(uint256 balance);
  function ownerof(uint256 tokenId) public view returns(address owner);
  
  function approve(address to, uint256 tokenId) public;
  function getApproved(uint256 tokenId) public view returns(address operator);
  
  function setApprovalForAll(address operator, bool _approved) public;
  function isApprovedForAll(address owner, address operator) public view returns(bool);
  
  function transferFrom(address from, address to, uint256 tokenId) public;
  function safeTransferFrom(address from, address to, uint256 tokenId) public;
  
  function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
  
  event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
  event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
  event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    
}
