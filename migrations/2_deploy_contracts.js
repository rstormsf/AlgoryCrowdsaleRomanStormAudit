let multiSigWallet = artifacts.require('./wallet/MultiSigWallet.sol');
let token = artifacts.require('./token/AlgoryToken.sol');
let pricingStrategy = artifacts.require('./crowdsale/AlgoryPricingStrategy.sol');
let allocatedCrowdsale = artifacts.require('./crowdsale/AllocatedCrowdsale.sol');
let finalizeAgent = artifacts.require('./crowdsale/AlgoryFinalizeAgent.sol');
let safeMathLib = artifacts.require('./math/SafeMathLib.sol');

function latestTime() {
    return web3.eth.getBlock('latest').timestamp;
}

const duration = {
    seconds: function(val) { return val},
    minutes: function(val) { return val * this.seconds(60) },
    hours:   function(val) { return val * this.minutes(60) },
    days:    function(val) { return val * this.hours(24) },
    weeks:   function(val) { return val * this.days(7) },
    years:   function(val) { return val * this.days(365)}
};

module.exports = function(deployer, network, accounts) {

    // MultiSigWallet
    const requiredConfirmations = 1;

    // Token
    const name = 'Algory';
    const symbol = 'ALG';
    const totalSupply = 120000000;
    const decimals = 18;
    const mintable = false;

    // Pricing Strategy
    const tranches = [0, 2000, 100000, 40000, 50000000, 0];
    const preicoMaxValue = 10000;

    // Crowdsale
    const beneficiary = '0x10e2068d2c0c58d4affa26f77f7ec876e7496526';
    const start = latestTime() + duration.minutes(1);
    const end = start + duration.minutes(10);

    // Deploy MultiSigWallet
    return deployer.deploy(multiSigWallet, accounts, requiredConfirmations)
    // Deploy SafeMathLib
    .then(function() {
        return deployer.deploy(safeMathLib)
    })
    // Link SafeMathLib
    .then(function() {
        deployer.link(safeMathLib, token);
        deployer.link(safeMathLib, pricingStrategy);
        deployer.link(safeMathLib, allocatedCrowdsale);
        deployer.link(safeMathLib, finalizeAgent);
    })
    // Deploy Token
    .then(function() {
        return deployer.deploy(token, name, symbol, totalSupply, decimals, mintable);
    })
    //Deploy Pricing Strategy
    .then(function() {
        return deployer.deploy(pricingStrategy, tranches, preicoMaxValue);
    })
    //Deploy Crowdsale
    .then(function() {
        return deployer.deploy(
            allocatedCrowdsale,
            token.address,
            pricingStrategy.address,
            multiSigWallet.address,
            start,
            end,
            beneficiary
        );
    })
    //Deploy Finalize Agent
    .then(function() {
        return deployer.deploy(finalizeAgent, token.address, allocatedCrowdsale.address, multiSigWallet.address);
    });

};

