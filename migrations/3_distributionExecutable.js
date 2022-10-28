const DistributionExecutable = artifacts.require("DistributionExecutable");

const chains = require(`../contracts/axelar-testnet.json`);

const chain = chains.find(item => item.name === "Moonbeam");

module.exports = function (deployer) {
  deployer.deploy(DistributionExecutable, chain.gateway, chain.gasReceiver);
};
