const fs = require("fs");
const keythereum = require("keythereum");

if (process.argv <= 2) {
  console.error("You need to specify ethereum json account");
  process.exit(1);
}

const key = JSON.parse(fs.readFileSync(process.argv[2]));

const keyObject = keythereum.recover("123456", key, (o) => {
  console.log(o.toString("hex"));
});
