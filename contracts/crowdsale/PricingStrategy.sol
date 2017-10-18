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

  /** Self check if all references are correctly set.
   *
   * Checks that pricing strategy matches crowdsale parameters.
   */
  function isSane(address crowdsale) public constant returns (bool) {
    return true;
  }

  function isPresaleFull(uint weiRaised) public constant returns (bool) {
    return false;
  }

  function getPresaleMaxValue() public constant returns (uint) {
    return presaleMaxValue;
  }

  /**
   * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
   *
   * @param value - What is the value of the transaction send in as wei
   * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
   * @param decimals - how many decimal units the token has
   * @return Amount of tokens the investor receives
   */
  function calculatePrice(uint value, uint weiRaised, uint decimals) public constant returns (uint tokenAmount);
}