pragma solidity ^0.4.15;

import './ReleasableToken.sol';
import './UpgradeableToken.sol';
import './FractionalERC20.sol';
import './BurnableToken.sol';

/**
 * A Algory token.
 *
 */
contract AlgoryToken is FractionalERC20, ReleasableToken, UpgradeableToken, BurnableToken {

    /** Name and symbol were updated. */
    event UpdatedTokenInformation(string newName, string newSymbol);

    string public name = 'Algory';
    string public symbol = 'ALG';
    uint public decimals = 18;

    /**
     * Construct the token.
     *
     * This token must be created through a team multisig wallet, so that it is owned by that wallet.
     *
     * @param _initialSupply How many tokens we start with
     */
    function AlgoryToken(uint _initialSupply) UpgradeableToken(msg.sender) {

        owner = msg.sender;
        totalSupply = _initialSupply;

        // Create initially all balance on the team multisig
        balances[owner] = totalSupply;

        if(totalSupply > 0) {
            Minted(owner, totalSupply);
        }
    }

    /**
     * When token is released to be transferable, enforce no new tokens can be created.
     */
    function releaseTokenTransfer() public onlyReleaseAgent {
        super.releaseTokenTransfer();
    }

    /**
     * Allow upgrade agent functionality kick in only if the crowdsale was success.
     */
    function canUpgrade() public constant returns(bool) {
        return released && super.canUpgrade();
    }

    /**
     * Owner can update token information here.
     *
     * It is often useful to conceal the actual token association, until
     * the token operations, like central issuance or reissuance have been completed.
     *
     * This function allows the token owner to rename the token after the operations
     * have been completed and then point the audience to use the token contract.
     */
    function setTokenInformation(string _name, string _symbol) onlyOwner {
        name = _name;
        symbol = _symbol;

        UpdatedTokenInformation(name, symbol);
    }

}