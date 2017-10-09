
var multiSigWalletContract = artifacts.require('./wallet/MultiSigWalletWithDailyLimit.sol');
var tokenContract = artifacts.require('./token/AlgoryToken.sol');
var crowdsaleContract = artifacts.require('./crowdsale/MintedEthCappedCrowdsale.sol');

module.exports = function(deployer, network, accounts) {
    walletAddress = deployWallet(deployer, accounts);
    tokenAddress = deployToken(deployer);
    crowdsaleAddress = deployCrowdsale(deployer, walletAddress, tokenAddress);
    console.log('Wallet address: ' + walletAddress);
    console.log('Token address: ' + tokenAddress);
    console.log('Crowdsale address: ' + crowdsaleAddress);
};

const ether = require('./helpers/ether');

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

function deployCrowdsale(deployer, walletAddress, tokenAddress) {
    const ethCap = ether(120000);
    //TODO
}


async function liveDeploy(deployer, accounts) {
    const rate = 100000000000000;
    const startTime = latestTime() + duration.minutes(1);
    const endTime = startTime + duration.days(5);

    console.log([startTime, endTime, rate, accounts[0]]);
    return deployer.deploy(MyCrowdsale, startTime, endTime, rate, accounts[0]).then( async () => {
        const instance = await MyCrowdsale.deployed();
    const token = await instance.token.call();
    console.log('Token address', token);
})
}

