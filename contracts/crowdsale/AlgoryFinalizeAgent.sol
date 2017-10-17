pragma solidity ^0.4.15;

import './FinalizeAgent.sol';
import '../math/SafeMathLib.sol';
import '../token/AlgoryToken.sol';
import '../crowdsale/Crowdsale.sol';

/**
 * At the end of the successful crowdsale allocate % bonus of tokens to the team.
 *
 * Unlock tokens.
 *
 * BonusAllocationFinal must be set as the minting agent for the MintableToken.
 *
 */
contract AlgoryFinalizeAgent is FinalizeAgent {

    using SafeMathLib for uint;

    AlgoryToken public token;
    Crowdsale public crowdsale;

    /** Where we move the tokens at the end of the sale. */
    address public teamMultisig;

    /* How much bonus tokens we allocated */
    uint public allocatedBonus;

    function AlgoryFinalizeAgent(AlgoryToken _token, Crowdsale _crowdsale, address _teamMultisig) {
        token = _token;
        crowdsale = _crowdsale;
        if(address(crowdsale) == 0) {
            revert();
        }

        teamMultisig = _teamMultisig;
        if(address(teamMultisig) == 0) {
            revert();
        }
    }

    /* Can we run finalize properly */
    function isSane() public constant returns (bool) {
        return token.releaseAgent() == address(this);
    }

    /** Called once by crowdsale finalize() if the sale was success. */
    function finalizeCrowdsale() {
        if(msg.sender != address(crowdsale)) {
            revert();
        }

        // Make token transferable
        token.releaseTokenTransfer();
    }

}