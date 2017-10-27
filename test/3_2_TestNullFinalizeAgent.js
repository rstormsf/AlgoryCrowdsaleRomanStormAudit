'use strict';

let nullFinalizeAgentContract = artifacts.require('./crowdsale/NullFinalizeAgent.sol');
let crowdsaleContract = artifacts.require('./crowdsale/AlgoryCrowdsale.sol');

const BigNumber = web3.BigNumber;
require('chai')
    .use(require('chai-as-promised'))
    .use(require('chai-bignumber')(BigNumber))
    .should();

contract('Test Null Finalize Agent', function(accounts) {
    let nullFinalizeAgent, crowdsale;

    beforeEach(async function() {
        crowdsale = await crowdsaleContract.deployed();
        nullFinalizeAgent = await nullFinalizeAgentContract.new(crowdsale.address);
        await crowdsale.setFinalizeAgent(nullFinalizeAgent.address)
    });

    it("should be finalized agent", async function () {
        let isFinalizeAgent = await nullFinalizeAgent.isFinalizeAgent();
        isFinalizeAgent.should.be.true;
    });

    it("should be sane when it is set as release agent in token and finalize agent in crowdsale", async function () {
        let isSane = await nullFinalizeAgent.isSane();
        isSane.should.be.true;
    });

    it("shouldn't be sane when it is not set as finalize agent in crowdsale", async function () {
        const newAgent = await nullFinalizeAgentContract.new(crowdsale.address);
        await crowdsale.setFinalizeAgent(nullFinalizeAgent.address); //set old agent
        let isSane = await newAgent.isSane();
        isSane.should.be.false;
    });

    it("should nothing to do when finalize crowdsale", async function () {
        await nullFinalizeAgent.finalizeCrowdsale();
        let finalized = await crowdsale.finalized();
        finalized.should.be.false;
    });
});


