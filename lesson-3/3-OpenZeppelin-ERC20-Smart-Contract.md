# OpenZeppelin ERC20 smart contract

## 1. Create the smart contract

- Add the openzeppelin contracts to your project

```
npm install @openzeppelin/contracts
```

- Create a new file _MyToken.sol_ in contracts directory.

- Put the following content

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {}
}
```

- Compile the contract

  npx hardhat compile

## 2. Add automated test

- Add new test file called _MyToken.js_ in the test directory with the following content

```js
// Load dependencies
const { expect } = require("chai");

describe("Token contract", function () {
  it("Deployment should assign the total supply of tokens to the owner", async function () {
    const [owner] = await ethers.getSigners();

    const myToken = await ethers.deployContract("MyToken");

    const ownerBalance = await myToken.balanceOf(owner.address);
    const totalSupply = await myToken.totalSupply();
    expect(totalSupply).to.equal(ownerBalance);
    expect(totalSupply).to.equal(0);
  });
});
```

- Run the tests for this smart contract

  npx hardhat test

## 3. Adding token supply

As you can see from our test the total current amount of tokens we have in our contract is 0. Let's mint some tokens.

- Use the contract builtin method called [\_mint](https://docs.openzeppelin.com/contracts/4.x/api/token/erc20#ERC20-_mint-address-uint256-) with signature `_mint(address account, uint256 amount)` to pre-mint some tokens. Call this function in the constructor.

  - assign the pre-minted tokens to the contract creator, you can use **msg.sender** global variable to get it's address.
  - by default the contract is created with 18 decimals for the token amount, meaning that the amount for 1 token is 10\*\*18 (10 to the 18th power). You can use the builtin [decimals](https://docs.openzeppelin.com/contracts/4.x/api/token/erc20#ERC20-decimals--) function to get the number of decimals of the contract contract.

- Adjust the test

## 4. Allowing post deployment token minting

Right now once the contract is deployed there no way to add mint more tokens. Sometimes it is necessary to be able to do that. Let's enable it.

- Add new public method called `mint()` with the same signature as `_mint()` we used in ouw constructor.

- Invoke this new method in the test and check if the total supply has increased

```
await myToken.mint(owner.address, BigInt(1000000000000000000000));
```

## 5. Adding access control to te mint function

The way we implemented our new method is fine, but it currently allows anybody on the network to create tokens for themselves. It's good we are running only on test node:) Let's fix that.

The openzeppelin already supports that in the [Ownable](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.2/contracts/access/Ownable.sol) abstract smart contract. It initializes the ownership to the to smart contract creator and adds function modifier `onlyOwner` that allows only the owner to call the function it is applied to.

- import the Ownable abstract smart contract from openzeppelin

```
import "@openzeppelin/contracts/access/Ownable.sol";
```

- make MyToken derive not only from ERC20 but also Ownable

- apply the modifier to our mint function

```
function mint(address to, uint256 amount) public onlyOwner {
```

- Compile the contract

- let's test that minting by non-owner address is forbidden.

- Get another account from the test framework

```js
// change
const [owner] = await ethers.getSigners();
// to
const [owner, addr1] = await ethers.getSigners();
```

- add the following expect that checks that w method will revert and not succeed.

```js
// test minting with non-owner account
await expect(myToken.connect(addr1).mint(addr1.address, 50)).to.be.revertedWith(
  "Ownable: caller is not the owner"
);
```
