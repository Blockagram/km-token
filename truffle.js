module.exports = {
    // See <http://truffleframework.com/docs/advanced/configuration>
    // to customize your Truffle configuration!
    networks: {
      "live": {
        network_id: 1,
        host: "127.0.0.1",
        port: 8546,   // Different than the default below
        gas: 4000000,
        gasLimit: 6692819,
        from: "0xc4f4d7ef579df808b8bd201345bbe30efa8a59c5"
      },
      "development": {
        network_id: "*",
        host: "127.0.0.1",
        port: 7545,   // ganache
        gas: 4700000
      },
      "test": {
        network_id: 3,
        host: "127.0.0.1",
        port: 8545,   // default
        gas: 4700000,
        from: "0xc4f4d7ef579df808b8bd201345bbe30efa8a59c5"
      }
    },
    rpc: {
      host: "127.0.0.1",
      port: 8545
    }
  };
