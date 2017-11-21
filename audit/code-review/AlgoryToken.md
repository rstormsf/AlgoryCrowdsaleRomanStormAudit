# AlgoryToken 
Source file [../../contracts/token/AlgoryToken.sol](../../contracts/token/AlgoryToken.sol).


<br />

<hr />



```javascript
// RS Ok
pragma solidity ^0.4.15;
// RS Ok
import './CrowdsaleToken.sol';
// RS Ok
import './UpgradeableToken.sol';

/**
 * A Algory token.
 *
 */
 // RS Ok
contract AlgoryToken is UpgradeableToken, CrowdsaleToken {
    // RS Ok
    string public name = 'Algory';
    // RS Ok
    string public symbol = 'ALG';
    // RS Ok
    uint public decimals = 18;
    // RS Ok
    uint256 public INITIAL_SUPPLY = 120000000 * (10 ** uint256(decimals));
    // RS Ok
    event UpdatedTokenInformation(string newName, string newSymbol);
    // RS Ok
    function AlgoryToken() UpgradeableToken(msg.sender) {
        // RS Ok
        owner = msg.sender;
        // RS Ok
        totalSupply = INITIAL_SUPPLY;
        // RS Ok
        require(totalSupply > 0);
        // RS Ok
        balances[owner] = totalSupply;
    }
    // RS Ok
    function canUpgrade() public constant returns(bool) {
        // RS Ok
        return released && super.canUpgrade();
    }
    // RS Ok
    function setTokenInformation(string _name, string _symbol) onlyOwner {
        // RS Ok
        name = _name;
        // RS Ok
        symbol = _symbol;
        // RS Ok
        UpdatedTokenInformation(name, symbol);
    }

}
```