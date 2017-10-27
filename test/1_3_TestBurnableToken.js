'use strict';

const tokenContract = artifacts.require('./mocks/BurnableTokenMock.sol');

const BigNumber = web3.BigNumber;
require('chai')
    .use(require('chai-as-promised'))
    .use(require('chai-bignumber')(BigNumber))
    .should();

import isEventTriggered from './helpers/isEventTriggered'
import EVMThrow from './helpers/EVMThrow'

contract('Test Burnable Token', function(accounts) {
    let token;

    beforeEach(async function() {
        token = await tokenContract.new();
    });

    it('should burn some tokens by owner', async function() {
        let initTotalSupplay = await token.totalSupply();
        let initBalance = await token.balanceOf(accounts[0]);
        let {logs} = await token.burn(100);

        assert.ok(isEventTriggered(logs, 'Burn'));

        let postBalance = await token.balanceOf(accounts[0]);
        postBalance.should.be.bignumber.equal(initBalance.minus(100));

        let postTotalSupply = await token.totalSupply();
        postTotalSupply.should.be.bignumber.equal(initTotalSupplay.minus(100));
    });

    it('should burn some tokens by another owner', async function() {
        await token.transfer(accounts[1], 100);
        let initTotalSupplay = await token.totalSupply();
        let initBalance = await token.balanceOf(accounts[1]);
        await token.burn(50, {from: accounts[1]});
        let postBalance = await token.balanceOf(accounts[1]);
        postBalance.should.be.bignumber.equal(initBalance.minus(50));
        let postTotalSupply = await token.totalSupply();
        postTotalSupply.should.be.bignumber.equal(initTotalSupplay.minus(50));
    });

    it("should't burn more tokens then sender own", async function () {
        let initBalance = await token.balanceOf(accounts[0]);
        await token.burn(initBalance.plus(1))
            .should.be.rejectedWith(EVMThrow)
    })
});
