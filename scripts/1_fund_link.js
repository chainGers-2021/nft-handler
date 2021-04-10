const Oracle = artifacts.require("Oracle");
const APIConsumer = artifacts.require("APIConsumer");
const Link = require("@chainlink/contracts/abi/v0.6/LinkTokenInterface.json");
require("dotenv").config();

module.exports = async function (callback) {
  const link = new web3.eth.Contract(
    Link.compilerOutput.abi,
    process.env.LINK_CONTRACT_ADDRESS
  );

  const acc = await web3.eth.getAccounts();

  const amount = (5 * 10 ** 18).toString();
  tx = await link.methods
    .transfer((await Oracle.deployed()).address, amount)
    .send({ from: acc[0] });
  console.log("gasUsed: ", tx.gasUsed);

  tx = await link.methods
    .transfer((await APIConsumer.deployed()).address, amount)
    .send({ from: acc[0] });
  console.log("gasUsed: ", tx.gasUsed);

  callback("\nFinished.");
};
