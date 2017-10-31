'use strict';

let crowdsaleContract = artifacts.require('./crowdsale/AlgoryCrowdsale.sol');
let tokenContract = artifacts.require('./token/AlgoryToken.sol');
let pricingStrategyContract = artifacts.require('./crowdsale/AlgoryPricingStrategy.sol');
let finalizeAgentContract = artifacts.require('./crowdsale/AlgoryFinalizeAgent.sol');

const BigNumber = web3.BigNumber;
require('chai')
    .use(require('chai-as-promised'))
    .use(require('chai-bignumber')(BigNumber))
    .should();

import latestTime from './helpers/latestTime'
import ether from './helpers/ether'
import {duration} from './helpers/duration'
import {constants} from './helpers/constants'
import isEventTriggered from './helpers/isEventTriggered'
const EVMThrow = require('./helpers/EVMThrow');

contract('Test Algory Crowdsale Investment Policy', function(accounts) {
    const beneficiary = accounts[0];
    const multisigWallet = accounts[accounts.length-1];

    let crowdsale, pricingStrategy, finalizeAgent, algory;

    before(async function() {
        let presaleStartsAt = latestTime() + duration.minutes(10);
        const startsAt = presaleStartsAt + duration.days(10);
        const endsAt = startsAt + duration.days(10);

        algory = await tokenContract.new();
        pricingStrategy = await pricingStrategyContract.deployed();
        crowdsale = await crowdsaleContract.new(
            algory.address,
            beneficiary,
            pricingStrategy.address,
            multisigWallet,
            presaleStartsAt,
            startsAt,
            endsAt);
        finalizeAgent = await finalizeAgentContract.new(algory.address, crowdsale.address);
        await algory.setReleaseAgent(finalizeAgent.address);
        await crowdsale.setFinalizeAgent(finalizeAgent.address);
        await algory.setTransferAgent(beneficiary, true);
        await algory.approve(crowdsale.address, constants.totalSupply);
        await crowdsale.prepareCrowdsale();

        await crowdsale.setPresaleStartsAt(latestTime() - duration.days(3));
        await crowdsale.setStartsAt(latestTime());
    });
    
    it("should set required customer id", async function () {
        let {logs} = await crowdsale.setRequireCustomerId(true);
        assert.ok(isEventTriggered(logs, 'InvestmentPolicyChanged'));
        let isRequiredCustomerId = await crowdsale.requireCustomerId();
        isRequiredCustomerId.should.be.true;
    });

    it("should set not required customer id", async function () {
        let {logs} = await crowdsale.setRequireCustomerId(true);
        assert.ok(isEventTriggered(logs, 'InvestmentPolicyChanged'));
        let isRequiredCustomerId = await crowdsale.requireCustomerId();
        isRequiredCustomerId.should.be.true;
        let result = await crowdsale.setRequireCustomerId(false);
        assert.ok(isEventTriggered(result.logs, 'InvestmentPolicyChanged'));
        isRequiredCustomerId = await crowdsale.requireCustomerId();
        isRequiredCustomerId.should.be.false;
    });
    
    it("should set required signed address", async function () {
        let signedAddress = accounts[2];
        let {logs} = await crowdsale.setRequireSignedAddress(true, signedAddress);
        assert.ok(isEventTriggered(logs, 'InvestmentPolicyChanged'));

        let currentSignerAddress = await crowdsale.signerAddress();
        assert.equal(currentSignerAddress, signedAddress);

        let isRequiredSignedAddress = await crowdsale.requiredSignedAddress();
        isRequiredSignedAddress.should.be.true;
    });

    it("should set not required signed address", async function () {
        let signedAddress = accounts[2];
        let {logs} = await crowdsale.setRequireSignedAddress(true, signedAddress);
        assert.ok(isEventTriggered(logs, 'InvestmentPolicyChanged'));

        let currentSignerAddress = await crowdsale.signerAddress();
        assert.equal(currentSignerAddress, signedAddress);
        let isRequiredSignedAddress = await crowdsale.requiredSignedAddress();
        isRequiredSignedAddress.should.be.true;

        let result = await crowdsale.setRequireSignedAddress(false, signedAddress);
        assert.ok(isEventTriggered(result.logs, 'InvestmentPolicyChanged'));
        isRequiredSignedAddress = await crowdsale.requiredSignedAddress();
        isRequiredSignedAddress.should.be.false;
    });

    it("should buy with customer id", async function () {
        await crowdsale.setRequireCustomerId(true);
        let investor = accounts[3];
        let investorId = 77;
        let valueToBuy = ether(10);
        let expectedAmountOfTokens = new BigNumber(12000 * 10**18);
        let {logs} = await crowdsale.buyWithCustomerId(investorId, {from: investor, value: valueToBuy});
        assert.ok(isEventTriggered(logs, 'Invested'));

        let currentBalanceOf = await algory.balanceOf(investor);
        currentBalanceOf.should.be.bignumber.equal(expectedAmountOfTokens);

        //another investor
        investor = accounts[7];
        investorId = 9;
        valueToBuy = ether(100);
        expectedAmountOfTokens = new BigNumber(120000 * 10**18);
        let result = await crowdsale.buyWithCustomerId(investorId, {from: investor, value: valueToBuy});
        assert.ok(isEventTriggered(result.logs, 'Invested'));

        currentBalanceOf = await algory.balanceOf(investor);
        currentBalanceOf.should.be.bignumber.equal(expectedAmountOfTokens);
    });

    it("shouldn't buy without customer id when it is required", async function () {
        await crowdsale.setRequireCustomerId(true);
        let investor = accounts[3];
        let valueToBuy = ether(10);
        await crowdsale.sendTransaction({from: investor, value: valueToBuy})
            .should.be.rejectedWith(EVMThrow);
    });

    it("shouldn't buy with customer id when it is not required", async function () {
        await crowdsale.setRequireCustomerId(false);
        let isRequiredCustomerId = await crowdsale.requireCustomerId();
        isRequiredCustomerId.should.be.false;

        let investor = accounts[3];
        let valueToBuy = ether(10);
        await crowdsale.buyWithCustomerId(8, {from: investor, value: valueToBuy})
            .should.be.rejectedWith(EVMThrow);
    });

    it("shouldn't buy with customer id = 0", async function () {
        await crowdsale.setRequireCustomerId(true);
        let investor = accounts[3];
        let valueToBuy = ether(10);
        await crowdsale.buyWithCustomerId(0, {from: investor, value: valueToBuy})
            .should.be.rejectedWith(EVMThrow);
    });

    it("should buy with signed address", async function () {
        let signedAddress = accounts[10];
        await crowdsale.setRequireSignedAddress(true, signedAddress);
        let isRequiredSignedAddress = await crowdsale.requiredSignedAddress();
        isRequiredSignedAddress.should.be.true;

        let investor = accounts[15];
        let investorId = 13;
        let investorAddress = web3.sha3(investor, {encoding: 'hex'});
        let signature = await web3.eth.sign(signedAddress, investorAddress).slice(2);
        let r = "0x" + signature.slice(0, 64);
        let s = "0x" + signature.slice(64, 128);
        let v = signature.slice(128);
        v = parseInt(v) + 27;
        let valueToBuy = ether(10);
        let expectedAmountOfTokens = new BigNumber(12000 * 10**18);

        await crowdsale.buyWithSignedAddress(investorId, v, r, s, {from: investor, value: valueToBuy});

        let currentBalanceOf = await algory.balanceOf(investor);
        currentBalanceOf.should.be.bignumber.equal(expectedAmountOfTokens);
    });

    it("should buy with another signed address", async function () {
        let signedAddress = accounts[19];
        await crowdsale.setRequireSignedAddress(true, signedAddress);
        let isRequiredSignedAddress = await crowdsale.requiredSignedAddress();
        isRequiredSignedAddress.should.be.true;

        let investor = accounts[18];
        let investorId = 13;
        let investorAddress = web3.sha3(investor, {encoding: 'hex'});
        let signature = await web3.eth.sign(signedAddress, investorAddress).slice(2);
        let r = "0x" + signature.slice(0, 64);
        let s = "0x" + signature.slice(64, 128);
        let v = signature.slice(128);
        v = parseInt(v) + 27;
        let valueToBuy = ether(7);
        let expectedAmountOfTokens = valueToBuy.times(1200);

        await crowdsale.buyWithSignedAddress(investorId, v, r, s, {from: investor, value: valueToBuy});

        let currentBalanceOf = await algory.balanceOf(investor);
        currentBalanceOf.should.be.bignumber.equal(expectedAmountOfTokens);
    });

    it("shouldn't buy with signed address without investor ID", async function () {
        let signedAddress = accounts[19];
        await crowdsale.setRequireSignedAddress(true, signedAddress);
        let isRequiredSignedAddress = await crowdsale.requiredSignedAddress();
        isRequiredSignedAddress.should.be.true;

        let investor = accounts[17];
        let investorId = 0;
        let investorAddress = web3.sha3(investor, {encoding: 'hex'});
        let signature = await web3.eth.sign(signedAddress, investorAddress).slice(2);
        let r = "0x" + signature.slice(0, 64);
        let s = "0x" + signature.slice(64, 128);
        let v = signature.slice(128);
        v = parseInt(v) + 27;
        let valueToBuy = ether(7);

        await crowdsale.buyWithSignedAddress(investorId, v, r, s, {from: investor, value: valueToBuy})
            .should.be.rejectedWith(EVMThrow);
    });


    it("shouldn't buy without signed address", async function () {
        let signedAddress = accounts[10];
        await crowdsale.setRequireSignedAddress(true, signedAddress);
        let isRequiredSignedAddress = await crowdsale.requiredSignedAddress();
        isRequiredSignedAddress.should.be.true;

        let investor = accounts[3];
        let valueToBuy = ether(10);
        await crowdsale.sendTransaction({from: investor, value: valueToBuy})
            .should.be.rejectedWith(EVMThrow);
    });

    it("shouldn't buy with signed address when it is not required", async function () {
        let signedAddress = accounts[10];
        await crowdsale.setRequireSignedAddress(false, signedAddress);
        let isRequiredSignedAddress = await crowdsale.requiredSignedAddress();
        isRequiredSignedAddress.should.be.false;

        let investor = accounts[7];
        let investorAddress = web3.sha3(accounts[8], {encoding: 'hex'});
        let signature = await web3.eth.sign(signedAddress, investorAddress).slice(2);
        let r = "0x" + signature.slice(0, 64);
        let s = "0x" + signature.slice(64, 128);
        let v = signature.slice(128);
        v = parseInt(v) + 27;
        let valueToBuy = ether(7);

        await crowdsale.buyWithSignedAddress(8, v, r, s, {from: investor, value: valueToBuy})
            .should.be.rejectedWith(EVMThrow);
    });

    it("shouldn't buy with invalid signed address", async function () {
        let signedAddress = accounts[10];
        await crowdsale.setRequireSignedAddress(true, signedAddress);
        let isRequiredSignedAddress = await crowdsale.requiredSignedAddress();
        isRequiredSignedAddress.should.be.true;

        let investor = accounts[3];
        let valueToBuy = ether(10);
        await crowdsale.buyWithSignedAddress(8, 1, 'invalid', 'invalid', {from: investor, value: valueToBuy})
            .should.be.rejectedWith(EVMThrow);
    });

    it("shouldn't buy without signed address it is required", async function () {
        let signedAddress = accounts[10];
        await crowdsale.setRequireSignedAddress(true, signedAddress);
        let isRequiredSignedAddress = await crowdsale.requiredSignedAddress();
        isRequiredSignedAddress.should.be.true;

        let investor = accounts[3];
        let valueToBuy = ether(10);
        await crowdsale.sendTransaction({from: investor, value: valueToBuy})
            .should.be.rejectedWith(EVMThrow);
    });
});
