'use strict';

const assertJump = require('../test/helpers/assertJump');
const tokenContract = artifacts.require('./mocks/BurnableTokenMock.sol');

contract('Test Burnable Token', function(accounts) {
    let token;

    beforeEach(async function() {
        token = await tokenContract.new();
    });

    it('should burn some tokens by owner', async function() {
        let initTotalSupplay = await token.totalSupply();
        let initBalance = await token.balanceOf(accounts[0]);
        await token.burn(100);
        let postBalance = await token.balanceOf(accounts[0]);
        assert.deepEqual(postBalance, initBalance.minus(100));
        let postTotalSupply = await token.totalSupply();
        assert.deepEqual(postTotalSupply, initTotalSupplay.minus(100))
    });

    it('should burn some tokens by another owner', async function() {
        await token.transfer(accounts[1], 100);
        let initTotalSupplay = await token.totalSupply();
        let initBalance = await token.balanceOf(accounts[1]);
        await token.burn(50, {from: accounts[1]});
        let postBalance = await token.balanceOf(accounts[1]);
        assert.deepEqual(postBalance, initBalance.minus(50));
        let postTotalSupply = await token.totalSupply();
        assert.deepEqual(postTotalSupply, initTotalSupplay.minus(50))
    });

    it("should't burn more tokens then sender own", async function () {
        let initBalance = await token.balanceOf(accounts[0]);
        try {
            await token.burn(initBalance.plus(100));
            assert.fail('should have thrown before');
        } catch(error) {
            assertJump(error);
        }
    })
});
