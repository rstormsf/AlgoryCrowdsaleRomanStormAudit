pragma solidity ^0.4.15;

import '../../contracts/math/SafeMath.sol';

contract SafeMathMock {
    uint256 public result;

    function multiply(uint256 a, uint256 b) {
        result = SafeMath.mul(a, b);
    }

    function divide(uint256 a, uint256 b) {
        result = SafeMath.div(a, b);
    }

    function subtract(uint256 a, uint256 b) {
        result = SafeMath.sub(a, b);
    }

    function add(uint256 a, uint256 b) {
        result = SafeMath.add(a, b);
    }
}