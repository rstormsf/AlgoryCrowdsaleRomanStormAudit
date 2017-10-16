
var multiSigWalletContract = artifacts.require('./wallet/MultiSigWalletWithDailyLimit.sol');
var tokenContract = artifacts.require('./token/AlgoryToken.sol');
var algoryPricingStrategyContract = artifacts.require('./crowdsale/AlgoryPricingStrategy.sol');
var crowdsaleContract = artifacts.require('./crowdsale/AllocatedCrowdsale.sol');
var finalizeAgnetContract = artifacts.require('./crowdsale/AlgoryFinalizeAgent');

const ether = require('./helpers/ether');
const duration = require('./helpers/duration');
const latestTime = require('./helpers/latestTime');

module.exports = function(deployer, network, accounts) {
    const walletAddress = deployWallet(deployer, accounts);
    const tokenAddress = deployToken(deployer);
    const pricingStrategyAddress = deployPricingStategy(deployer);
    const crowdsaleAddress = deployCrowdsale(deployer, pricingStrategyAddress, walletAddress, tokenAddress);
    const finalizeAgentAddress = deployFinalizeAgent(deployer, tokenAddress, crowdsaleAddress, walletAddress);

    console.log('Wallet address: ' + walletAddress);
    console.log('Token address: ' + tokenAddress);
    console.log('Pricing strategy address: ' + pricingStrategyAddress);
    console.log('Crowdsale address: ' + crowdsaleAddress);
    console.log('Finalize agent address: ' + finalizeAgentAddress);
};

function deployWallet(deployer, accounts) {
    const required = 2;
    const dayLimit = ether(10); //10 ETH

    return deployer.deploy(multiSigWalletContract, accounts, required, dayLimit).then(function (instance) {
        return instance.address;
    });
}

function deployToken(deployer) {
    const name = 'Algory';
    const symbol = 'ALG';
    const totalSupply = 120000000;
    const decimals = 18;
    const mintable = true;

    return deployer.deploy(tokenContract, name, symbol, totalSupply, decimals, mintable).then(function (instance) {
        return instance.address;
    });
}

function deployPricingStategy(deployer) {
    return deployer.deploy(algoryPricingStrategyContract).then(function (instance) {
        return instance.address;
    });
}

function deployCrowdsale(deployer, pricingStrategyAddress, walletAddress, tokenAddress) {
    const weiCap = ether(120000);
    const minimumFundingGoal = 0;
    const start = latestTime + duration.minutes(1);
    const end = startTime + duration.minutes(10);

    return deployer.deploy(
        crowdsaleContract,
        tokenAddress,
        pricingStrategyAddress,
        walletAddress,
        start,
        end,
        minimumFundingGoal,
        weiCap).then(function (instance) {
            return instance.address;
    });
}

function deployFinalizeAgent(deployer, tokenAddress, crowdsaleAddress, walletAddress) {
    const bonusBasePoints = 77777;

    return deployer.deploy(finalizeAgnetContract, tokenAddress, crowdsaleAddress, bonusBasePoints, walletAddress).then(function (instance) {
        return instance.address;
    });
}

