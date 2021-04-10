const APIConsumer = artifacts.require("APIConsumer");
const Token = artifacts.require("Token");
require("dotenv").config();

module.exports = async function (deployer) {
  await deployer.deploy(
    APIConsumer,
    (await Token.deployed()).address
  );
  
  // Mint some tokens
  holder = await APIConsumer.deployed();
  await holder.mintTokens("LINK");
  await holder.mintTokens("BAT");
};