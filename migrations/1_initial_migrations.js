var Migrations = artifacts.require("./Migrations.sol");
var BLKGToken = artifacts.require('./BLKGToken.sol');

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(BLKGToken);
};