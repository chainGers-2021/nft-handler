const Token = artifacts.require("Token");

module.exports = function (deployer) {
  const tokenURI = `https://storageapi.fleek.co/chaingers2021-team-bucket/meta/{id}.json`;
  deployer.deploy(Token, tokenURI);
};