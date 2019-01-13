var Token = artifacts.require("ABCxyzToken");
module.exports = function(deployer) {
  deployer.deploy(Token);
};