# Add hardhat configuration for Privatenet

## 1. Add one or more additional accounts on your node1

When we created our privatenet we created only one own all account( same applies to the one in private-net/ dir).

Let's add additional account taht we are going to use for testing.

- If you use the docker-compose setup
  - Make sure the privatenet is up : docker-compose up
  - In another terminal run :
  ```sh
  docker-compose exec node1 /bin/sh
  # You will get a shell inside the node
  # Use the gethX wrapper script to create new account
  gethX account new
  ```
- If you use the private net that you have built, use
  ```
  geth account new
  ```
- Now copy both account files from either the _private-net/node-data/node1/keystore_ dir or _~/.ehtereum/keystore_ to the _keythereum-private-key_ folder.

```sh
# e.g.
sudo cp -r private-net/node-data/node1/keystore keythereum-private-key/
sudo chown -R $(id -u):$(id -u) keythereum-private-key/keystore/
```

- Go inside the _keythereum-private-key/_ directory and install dependencies

```sh
cd keythereum-private-key/
npm install
```

- Print the private keys for both accounts by using the `private-key-as-hex.js` script:

```sh
node private-key-as-hex.js keystore/UTC--2023-06-27T16-14-03.815555462Z--11b9149a9c7a34fdb2ab59a55f8278f9f6f743bf
625f5644f26a7848855b769a65c97966fedb7535d961a5bd9c5c0eff7fa555a5
```

- Save the printed hex keys, we are going to need them in the next step. It is also important to remember which one is for the OWN IT ALL account and which is for the second.

## 2. Add out local private net to hardhat

- Open _hardhat.config.js_ and add the following configuration keys:

```js
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {},
    local: {
      url: "http://localhost:8545",
      chainId: 5342,
      accounts: [
        "<HEX PRIVATE KEY FOR THE OWN IT ALL ACCOUNT>",
        "<HEX PRIVATE KEY FOR THE SECOND ACCOUNT>",
      ],
    },
  },
};
```

**NOTE**: Make sure to use the same chainId you use to run your privatenet.

## 3. Run hardhat tests against your private net

- Run:

```
npx hardhat test --network local
```
