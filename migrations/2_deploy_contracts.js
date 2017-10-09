var MyCrowdsale = artifacts.require('./MyCrowdsale.sol');
module.exports = function(deployer, network, accounts) {
    return liveDeploy(deployer, accounts);
};

// Returns the time of the last mined block in seconds
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

