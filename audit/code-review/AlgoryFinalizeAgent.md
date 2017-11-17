# AlgoryFinalizeAgent 
Source file [../../contracts/crowdsale/AlgoryFinalizeAgent.sol](../../contracts/crowdsale/AlgoryFinalizeAgent.sol).


<br />

<hr />


```javascript
// RS Ok
pragma solidity ^0.4.15;
// RS Ok
import './FinalizeAgent.sol';
import './AlgoryCrowdsale.sol';
import '../math/SafeMath.sol';
import '../token/AlgoryToken.sol';

/**
 * At the end of the successful crowdsale unlock tokens transfer.
 *
 */
// RS Ok
contract AlgoryFinalizeAgent is FinalizeAgent {
    // RS Ok
    using SafeMath for uint;
    // RS Ok
    AlgoryToken public token;
    // RS Ok
    AlgoryCrowdsale public crowdsale;
    // RS Ok
    function AlgoryFinalizeAgent(AlgoryToken _token, AlgoryCrowdsale _crowdsale) {
        // RS Ok
        token = _token;
        // RS Ok
        crowdsale = _crowdsale;
        // RS Ok. Preference to move it to the top
        require(address(token) != 0x0 && address(crowdsale) != 0x0);
    }

    /* Can we run finalize properly */
    // RS Ok
    function isSane() public constant returns (bool) {
        // RS Ok
        return token.releaseAgent() == address(this) && crowdsale.finalizeAgent() == address(this);
    }

    /** Called once by crowdsale finalize() if the sale was success. */
    // RS Ok
    function finalizeCrowdsale() public {
        // RS Ok
        require(msg.sender == address(crowdsale));

        // Make token transferable
        // RS Ok
        token.releaseTokenTransfer();
    }

}
```