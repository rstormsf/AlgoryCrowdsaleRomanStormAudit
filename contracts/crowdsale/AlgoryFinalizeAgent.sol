pragma solidity ^0.4.15;

import './FinalizeAgent.sol';
import './AlgoryCrowdsale.sol';
import '../math/SafeMathLib.sol';
import '../token/AlgoryToken.sol';

/**
 * At the end of the successful crowdsale unlock tokens transfer.
 *
 */
contract AlgoryFinalizeAgent is FinalizeAgent {

    using SafeMathLib for uint;

    AlgoryToken public token;
    AlgoryCrowdsale public crowdsale;

    function AlgoryFinalizeAgent(AlgoryToken _token, AlgoryCrowdsale _crowdsale) {
        token = _token;
        crowdsale = _crowdsale;
        if(address(token) == 0 || address(crowdsale) == 0) revert();
    }

    /* Can we run finalize properly */
    function isSane() public constant returns (bool) {
        return token.releaseAgent() == address(this);
    }

    /** Called once by crowdsale finalize() if the sale was success. */
    function finalizeCrowdsale() {
        if(msg.sender != address(crowdsale)) revert();

        // Make token transferable
        token.releaseTokenTransfer();
    }

}