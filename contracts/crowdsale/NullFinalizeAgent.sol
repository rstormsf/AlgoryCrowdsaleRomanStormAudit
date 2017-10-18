pragma solidity ^0.4.15;

import './FinalizeAgent.sol';
import '../math/SafeMathLib.sol';
import '../AlgoryCrowdsale.sol';

/**
 * A finalize agent that does nothing.
 *
 * - Token transfer must be manually released by the owner
 */
contract NullFinalizeAgent is FinalizeAgent {

    AlgoryCrowdsale public crowdsale;

    function NullFinalizeAgent(AlgoryCrowdsale _crowdsale) {
        crowdsale = _crowdsale;
    }

    function isSane() public constant returns (bool) {
        return crowdsale.finalizeAgent() == address(this);
    }

    /** Called once by crowdsale finalize() if the sale was success. */
    function finalizeCrowdsale() public {
    }

}