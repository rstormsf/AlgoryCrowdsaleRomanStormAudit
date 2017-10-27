pragma solidity ^0.4.15;

import '../../contracts/token/UpgradeableToken.sol';

contract UpgradeableTokenMock is UpgradeableToken {

    string public name = 'UpgradableMock';
    string public symbol = 'UMK';
    uint public decimals = 18;

    bool private upgradeAllowed = true;

    function UpgradeableTokenMock(address upgradeMaster) UpgradeableToken (upgradeMaster) {
        totalSupply = 120000000;
        balances[msg.sender] = totalSupply;
    }

    function allowUpgrade(bool val) external {
        require(msg.sender == upgradeMaster);
        upgradeAllowed = val;
    }

    function canUpgrade() public constant returns(bool) {
        return upgradeAllowed;
    }
}