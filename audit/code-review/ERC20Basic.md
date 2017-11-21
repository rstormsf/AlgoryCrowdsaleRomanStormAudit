# ERC20Basic 
Source file [../../contracts/token/ERC20Basic.sol](../../contracts/token/ERC20Basic.sol).


<br />

<hr />


```javascript
pragma solidity ^0.4.15;

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
 // RS Ok
contract ERC20Basic {
    // RS Ok
    uint256 public totalSupply;
    // RS Ok
    function balanceOf(address who) public constant returns (uint256);
    // RS Ok
    function transfer(address to, uint256 value) public returns (bool);
    // RS Ok
    event Transfer(address indexed from, address indexed to, uint256 value);
}
```