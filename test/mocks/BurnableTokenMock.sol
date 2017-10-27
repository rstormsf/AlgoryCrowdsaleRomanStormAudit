pragma solidity ^0.4.15;

import '../../contracts/token/BurnableToken.sol';

contract BurnableTokenMock is BurnableToken {

    string public name = 'BurnableMock';
    string public symbol = 'BMK';
    uint public decimals = 18;

    function BurnableTokenMock() {
        totalSupply = 120000000;
        balances[msg.sender] = totalSupply;
    }
}