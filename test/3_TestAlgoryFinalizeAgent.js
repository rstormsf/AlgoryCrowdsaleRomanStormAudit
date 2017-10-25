
let algoryFinalizeAgentContract = artifacts.require('./crowdsale/AlgoryFinalizeAgent.sol');
let tokenContract = artifacts.require('./token/AlgoryToken.sol');
let crowdsaleContract = artifacts.require('./crowdsale/AlgoryCrowdsale.sol');

contract('Test Algory Finalize Agent', function(accounts) {
    let algoryFinalizeAgent;
    let algory;
    let crowdsale;

    it("prepare suite by assign deployed contract", function () {
        return algoryFinalizeAgentContract.deployed()
            .then(function (instance) { algoryFinalizeAgent = instance})
            .then(function() {return tokenContract.deployed()}).then(function (instance) { algory = instance})
            .then(function() {return crowdsaleContract.deployed()}).then(function (instance) { crowdsale = instance})
            .then(function () {return algory.setReleaseAgent(algoryFinalizeAgentContract.address)})
            .then(function () {return crowdsale.setFinalizeAgent(algoryFinalizeAgentContract.address)})
    });
    it("should be finalized agent", function () {
        return algoryFinalizeAgent.isFinalizeAgent().then(function (isAgent) {
            assert.ok(isAgent, 'It is not finalize agent');
        })
    });
    it("should be sane when it is set as release agent in token and finalize agent in crowdsale", function () {
        return algoryFinalizeAgent.isSane().then(function (isSane) {
            assert.ok(isSane, 'It is not sane');
        })
    });
    it("should be sane when it is not set as release agent in token", function () {
        let newAgent;
        return algoryFinalizeAgentContract.new(algory.address, crowdsale.address).then(function (instance) {
            newAgent = instance;
        })
        .then(function () {
            return crowdsale.setFinalizeAgent(algoryFinalizeAgentContract.address);
        })
        .then(function () {
            return newAgent.isSane().then(function (isSane) {
                assert.ok(!isSane, 'It is sane');
            })
        })
    });
    it("should be sane when it is not set as finalize agent in crowdsale", function () {
        let newAgent;
        return algoryFinalizeAgentContract.new(algory.address, crowdsale.address).then(function (instance) {
            newAgent = instance;
        })
        .then(function () {
            return algory.setReleaseAgent(algoryFinalizeAgentContract.address);
        })
        .then(function () {
            return newAgent.isSane().then(function (isSane) {
                assert.ok(!isSane, 'It is sane');
            })
        })
    });
});
