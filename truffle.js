require('babel-register');
require('babel-polyfill');

module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 8545,
            network_id: "*"
            // from: "0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1"
        },
        development_private_testnet: {
            host: "localhost",
            port: 8106,
            network_id: 21,
            from: "0x10e2068d2c0c58d4affa26f77f7ec876e7496526"
        }
    }
};