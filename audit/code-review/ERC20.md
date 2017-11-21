# ERC20 
Source file [../../contracts/token/ERC20.sol](../../contracts/token/ERC20.sol).


<br />

<hr />


```javascript
// RS Ok
pragma solidity ^0.4.15;
// RS Ok
import './ERC20Basic.sol';

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
 // RS Ok
contract ERC20 is ERC20Basic {
    // RS Ok
    function allowance(address owner, address spender) public constant returns (uint256);
    // RS Ok
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    // RS Ok
    function approve(address spender, uint256 value) public returns (bool);
    // RS Ok
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
```