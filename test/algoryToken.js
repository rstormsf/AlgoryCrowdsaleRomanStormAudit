let token = artifacts.require('./token/AlgoryToken.sol');

contract('AlgoryToken', function(accounts) {
    it("should set expected total supply after deploy", function() {
        return token.deployed().then(function(instance) {
            return instance.totalSupply.call();
        }).then(function(totalSupply) {
            assert.equal(totalSupply.valueOf(), 120000000, "total supply is not equal 12000000");
        });
    });
    it("should set expected name after deploy", function() {
        return token.deployed().then(function(instance) {
            return instance.name.call();
        }).then(function(name) {
            assert.equal(name.valueOf(), 'Algory', "name is not equal Algory");
        });
    });
    it("should set expected symbol after deploy", function() {
        return token.deployed().then(function(instance) {
            return instance.symbol.call();
        }).then(function(symbol) {
            assert.equal(symbol.valueOf(), 'ALG', "symbol is not equal ALG");
        });
    });
    it("should set expected decimals after deploy", function() {
        return token.deployed().then(function(instance) {
            return instance.decimals.call();
        }).then(function(decimals) {
            assert.equal(decimals.valueOf(), 18, "decimals is not equal ALG");
        });
    });
    it("should set upgrade master address after deploy", function() {
        return token.deployed().then(function(instance) {
            return instance.upgradeMaster.call();
        }).then(function(upgradeMaster) {
            assert.equal(upgradeMaster.valueOf(), accounts[0], "upgrade master is not equal owner address");
            assert.notEqual(upgradeMaster.valueOf(), accounts[1], "upgrade master is equal wrong address");
            assert.notEqual(upgradeMaster.valueOf(), accounts[2], "upgrade master is equal wrong address");
        });
    });
    it("should set expected minting finished flag after deploy", function() {
        return token.deployed().then(function(instance) {
            return instance.mintingFinished.call();
        }).then(function(mintingFinished) {
            assert.equal(mintingFinished.valueOf(), true, "minting finished flag is not true");
        });
    });
});
