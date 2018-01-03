var BLKGToken = artifacts.require('./BLKGToken.sol');

module.exports = function(deployer) {
  deployer.deploy(BLKGToken, {gas: 4700000, from: "0xc4f4d7ef579df808b8bd201345bbe30efa8a59c5"});
};