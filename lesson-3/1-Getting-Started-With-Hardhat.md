# Getting Started with Hardhat

## 1. Initialize new hardhat project

- Create an empty folder with the name of your project, e.g. **erc20-token**

- Use npx hardhat to initialize new project :

```sh
  mkdir erc20-token
  cd erc20-token
  npx hardhat@2.14.1
```

NOTE: at the time of writing this, the latest hardhat(2.16.1) has a bug and fails to communicate with privatenets, so we are using a bit older version where the bug doesn't occur.

- Use the default options for the new project:

  - Create a JavaScript project
  - [Enter] to accept the defaults on each following question

- Compile the sample Generated smart contract

  npx hardhat compile

- Run the tests for this smart contract

  npx hardhat test
