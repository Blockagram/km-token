var Migrations = artifacts.require("./Migrations.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations, {gas: 621975, from: "0xc4f4d7ef579df808b8bd201345bbe30efa8a59c5"});
};