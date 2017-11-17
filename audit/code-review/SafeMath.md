#InvestmentPolicyCrowdsale
Source file [../../contracts/math/SafeMath.sol](../../contracts/math/SafeMath.sol).


<br />

<hr />

```javascript
pragma solidity ^0.4.15;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
 // RS Ok
library SafeMath {
    // RS Ok
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
      // RS Ok
    uint256 c = a * b;
    // RS Ok
    assert(a == 0 || c / a == b);
    // RS Ok
    return c;
  }
    // RS Ok
  function div(uint256 a, uint256 b) internal constant returns (uint256) {
      
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // RS Ok
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    // RS Ok
    return c;
  }
// RS Ok
  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
      // RS Ok
    assert(b <= a);
    // RS Ok
    return a - b;
  }
    // RS Ok
  function add(uint256 a, uint256 b) internal constant returns (uint256) {
      // RS Ok
    uint256 c = a + b;
    // RS Ok
    assert(c >= a);
    // RS Ok
    return c;
  }
}
```