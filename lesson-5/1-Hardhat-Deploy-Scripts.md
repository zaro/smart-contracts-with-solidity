# Hardhat deploy scripts

## 1. Understanding the default deploy script

When you generate new project Hardhat generates a sample contract and along
with that it also generates a deploy script for this contract.

## 2. Changing deploy script to deploy our Lottery contract

Since we don't need the sample contract we are going to change
the script to deploy our Lottery contract.

- Change the script accordingly

- Test whether it passes with `npx hardhat run scripts/deploy.js`

## 3. Deploying to a different network

Just as with the `npx hardhat test` the `--network` parameter is also supported

- Try to deploy the contract to our `local` privatenet
