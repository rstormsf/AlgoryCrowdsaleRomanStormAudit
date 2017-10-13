

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

    /** Total percent of tokens minted to the team at the end of the sale as base points (0.0001) */
    uint public bonusBasePoints;

    /** Where we move the tokens at the end of the sale. */
    address public teamMultisig;

    /* How much bonus tokens we allocated */
    uint public allocatedBonus;

    function AlgoryFinalizeAgent(AlgoryToken _token, Crowdsale _crowdsale, uint _bonusBasePoints, address _teamMultisig) {
        token = _token;
        crowdsale = _crowdsale;
        if(address(crowdsale) == 0) {
            throw;
        }

        teamMultisig = _teamMultisig;
        if(address(teamMultisig) == 0) {
            throw;
        }

        bonusBasePoints = _bonusBasePoints;
    }

    /* Can we run finalize properly */
    function isSane() public constant returns (bool) {
        return (token.mintAgents(address(this)) == true) && (token.releaseAgent() == address(this));
    }

    /** Called once by crowdsale finalize() if the sale was success. */
    function finalizeCrowdsale() {
        if(msg.sender != address(crowdsale)) {
            throw;
        }

        // How many % of tokens the founders and others get
        uint tokensSold = crowdsale.tokensSold();
        allocatedBonus = tokensSold.times(bonusBasePoints) / 10000;

        // move tokens to the team multisig wallet
        token.mint(teamMultisig, allocatedBonus);

        // Make token transferable
        token.releaseTokenTransfer();
    }

}