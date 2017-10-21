pragma solidity ^0.4.15;

/**
 * Interface for defining crowdsale pricing.
 */
contract PricingStrategy {

  // How many tokens investor can buy in presale
  uint public presaleMaxValue = 0;

  /** Interface declaration. */
  function isPricingStrategy() public constant returns (bool) {
    return true;
  }

  function getPresaleMaxValue() public constant returns (uint) {
    return presaleMaxValue;
  }

  function isSane(address crowdsale) public constant returns (bool);

  function isPresaleFull(uint weiRaised) public constant returns (bool);

  function calculatePrice(uint value, uint weiRaised, uint decimals) public constant returns (uint tokenAmount);
}