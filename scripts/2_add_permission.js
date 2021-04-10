const Oracle = artifacts.require("Oracle");
require("dotenv").config();

module.exports = async function (callback) {
  const oracle = await Oracle.deployed();
  tx = await oracle.setFulfillmentPermission(process.env.NODE_ADDRESS, true);
  
  console.log("gasUsed: ", tx.receipt.gasUsed);
  
  callback("\nFinished.");
};
