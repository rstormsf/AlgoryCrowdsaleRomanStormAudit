
let tokenContract = artifacts.require('./token/AlgoryToken.sol');

module.exports = function() {

    let tokenAddress = '0x5fcbb5a4754b43c132cac41075ed9d9ae000cd71';
    let token = tokenContract.at(tokenAddress);

    token.symbol.call().then(function (val) {
        console.log(val.valueOf());
    });

};