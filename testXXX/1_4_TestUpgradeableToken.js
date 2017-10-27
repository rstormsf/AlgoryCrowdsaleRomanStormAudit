'use strict';

const EVMThrow = require('./helpers/EVMThrow.js');
const tokenContract = artifacts.require('./mocks/UpgradeableTokenMock.sol');
const agentContract = artifacts.require('./token/UpgradeAgentMock.sol');

const BigNumber = web3.BigNumber;
require('chai')
    .use(require('chai-as-promised'))
    .use(require('chai-bignumber')(BigNumber))
    .should();
const expect = require('chai').expect;

contract('Test Upgradable Token', function(accounts) {
    let token;
    let totalSupply;

    beforeEach(async function() {
        token = await tokenContract.new(accounts[0]);
        totalSupply = await token.totalSupply();
    });

    it('should has proper upgradable master after create', async function() {
        let token = await tokenContract.new(accounts[0]);
        let master = await token.upgradeMaster();
        assert.equal(master, accounts[0]);
        token = await tokenContract.new(accounts[1]);
        master = await token.upgradeMaster();
        assert.equal(master, accounts[1]);
    });

    it('should set upgrade master', async function() {
        await token.setUpgradeMaster(accounts[1]);
        let master = await token.upgradeMaster();
        assert.equal(master, accounts[1]);
    });

    it("shouldn't set upgrade master if sender is not master", async function() {
        await token.setUpgradeMaster(accounts[2], {from: accounts[4]})
            .should.be.rejectedWith(EVMThrow)
    });

    it('should set upgrade agent', async function() {
        let agent = await agentContract.new(totalSupply);
        const { logs } = await token.setUpgradeAgent(agent.address);
        let expectedAgent = await token.upgradeAgent();
        assert.equal(agent.address, expectedAgent);
        const event = logs.find(e => e.event === 'UpgradeAgentSet');
        expect(event).to.exist;
    });

    it("shouldn't set invalid upgrade agent", async function() {
        let agent = await agentContract.new(1);
        await token.setUpgradeAgent(agent.address)
            .should.be.rejectedWith(EVMThrow);
        await token.setUpgradeAgent('0x3')
            .should.be.rejectedWith(EVMThrow)
    });

    it('should get proper state', async function() {
        state = await token.getUpgradeState();
        assert.equal(state.toNumber(), 2);
        let agent = await agentContract.new(totalSupply);

        await token.setUpgradeAgent(agent.address);
        state = await token.getUpgradeState();
        assert.equal(state.toNumber(), 3);

        await token.allowUpgrade(false);
        let state = await token.getUpgradeState();
        assert.equal(state.toNumber(), 1);
    });

    it('should upgrade some tokens', async function() {
        let agent = await agentContract.new(totalSupply);
        await token.setUpgradeAgent(agent.address);
        let initialBalance = await token.balanceOf(accounts[0]);
        let initTotalSupply = await token.totalSupply();
        let valueToUpgrade = initialBalance.minus(10);
        const { logs } = await token.upgrade(valueToUpgrade);

        let postBalance = await token.balanceOf(accounts[0]);
        postBalance.should.be.bignumber.equal(new BigNumber(10));

        let postTotalSupply = await token.totalSupply();
        postTotalSupply.should.be.bignumber.equal(initTotalSupply.minus(valueToUpgrade));

        let totalUpgraded = await token.totalUpgraded();
        totalUpgraded.should.be.bignumber.equal(valueToUpgrade);

        const event = logs.find(e => e.event === 'Upgrade');
        expect(event).to.exist;
    });

    it("shouldn't upgrade invalid amount of tokens", async function() {
        let agent = await agentContract.new(totalSupply);
        await token.setUpgradeAgent(agent.address);
        let initialBalance = await token.balanceOf(accounts[0]);
        let valueToUpgrade = initialBalance.plus(10);
        await token.upgrade(valueToUpgrade)
            .should.be.rejectedWith(EVMThrow)
    });

    it('should get proper upgrading state', async function() {
        let agent = await agentContract.new(totalSupply);
        await token.setUpgradeAgent(agent.address);
        let initialBalance = await token.balanceOf(accounts[0]);
        await token.upgrade(initialBalance.minus(10));

        let state = await token.getUpgradeState();
        assert.equal(state.toNumber(), 4);
    });
});
