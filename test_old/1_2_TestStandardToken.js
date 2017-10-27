'use strict';

const assertJump = require('./helpers/assertJump');
const expectThrow = require('./helpers/expectThrow');
const tokenContract = artifacts.require('./mocks/StandardTokenMock.sol');

contract('Test Standard Token', function(accounts) {
    let token;
    const totalSupply = 120000000;

    beforeEach(async function() {
        token = await tokenContract.new();
    });

    it('should return the correct totalSupply after construction', async function() {
        let supply = await token.totalSupply();
        assert.equal(supply, totalSupply);
    });

    it('should return the correct allowance amount after approval', async function() {
        let token = await tokenContract.new();
        await token.approve(accounts[1], 100);
        let allowance = await token.allowance(accounts[0], accounts[1]);

        assert.equal(allowance, 100);
    });

    it('should return correct balances after transfer', async function() {
        let token = await tokenContract.new();
        await token.transfer(accounts[1], 100);
        let balance0 = await token.balanceOf(accounts[0]);
        assert.equal(balance0, totalSupply - 100);

        let balance1 = await token.balanceOf(accounts[1]);
        assert.equal(balance1, 100);
    });

    it('should throw an error when trying to transfer more than balance', async function() {
        let token = await tokenContract.new();
        try {
            await token.transfer(accounts[1], 1200000000 * 10**18);
            assert.fail('should have thrown before');
        } catch(error) {
            assertJump(error);
        }
    });

    it('should return correct balances after transfering from another account', async function() {
        let token = await tokenContract.new();
        await token.approve(accounts[1], 100);
        await token.transferFrom(accounts[0], accounts[2], 100, {from: accounts[1]});

        let balance0 = await token.balanceOf(accounts[0]);
        assert.equal(balance0, totalSupply - 100);

        let balance1 = await token.balanceOf(accounts[2]);
        assert.equal(balance1, 100);

        let balance2 = await token.balanceOf(accounts[1]);
        assert.equal(balance2, 0);
    });

    it('should throw an error when trying to transfer more than allowed', async function() {
        await token.approve(accounts[1], 99);
        try {
            await token.transferFrom(accounts[0], accounts[2], 100, {from: accounts[1]});
            assert.fail('should have thrown before');
        } catch (error) {
            assertJump(error);
        }
    });

    it('should throw an error when trying to transferFrom more than _from has', async function() {
        let balance0 = await token.balanceOf(accounts[0]);
        await token.approve(accounts[1], balance0-100);
        try {
            await token.transferFrom(accounts[0], accounts[2], balance0+100, {from: accounts[1]});
            assert.fail('should have thrown before');
        } catch (error) {
            assertJump(error);
        }
    });

    describe('validating allowance updates to spender', function() {
        let preApproved;

        it('should start with zero', async function() {
            preApproved = await token.allowance(accounts[0], accounts[1]);
            assert.equal(preApproved, 0);
        })

        it('should increase by 50 then decrease by 10', async function() {
            await token.increaseApproval(accounts[1], 50);
            let postIncrease = await token.allowance(accounts[0], accounts[1]);
            assert.equal(preApproved.toNumber() + 50, postIncrease.toNumber());
            await token.decreaseApproval(accounts[1], 10);
            let postDecrease = await token.allowance(accounts[0], accounts[1]);
            assert.equal(postIncrease.toNumber()-10, postDecrease.toNumber());
        })
    });

    it('should increase by 50 then set to 0 when decreasing by more than 50', async function() {
        await token.approve(accounts[1], 50);
        await token.decreaseApproval(accounts[1], 60);
        let postDecrease = await token.allowance(accounts[0], accounts[1]);
        assert.equal(postDecrease, 0);
    });

    it('should throw an error when trying to transfer to 0x0', async function() {
        let token = await tokenContract.new(accounts[0], 100);
        try {
            let transfer = await token.transfer(0x0, 100);
            assert.fail('should have thrown before');
        } catch(error) {
            assertJump(error);
        }
    });

    it('should throw an error when trying to transferFrom to 0x0', async function() {
        let token = await tokenContract.new(accounts[0], 100);
        await token.approve(accounts[1], 100);
        try {
            let transfer = await token.transferFrom(accounts[0], 0x0, 100, {from: accounts[1]});
            assert.fail('should have thrown before');
        } catch(error) {
            assertJump(error);
        }
    });
});
