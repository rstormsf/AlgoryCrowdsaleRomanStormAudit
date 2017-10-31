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
import isEventTriggered from './helpers/isEventTriggered'
const EVMThrow = require('./helpers/EVMThrow');

contract('Test Algory Crowdsale Refunding State', function(accounts, network) {
    const beneficiary = accounts[0];
    const multisigWallet = accounts[accounts.length-1];

    let crowdsale, pricingStrategy, finalizeAgent, algory;
    let weiRefunded = new BigNumber(0);

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

    it("shouldn't allow to refund 0 value", async function () {
        await crowdsale.loadRefund({from: accounts[0], value: 0})
            .should.be.rejectedWith(EVMThrow)
    });

    it("shouldn't allow to refund when its not allowed", async function () {
        await crowdsale.allowRefunding(false);
        await crowdsale.refund({from: accounts[0]})
            .should.be.rejectedWith(EVMThrow);

        await crowdsale.allowRefunding(true);
    });

    it("should allow to refund money by investors", async function () {
        let investor = accounts[10];
        let balanceBeforeRefunding = await web3.eth.getBalance(investor);

        let investedAmountOfInvestor = await crowdsale.investedAmountOf(investor);
        investedAmountOfInvestor.should.be.bignumber.above(0);
        let {logs} = await crowdsale.refund({from: investor});
        assert.ok(isEventTriggered(logs, 'Refund'));
        let postInvestedAmountOfInvestor = await crowdsale.investedAmountOf(investor);
        postInvestedAmountOfInvestor.should.be.bignumber.equal(0);
        weiRefunded = weiRefunded.plus(investedAmountOfInvestor);

        let postBalanceBeforeRefunding = await web3.eth.getBalance(investor);
        postBalanceBeforeRefunding.should.be.bignumber.above(balanceBeforeRefunding);

        investor = accounts[11];
        balanceBeforeRefunding = await web3.eth.getBalance(investor);

        investedAmountOfInvestor = await crowdsale.investedAmountOf(investor);
        investedAmountOfInvestor.should.be.bignumber.above(0);
        let result = await crowdsale.refund({from: investor});
        assert.ok(isEventTriggered(result.logs, 'Refund'));
        postInvestedAmountOfInvestor = await crowdsale.investedAmountOf(investor);
        postInvestedAmountOfInvestor.should.be.bignumber.equal(0);
        weiRefunded = weiRefunded.plus(investedAmountOfInvestor);

        postBalanceBeforeRefunding = await web3.eth.getBalance(investor);
        postBalanceBeforeRefunding.should.be.bignumber.above(balanceBeforeRefunding);

    });

    it("shouldn't allow to refund by investor with 0 value", async function () {
        let investor = accounts[10];
        let investedAmountOfInvestor = await crowdsale.investedAmountOf(investor);
        investedAmountOfInvestor.should.be.bignumber.equal(0);
        await crowdsale.refund({from: investor})
            .should.be.rejectedWith(EVMThrow);
    });

    it("should proper get wei refunded in crowdsale", async function () {
        let currentWeiRefunded = await crowdsale.weiRefunded();
        currentWeiRefunded.should.be.bignumber.equal(weiRefunded);
    });
});
