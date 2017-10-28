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
import buyAllTokensInTranche from './helpers/buyAllTokensInTranche'
import buyTokensAndValidateSale from './helpers/buyTokensAndValidateSale'
const EVMThrow = require('./helpers/EVMThrow');

contract('Test Algory Crowdsale Refunding State', function(accounts, network) {
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
        await crowdsale.setStartsAt(latestTime()- duration.hours(1));

        await buyAllTokensInTranche(crowdsale, algory, accounts, 0);
        await buyTokensAndValidateSale(crowdsale, algory, accounts[1], ether(1), ether(1).times(1200));
        await buyAllTokensInTranche(crowdsale, algory, accounts, 1);

        await crowdsale.setEndsAt(latestTime()-10);
        await crowdsale.allowRefunding(true);

        //load eth to refunding
        let crowdsaleWeiRaised = await crowdsale.weiRaised();
        await crowdsale.loadRefund({from: accounts[0], value: crowdsaleWeiRaised});
        let loadedRefund = await crowdsale.loadedRefund();
        loadedRefund.should.be.bignumber.equal(crowdsaleWeiRaised);
    });

    it("should be in refunding state", async function () {
        let state = await crowdsale.getState();
        state.should.be.bignumber.equal(7);
    });

    // it("should allow to refund money by investors", function () {
    //     let investor1 = accounts[10];
    //     let investor2 = accounts[11];
    //     let balanceBeforeRefunding1 = web3.eth.getBalance(investor1);
    //     let balanceBeforeRefunding2 = web3.eth.getBalance(investor2);
    //     let investedAmount1;
    //     let investedAmount2;
    //     let gasCost;
    //     return crowdsale.investedAmountOf(investor1)
    //         .then(function (amount) {
    //             investedAmount1 = amount;
    //             weiRefunded = weiRefunded.plus(amount);
    //             assert.ok(investedAmount1.greaterThan(bigNumber(0)), 'Invested amount equal 0');
    //             return crowdsale.refund({from: investor1})
    //         })
    //         .then(function (result) {
    //             gasCost = bigNumber(result.receipt.gasUsed).times(web3.eth.gasPrice);
    //             return checkIsEventTriggered(result, 'Refund')
    //         })
    //         .then(function () {
    //             return crowdsale.investedAmountOf(investor1).then(function (amount) {
    //                 assert.equal(amount.toNumber(), 0, 'Investor has still money in crowdsale')
    //             })
    //         })
    //         .then(function () {
    //             return web3.eth.getBalance(investor1)
    //         })
    //         .then(function (currentBallance) {
    //             assert.ok(currentBallance.greaterThan(balanceBeforeRefunding1), 'Refunded value is invalid')
    //         })
    //         //another investor
    //         .then(function () {
    //             return crowdsale.investedAmountOf(investor2)
    //         })
    //         .then(function (amount) {
    //             investedAmount2 = amount;
    //             weiRefunded = weiRefunded.plus(amount);
    //             assert.ok(investedAmount2.greaterThan(bigNumber(0)), 'Invested amount equal 0');
    //             return crowdsale.refund({from: investor2})
    //         })
    //         .then(function (result) {
    //             return checkIsEventTriggered(result, 'Refund')
    //         })
    //         .then(function () {
    //             return crowdsale.investedAmountOf(investor2).then(function (amount) {
    //                 assert.equal(amount.toNumber(), 0, 'Investor has still money in crowdsale')
    //             })
    //         })
    //         .then(function () {
    //             return web3.eth.getBalance(investor2)
    //         })
    //         .then(function (currentBallance) {
    //             assert.ok(currentBallance.greaterThan(balanceBeforeRefunding2), 'Refunded value is invalid')
    //         })
    // });
    // it("should proper get wei refunded in crowdsale", function () {
    //     return crowdsale.weiRefunded().then(function (wei) {
    //         assert.deepEqual(wei, weiRefunded, 'Wei refunded is invalid')
    //     })
    // });
});
