'use strict';

const tokenContract = artifacts.require('./mocks/StandardTokenMock.sol');

const BigNumber = web3.BigNumber;
import EVMThrow from './helpers/EVMThrow'

contract('Test Standard Token', function(accounts) {
    let token;
    const totalSupply = new BigNumber(120000000);

    beforeEach(async function() {
        token = await tokenContract.new();
    });

    it('should return the correct totalSupply after construction', async function() {
        let supply = await token.totalSupply();
        supply.should.be.bignumber.equal(totalSupply)
    });

    it('should return the correct allowance amount after approval', async function() {
        await token.approve(accounts[1], 100);
        let allowance = await token.allowance(accounts[0], accounts[1]);

        assert.equal(allowance, 100);
    });

    it('should return correct balances after transfer', async function() {
        await token.transfer(accounts[1], 100);
        let balance0 = await token.balanceOf(accounts[0]);
        assert.equal(balance0, totalSupply - 100);

        let balance1 = await token.balanceOf(accounts[1]);
        assert.equal(balance1, 100);
    });

    it('should throw an error when trying to transfer more than balance', async function() {
        await token.transfer(accounts[1], totalSupply.plus(1))
            .should.be.rejectedWith(EVMThrow)
    });

    it('should return correct balances after transfering from another account', async function() {
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
        await token.transferFrom(accounts[0], accounts[2], 100, {from: accounts[1]})
            .should.be.rejectedWith(EVMThrow);
    });

    it('should throw an error when trying to transferFrom more than _from has', async function() {
        let balance0 = await token.balanceOf(accounts[0]);
        await token.approve(accounts[1], balance0-100);
        await token.transferFrom(accounts[0], accounts[2], balance0+100, {from: accounts[1]})
            .should.be.rejectedWith(EVMThrow);
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
            preApproved.plus(50).should.be.bignumber.equal(postIncrease);
            await token.decreaseApproval(accounts[1], 10);
            let postDecrease = await token.allowance(accounts[0], accounts[1]);
            postIncrease.minus(10).should.be.bignumber.equal(postDecrease);
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
        await token.transfer(0x0, 100)
            .should.be.rejectedWith(EVMThrow);
    });

    it('should throw an error when trying to transferFrom to 0x0', async function() {
        let token = await tokenContract.new(accounts[0], 100);
        await token.approve(accounts[1], 100);
        await token.transferFrom(accounts[0], 0x0, 100, {from: accounts[1]})
            .should.be.rejectedWith(EVMThrow)
    });
});
