require('babel-register');
require('babel-polyfill');

module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 8545,
            network_id: "*",
        },
        coverage: {
            host: "localhost",
            network_id: "*",
            port: 8555,         // <-- If you change this, also set the port option in .solcover.js.
            gas: 0xfffffffffff, // <-- Use this high gas value
            gasPrice: 0x01,      // <-- Use this low gas price
        },
        development_private_testnet: {
            host: "localhost",
            port: 8106,
            network_id: 21,
            from: "0x10e2068d2c0c58d4affa26f77f7ec876e7496526"
        }
    },
    mocha: {
        useColors: true
    }
};