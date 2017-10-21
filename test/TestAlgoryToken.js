let token = artifacts.require('./token/AlgoryToken.sol');

contract('AlgoryToken', function(accounts) {
    it("should set expected total supply after deploy", function() {
        return token.deployed().then(function(instance) {
            return instance.totalSupply.call();
        }).then(function(totalSupply) {
            assert.equal(totalSupply.valueOf(), 120000000, "total supply does't equal 12000000");
        });
    });
    it("should set expected name after deploy", function() {
        return token.deployed().then(function(instance) {
            return instance.name.call();
        }).then(function(name) {
            assert.equal(name.valueOf(), 'Algory', "name does't equal Algory");
        });
    });
    it("should set expected symbol after deploy", function() {
        return token.deployed().then(function(instance) {
            return instance.symbol.call();
        }).then(function(symbol) {
            assert.equal(symbol.valueOf(), 'ALG', "symbol does't equal ALG");
        });
    });
    it("should set expected decimals after deploy", function() {
        return token.deployed().then(function(instance) {
            return instance.decimals.call();
        }).then(function(decimals) {
            assert.equal(decimals.valueOf(), 18, "decimals does't equal ALG");
        });
    });
    it("should set upgrade master address after deploy", function() {
        return token.deployed().then(function(instance) {
            return instance.upgradeMaster.call();
        }).then(function(upgradeMaster) {
            assert.equal(upgradeMaster.valueOf(), accounts[0], "upgrade master does't equal owner address");
            assert.notEqual(upgradeMaster.valueOf(), accounts[1], "upgrade master equal wrong address");
            assert.notEqual(upgradeMaster.valueOf(), accounts[2], "upgrade master equal wrong address");
        });
    });
    it("should set unreleased flag after deploy", function() {
        return token.deployed().then(function(instance) {
            return instance.released.call();
        }).then(function(released) {
            assert.equal(released.valueOf(), false, "released flag is not false");
        });
    });
    it("should change token information (name, symbol)", function() {
        var algory;
        return token.deployed().then(function(instance) {
            algory = instance;
            return algory.setTokenInformation('Algory2', 'ALG2');
        }).then(function () {
            return algory.symbol.call();
        }).then(function(symbol) {
            assert.equal(symbol.valueOf(), 'ALG2', "symbol is not equal new symbol ALG2");
        }).then(function() {
            return algory.name.call();
        }).then(function(name) {
            assert.equal(name.valueOf(), 'Algory2', "name is not equal new name Algory2");
        });
    });
    it("should assign total supply to owner", function() {
        return token.deployed().then(function(instance) {
            return instance.balanceOf(accounts[0]);
        }).then(function(balance) {
            assert.equal(balance.valueOf(), 120000000, accounts[0] + " has no 120000000 ALG");
        });
    });
});
