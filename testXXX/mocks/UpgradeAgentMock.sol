pragma solidity ^0.4.15;

import '../../contracts/token/UpgradeAgent.sol';

contract UpgradeAgentMock is UpgradeAgent {

    function UpgradeAgentMock(uint _originalSupply) {
        assert(_originalSupply > 0);
        originalSupply = _originalSupply;
    }

    function upgradeFrom(address _from, uint256 _value) public {
        //nothing to do
    }
}