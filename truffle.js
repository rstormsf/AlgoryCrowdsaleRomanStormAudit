require('babel-register');
require('babel-polyfill');

module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 8545,
            network_id: "*"
            // from: "0x649aDCB23850f1A57878E5E294E13a858E1e3a24"
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