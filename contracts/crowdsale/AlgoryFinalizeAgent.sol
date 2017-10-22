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
        require(address(token) != 0x0 && address(crowdsale) != 0x0);
    }

    /* Can we run finalize properly */
    function isSane() public constant returns (bool) {
        return token.releaseAgent() == address(this);
    }

    /** Called once by crowdsale finalize() if the sale was success. */
    function finalizeCrowdsale() {
        require(msg.sender == address(crowdsale));

        // Make token transferable
        token.releaseTokenTransfer();
    }

}