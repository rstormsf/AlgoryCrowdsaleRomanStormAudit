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

contract('Test Algory Crowdsale Failure State', function(accounts) {
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
    });

    it("should be in failure state", async function () {
        let state = await crowdsale.getState();
        state.should.be.bignumber.equal(5);
    });
    
    it("shouldn't allow to buy tokens by anyone in success sate", async function () {
        await crowdsale.sendTransaction({from: accounts[1], value: ether(1)})
            .should.be.rejectedWith(EVMThrow);
    });
    it("shouldn't allow to transfer tokens by anyone in failure sate", async function () {
        let investor = accounts[1];
        let initBalanceOfInvestor = await crowdsale.investedAmountOf(investor);

        await algory.transfer(accounts[2], initBalanceOfInvestor, {from: investor})
            .should.be.rejectedWith(EVMThrow);
    });
});
