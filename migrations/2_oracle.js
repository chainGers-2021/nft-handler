const Oracle = artifacts.require("Oracle");
require("dotenv").config();

module.exports = function (deployer) {
  deployer.deploy(Oracle, process.env.LINK_CONTRACT_ADDRESS);
};
