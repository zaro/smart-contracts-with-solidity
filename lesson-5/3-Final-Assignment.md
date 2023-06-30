# Final Assignment

This is your final project in this course. You are going to build a voting smart contract.

## Requirements

### Voting rules

- Voting is allowed only between `timeStart` and `timeEnd`, both must be set on contract creation.

  - NOTE: `timeStart` and `timeEnd` must be customizable , meaning we should be able to deploy the same contract with different `timeStart` and `timeEnd` multiple times

- Voting options are fixed number and are set on contract creation. There is no need for customization, they can be hard coded, pick anything you like.

- Anybody with valid Ethereum account can participate

- Each account can vote only once, and cannot change their vote once the vote is cast

### What will you need to know

- A way to know the current time

  - block.timestamp - current block timestamp in seconds since Unix epoch

- Storage to keep who has already voted
- Storage to count ballots
- Interacting with your smart contract from a web page: https://docs.web3js.org/
  - NOTE: this article will be useful to understand better how to call smart contract methods from Web3 - https://bitsofco.de/calling-smart-contract-functions-using-web3-js-call-vs-send/

### What should you deliver

A zip archive or a link to git repo containing the following:

#### 1. Smart contract

- A hardhat project with only your smart contract inside
- At least one test case. The test should be passing with the default **hardhat** network/vm. Whether the test works on a real network will not matter.
- Functional deploy script, that deploys your contract

#### 2. UI

- A simple web page that:
  - Allows you to cast your vote between `timeStart` and `timeEnd`
  - Displays the election result after `timeEnd`
