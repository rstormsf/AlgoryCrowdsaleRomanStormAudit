let token = artifacts.require('./token/AlgoryToken.sol');

function ether(n) {
    return new web3.BigNumber(web3.toWei(n, 'ether'))
}

function bigNumber(n) {
    return new web3.BigNumber(n)
}

function checkIsEventTriggered(result, event) {
    for (let i = 0; i < result.logs.length; i++) {
        let log = result.logs[i];
        if (log.event == event) {
            return true;
        }
    }
    return false;
}

contract('Test Algory Token', function(accounts) {
    const totalSupply = bigNumber(120000000 * 10**18);
    let algory;
    it("should set expected total supply after deploy", function() {
        return token.new().then(function(instance) {
            algory = instance;
            return instance.totalSupply();
        }).then(function(total) {
            assert.deepEqual(total, totalSupply, "total supply does't equal "+totalSupply.toNumber());
        })
    });
    it("should set expected name after deploy", function() {
        return algory.name().then(function(name) {
            assert.equal(name.valueOf(), 'Algory', "name does't equal Algory");
        });
    });
    it("should set expected symbol after deploy", function() {
        return algory.symbol().then(function(symbol) {
            assert.equal(symbol.valueOf(), 'ALG', "symbol does't equal ALG");
        });
    });
    it("should set expected decimals after deploy", function() {
        return algory.decimals().then(function(decimals) {
            assert.equal(decimals.valueOf(), 18, "decimals does't equal ALG");
        });
    });
    it("should set upgrade master address after deploy", function() {
        return algory.upgradeMaster().then(function(upgradeMaster) {
            assert.equal(upgradeMaster.valueOf(), accounts[0], "upgrade master does't equal owner address");
            assert.notEqual(upgradeMaster.valueOf(), accounts[1], "upgrade master equal wrong address");
            assert.notEqual(upgradeMaster.valueOf(), accounts[2], "upgrade master equal wrong address");
        });
    });
    it("should set unreleased flag after deploy", function() {
        return algory.released().then(function(released) {
            assert.equal(released.valueOf(), false, "released flag is not false");
        });
    });
    it("should change token information (name, symbol)", function() {
        return algory.setTokenInformation('Algory2', 'ALG2')
        .then(function (result) {
            return checkIsEventTriggered(result, 'UpdatedTokenInformation');
        })
        .then(function () {
            return algory.symbol();
        }).then(function(symbol) {
            assert.equal(symbol.valueOf(), 'ALG2', "symbol is not equal new symbol ALG2");
        }).then(function() {
            return algory.name();
        }).then(function(name) {
            assert.equal(name.valueOf(), 'Algory2', "name is not equal new name Algory2");
        });
    });
    it("should assign total supply to owner", function() {
        return algory.balanceOf(accounts[0])
        .then(function(balance) {
            assert.equal(balance.valueOf(), totalSupply, accounts[0] + " has no total supply ALG");
        })
    });

    it("shouldn't be upgraded before release", function() {
        return algory.canUpgrade()
            .then(function(val) {
                assert.equal(val.valueOf(), false);
            })
    });
});
