const Payable = artifacts.require("Payable");

module.exports = function (deployer) {
  deployer.deploy(Payable);
};
