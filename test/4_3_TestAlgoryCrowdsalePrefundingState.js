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
import addToWhitelist from './helpers/addToWhitelist'
import buyTokensAndValidateSale from './helpers/buyTokensAndValidateSale'
import {duration} from './helpers/duration'
import {constants} from './helpers/constants'
import isEventTriggered from './helpers/isEventTriggered'
const EVMThrow = require('./helpers/EVMThrow');


contract('Test Algory Crowdsale Prefunding State', function(accounts) {
    const beneficiary = accounts[0];
    const multisigWallet = accounts[accounts.length-1];

    let crowdsale, pricingStrategy, finalizeAgent, algory;

    before(async function() {
        let presaleStartsAt = latestTime() + duration.minutes(10);
        const startsAt = presaleStartsAt + duration.days(10);
        const endsAt = startsAt + duration.days(10);

        algory = await tokenContract.deployed();
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

        await crowdsale.setPresaleStartsAt(latestTime());
    });

    it("should be in prefunding state", async function () {
        const state = await crowdsale.getState();
        state.should.be.bignumber.equal(2);
    });

    it("should preallocate part of tokens to company, devs and bounty", async function () {
        let balanceOfDevs = await algory.balanceOf(constants.devsAddress);
        let balanceOfComapny = await algory.balanceOf(constants.companyAddress);
        let balanceOfBounty = await algory.balanceOf(constants.bountyAddress);

        balanceOfDevs.should.be.bignumber.equal(constants.devsTokens);
        balanceOfComapny.should.be.bignumber.equal(constants.companyTokens);
        balanceOfBounty.should.be.bignumber.equal(constants.bountyTokens);
    });

    it("should replace multisig wallet", async function () {
        const anotherWalletAddress = accounts[7];
        await crowdsale.setMultisigWallet(anotherWalletAddress);
        const currentWallet = await crowdsale.multisigWallet();

        assert.equal(currentWallet, anotherWalletAddress);
    });

    it("shouldn't replace pricing strategy to another when is not pause", async function () {
        let anotherPricingStrategy = await pricingStrategyContract.new();
        await crowdsale.setPricingStrategy(anotherPricingStrategy.address)
            .should.be.rejectedWith(EVMThrow)
    });

    it("should replace pricing strategy to another in pause state", async function () {
        let anotherPricingStrategy = await pricingStrategyContract.new();
        await crowdsale.pause();
        await crowdsale.setPricingStrategy(anotherPricingStrategy.address);
        await crowdsale.unpause();
        let currentPricingStrategy = await crowdsale.pricingStrategy();
        assert.equal(currentPricingStrategy, anotherPricingStrategy.address);
    });

    it("shouldn't set presale date", async function () {
        let presaleStartsAt = latestTime() + duration.days(1);
        await crowdsale.setPresaleStartsAt(presaleStartsAt)
            .should.be.rejectedWith(EVMThrow)

    });

    it("should set start and end dates", async function () {
        const startsAt = latestTime() + duration.days(77);
        const endsAt = startsAt + duration.days(77);

        let result= await crowdsale.setEndsAt(endsAt);
        assert.ok(isEventTriggered(result.logs, 'TimeBoundaryChanged'));

        result = await crowdsale.setStartsAt(startsAt);
        assert.ok(isEventTriggered(result.logs, 'TimeBoundaryChanged'));

        const currentStart = await crowdsale.startsAt();
        const currentEnd = await crowdsale.endsAt();

        assert.equal(currentStart, startsAt);
        assert.equal(currentEnd, endsAt);
    });

    it("shouldn't allow to buy tokens by not whitelisted participant", async function () {
        await crowdsale.sendTransaction({from: accounts[1], value: ether(1)})
            .should.be.rejectedWith(EVMThrow)
    });

    it("shouldn't allow to finalize crowdsale in prefunding state", async function () {
        await crowdsale.finalize()
            .should.be.rejectedWith(EVMThrow)
    });

    it("shouldn't allow to set refunding in prefunding state", async function () {
        await crowdsale.allowRefunding(true)
            .should.be.rejectedWith(EVMThrow)
    });

    it("shouldn't allow to refund in prefunding state", async function () {
        await crowdsale.refund({from: accounts[8]})
            .should.be.rejectedWith(EVMThrow)
    });

    it("should allow to buy some tokens by whitelisted participants", async function () {
        let participant = accounts[1];
        let valueParticipant = ether(8);
        let valueToBuy = ether(4);
        let expectedAmountOfTokens = valueToBuy.times(1200);

        await addToWhitelist(crowdsale, participant, valueParticipant);
        await buyTokensAndValidateSale(crowdsale, algory, participant, valueToBuy, expectedAmountOfTokens);

        let participant2 = accounts[2];
        let valueParticipant2 = ether(77);
        let valueToBuy2 = ether(6);
        let expectedAmountOfTokens2 = valueToBuy2.times(1200);

        await addToWhitelist(crowdsale, participant2, valueParticipant2);
        await buyTokensAndValidateSale(crowdsale, algory, participant2, valueToBuy2, expectedAmountOfTokens2);

        let participant3 = accounts[3];
        let valueParticipant3 = ether(23);
        let valueToBuy3 = ether(3);
        let expectedAmountOfTokens3 = valueToBuy3.times(1200);

        await addToWhitelist(crowdsale, participant3, valueParticipant3);
        await buyTokensAndValidateSale(crowdsale, algory, participant3, valueToBuy3, expectedAmountOfTokens3);

        let participant4 = accounts[4];
        let valueParticipant4 = ether(13);
        let valueToBuy4 = ether(1);
        let expectedAmountOfTokens4 = valueToBuy4.times(1200);

        await addToWhitelist(crowdsale, participant4, valueParticipant4);
        await buyTokensAndValidateSale(crowdsale, algory, participant4, valueToBuy4, expectedAmountOfTokens4);

        let participant5 = accounts[5];
        let valueParticipant5 = ether(12);
        let valueToBuy5 = ether(3);
        let expectedAmountOfTokens5 = valueToBuy5.times(1200);

        await addToWhitelist(crowdsale, participant5, valueParticipant5);
        await buyTokensAndValidateSale(crowdsale, algory, participant5, valueToBuy5, expectedAmountOfTokens5);

        let participant6 = accounts[6];
        let valueParticipant6 = ether(7);
        let valueToBuy6 = ether(2);
        let expectedAmountOfTokens6 = valueToBuy6.times(1200);

        await addToWhitelist(crowdsale, participant6, valueParticipant6);
        await buyTokensAndValidateSale(crowdsale, algory, participant6, valueToBuy6, expectedAmountOfTokens6);

    });
    it("shouldn't allow to buy more tokens per one investor than declared in whitelist", async function () {
        let participant = accounts[7];
        let valueParticipant = ether(10);
        let valueToBuy = ether(15);

        await addToWhitelist(crowdsale, participant, valueParticipant);
        await crowdsale.sendTransaction({from: participant, value: valueToBuy})
            .should.be.rejectedWith(EVMThrow);

        let participant2 = accounts[7];
        let valueParticipant2 = ether(10);
        let valueToBuy2 = ether(9);
        let expectedAmountOfTokens2 = valueToBuy2.times(1200);
        let secondValueToBuy2 = ether(2);

        await addToWhitelist(crowdsale, participant2, valueParticipant2);
        await buyTokensAndValidateSale(crowdsale, algory, participant2, valueToBuy2, expectedAmountOfTokens2);
        await crowdsale.sendTransaction({from: participant2, value: secondValueToBuy2})
            .should.be.rejectedWith(EVMThrow);
    });

    it("shouldn't replace multisig wallet if investment count is grater than 5", async function () {
        let currentInvestorCount = await crowdsale.investorCount();
        currentInvestorCount.should.be.bignumber.above(5);
        await crowdsale.setMultisigWallet(accounts[20])
            .should.be.rejectedWith(EVMThrow);
    });

    it("should allow to multiple buy some tokens until whitelist participate is empty", async function () {
        let participant = accounts[8];
        let valueParticipant = ether(10);

        let valueToBuy1 = ether(4);
        let valueToBuy2 = ether(2);
        let valueToBuy3 = ether(2);
        let valueToBuy4 = ether(2);

        let expectedAmountOfTokens1 = valueToBuy1.times(1200);
        let expectedAmountOfTokens2 = valueToBuy2.times(1200);
        let expectedAmountOfTokens3 = valueToBuy3.times(1200);
        let expectedAmountOfTokens4 = valueToBuy4.times(1200);

        await addToWhitelist(crowdsale, participant, valueParticipant);
        await buyTokensAndValidateSale(crowdsale, algory, participant, valueToBuy1, expectedAmountOfTokens1);
        await buyTokensAndValidateSale(crowdsale, algory, participant, valueToBuy2, expectedAmountOfTokens2);
        await buyTokensAndValidateSale(crowdsale, algory, participant, valueToBuy3, expectedAmountOfTokens3);
        await buyTokensAndValidateSale(crowdsale, algory, participant, valueToBuy4, expectedAmountOfTokens4);

        //not allowed to buy
        let valueToBuyNotAllowed = ether(3);
        let currentParticipate = await crowdsale.earlyParticipantWhitelist(participant);
        currentParticipate.should.be.bignumber.below(valueToBuyNotAllowed);
        await crowdsale.sendTransaction({from: participant, value: valueToBuyNotAllowed})
            .should.be.rejectedWith(EVMThrow);
    });
});
