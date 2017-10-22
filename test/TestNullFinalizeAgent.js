
let nullFinalizeAgentContract = artifacts.require('./crowdsale/NullFinalizeAgent.sol');
let crowdsaleContract = artifacts.require('./crowdsale/AlgoryCrowdsale.sol');

contract('Test Null Finalize Agent', function(accounts) {
    let nullFinalizeAgent;
    let crowdsale;

    it("prepare suite by assign deployed contract", function () {
        return crowdsaleContract.deployed().then(function (instance) { crowdsale = instance})
            .then(function() {return nullFinalizeAgentContract.new(crowdsale.address)}).then(function (instance) { nullFinalizeAgent = instance})
            .then(function () {return crowdsale.setFinalizeAgent(nullFinalizeAgent.address)})
    });
    it("should be finalized agent", function () {
        return nullFinalizeAgent.isFinalizeAgent().then(function (isAgent) {
            assert.ok(isAgent, 'It is not finalize agent');
        })
    });
    it("should be sane when it is set as finalize agent in crowdsale", function () {
        return nullFinalizeAgent.isSane().then(function (isSane) {
            assert.ok(isSane, 'It is not sane');
        })
    });
    it("shouldn't be sane when it is not set as finalize agent in crowdsale", function () {
        let newAgent;
        return nullFinalizeAgentContract.new(crowdsale.address).then(function (instance) {
            newAgent = instance;
        }).then(function () {
            return newAgent.isSane().then(function (isSane) {
                assert.ok(!isSane, 'It is sane');
            })
        })
    });
    it("should nothing to do when finalize crowdsale", function () {
        return nullFinalizeAgent.finalizeCrowdsale().then(function (result) {
            assert.ok((result.logs.length == 0), 'Something is returned in logs');
        })
    });
});
