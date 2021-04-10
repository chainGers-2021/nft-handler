const Oracle = artifacts.require("Oracle");
const APIConsumer = artifacts.require("APIConsumer");
require("dotenv").config();

module.exports = async function (callback) {
  const con = await APIConsumer.deployed();

  try {
    tx = await con.requestEthereumPrice(
      (await Oracle.deployed()).address,
      process.env.JOB_ID, {gas: (10**7).toString()}
    );
    console.log("gasUsed: ", tx.receipt.gasUsed);
  } catch (error) {
    console.log(error);
  }

  callback("\nFinished.");
};
