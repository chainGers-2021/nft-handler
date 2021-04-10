const { Client } = require("pg");
const client = new Client({
  user: "postgres",
  host: "localhost",
  database: "postgres",
  password: "postgres",
  port: 5432,
});

async function main() {
  await client.connect();
  console.log("Postgres connected well.");

  return process.exit(0);
}
main();
