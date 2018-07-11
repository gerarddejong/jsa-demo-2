var Migrations = artifacts.require("./Migrations.sol");
var ConferenceTicketSale = artifacts.require("./ConferenceTicketSale.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(ConferenceTicketSale);
};
