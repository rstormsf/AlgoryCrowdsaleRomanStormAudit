# CrowdsaleToken 
Source file [../../contracts/token/CrowdsaleToken.sol](../../contracts/token/CrowdsaleToken.sol).


<br />

<hr />


```javascript
// RS Ok
pragma solidity ^0.4.15;
// RS Ok
import './ReleasableToken.sol';
// RS Ok
import './BurnableToken.sol';

/**
 * Base crowdsale token interface
 */
 // RS Ok
contract CrowdsaleToken is BurnableToken, ReleasableToken {
    // RS Ok
    uint public decimals;
}
```