'use strict';

let algoryFinalizeAgentContract = artifacts.require('./crowdsale/AlgoryFinalizeAgent.sol');
let tokenContract = artifacts.require('./token/AlgoryToken.sol');
let crowdsaleContract = artifacts.require('./crowdsale/AlgoryCrowdsale.sol');

const BigNumber = web3.BigNumber;
require('chai')
    .use(require('chai-as-promised'))
    .use(require('chai-bignumber')(BigNumber))
    .should();
const EVMThrow = require('./helpers/EVMThrow.js');

contract('Test Algory Finalize Agent', function(accounts) {
    let algoryFinalizeAgent, algory, crowdsale;

    beforeEach(async function() {
        algory = await tokenContract.deployed();
        crowdsale = await crowdsaleContract.deployed();
        algoryFinalizeAgent = await algoryFinalizeAgentContract.new(algory.address, crowdsale.address);
        await algory.setReleaseAgent(algoryFinalizeAgent.address);
        await crowdsale.setFinalizeAgent(algoryFinalizeAgent.address)
    });

    it("shouldn't be created with invalid token address", async function () {
        algoryFinalizeAgent = await algoryFinalizeAgentContract.new(0x0, crowdsale.address)
            .should.be.rejectedWith(EVMThrow)
    });

    it("shouldn't be created with invalid crowdsale address", async function () {
        algoryFinalizeAgent = await algoryFinalizeAgentContract.new(algory.address, 0x0)
            .should.be.rejectedWith(EVMThrow)
    });
    
    it("should be finalized agent", async function () {
        let isFinalizeAgent = await algoryFinalizeAgent.isFinalizeAgent();
        isFinalizeAgent.should.be.true;
    });

    it("should be sane when it is set as release agent in token and finalize agent in crowdsale", async function () {
        let isSane = await algoryFinalizeAgent.isSane();
        isSane.should.be.true;
    });

    it("shouldn't be sane when it is not set as release agent in token", async function () {
        const newAgent = await algoryFinalizeAgentContract.new(algory.address, crowdsale.address);
        await crowdsale.setFinalizeAgent(algoryFinalizeAgent.address); //set old agent
        let isSane = await newAgent.isSane();
        isSane.should.be.false;
    });

    it("shouldn't be sane when it is not set as finalize agent in crowdsale", async function () {
        const newAgent = await algoryFinalizeAgentContract.new(algory.address, crowdsale.address);
        await algory.setReleaseAgent(algoryFinalizeAgent.address); //set old agent
        let isSane = await newAgent.isSane();
        isSane.should.be.false;
    });

    it("shouldn't finalize crowdsale when sender is not crowdsale", async function () {
        await algoryFinalizeAgent.finalizeCrowdsale()
            .should.be.rejectedWith(EVMThrow)
    });
});
