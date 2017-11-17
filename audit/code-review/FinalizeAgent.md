# FinalizeAgent
Source file [../../contracts/crowdsale/FinalizeAgent.sol](../../contracts/crowdsale/FinalizeAgent.sol).


<br />

<hr />

```javascript
// RS Ok
pragma solidity ^0.4.15;

/**
 * Finalize agent defines what happens at the end of successful crowdsale.
 * Allocate tokens for founders, bounties and community
 */
// RS Ok
contract FinalizeAgent {
    // RS Ok
  function isFinalizeAgent() public constant returns(bool) {
      // RS Ok
    return true;
  }

  /** Return true if we can run finalizeCrowdsale() properly.
   *
   * This is a safety check function that doesn't allow crowdsale to begin
   * unless the finalizer has been set up properly.
   */
  // RS Ok
  function isSane() public constant returns (bool);

  /** Called once by crowdsale finalize() if the sale was success. */
  // RS Ok
  function finalizeCrowdsale();

}
```