
let tokenContract = artifacts.require('./token/AlgoryToken.sol');

module.exports = function() {

    let tokenAddress = '0x1023848a15b05fb3ce1283367f3f75900db31d69';
    let token = tokenContract.at(tokenAddress);

    token.symbol.call().then(function (val) {
        console.log(val.valueOf());
    });

};