pragma solidity ^0.4.21;

library safeMath {
    int256 constant private INT256_MIN = -2**255;
    
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
