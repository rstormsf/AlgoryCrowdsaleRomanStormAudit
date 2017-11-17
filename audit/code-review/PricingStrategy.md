#PricingStrategy
Source file [../../contracts/crowdsale/PricingStrategy.sol](../../contracts/crowdsale/PricingStrategy.sol).

the contract is being used as an interface.
In Solidity, there is keyword: interface which must be used instead of contract
Also, it shouldn't have any state variables and any implementations of any methods.

Probably more accurate comment would be either:
using interface or abstract contract

Abstract contract can't also have any implementations.
So in your case it's not either an interface nor contract.

So please choose how you want it to behave.


<br />

<hr />


```javascript
// RS Ok
contract PricingStrategy {

  // How many tokens per one investor is allowed in presale
  // RS Ok
  uint public presaleMaxValue = 0;
    // RS Ok
  function isPricingStrategy() external constant returns (bool) {
      // RS Ok
      return true;
  }
    // RS Ok
  function getPresaleMaxValue() public constant returns (uint) {
      // RS Ok
      return presaleMaxValue;
  }
    // RS Ok
  function isPresaleFull(uint weiRaised) public constant returns (bool);
    // RS Ok
  function getAmountOfTokens(uint value, uint weiRaised) public constant returns (uint tokensAmount);
}
```