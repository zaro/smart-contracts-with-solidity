# Testing with Privatenet

## 1. Setup localnet

Make sure you copy the networks section of of your project from lesson 3, in our current hardhat.config.js

## 2. Run the test against our privatenet

- npm hardhat test --network local

## 3. Fixing the issues...

Change the waitNextBlock to look like this:

```js
// Simple check whether we use the hardhat network
const isHardHatNetwork = () => {
  return hre.network.name === "hardhat";
};

async function waitNextBlock() {
  if (isHardHatNetwork()) {
    return helpers.mine();
  }

  const startBlock = await ethers.provider.getBlockNumber();

  return new Promise((resolve, reject) => {
    const isNextBlock = async () => {
      const currentBlock = await ethers.provider.getBlockNumber();
      if (currentBlock > startBlock) {
        resolve();
      } else {
        setTimeout(isNextBlock, 300);
      }
    };
    setTimeout(isNextBlock, 300);
  });
}
```
