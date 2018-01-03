module.exports = {
    // See <http://truffleframework.com/docs/advanced/configuration>
    // to customize your Truffle configuration!
    networks: {
      "live": {
        network_id: 1,
        host: "127.0.0.1",
        port: 8546   // Different than the default below
      },
      "test": {
        network_id: 1,
        host: "127.0.0.1",
        port: 8545,   // Different than the default below
        gas: 4700000
      }
    },
    rpc: {
      host: "127.0.0.1",
      port: 8545
    }
  };
