const ATestnetConsumer = artifacts.require("ATestnetConsumer");
require("dotenv").config();

module.exports = async function (callback) {
  const con = await ATestnetConsumer.deployed();
  console.log("changeDay: ", parseInt(await con.changeDay()));
  console.log("currentPrice: ", parseInt(await con.currentPrice()));
  console.log("lastMarket: ", await con.lastMarket());

  callback("\nFinished.");
};
