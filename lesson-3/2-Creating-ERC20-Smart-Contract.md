# Creating ERC20 smart contract

## 1. Create ERC20 smart contract

- Create a new file _ERC20Token.sol_ in contracts directory.

- Put the following content

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

contract ERC20Token is IERC20 {}
```

- Compile the contract

  npx hardhat compile

- There will be plenty of `Note: Missing implementation: ` errors, that's normal.

- Let add implementation for each method that is :

```
revert("Not Implemented")
```

- Now the errors will be gone and we will have a lot of warnings. Let's ignore them for now.

## 2. Add automated test

- Add new test file called _ERC20Token.js_ in the test directory with the following content

```js
// Load dependencies
const { expect } = require("chai");

describe("ERC20 Token contract", function () {
  it("Test contract", async function () {
    const [owner, addr1] = await ethers.getSigners();
    const myToken = await ethers.deployContract("ERC20Token");

    await expect(myToken.totalSupply()).to.be.revertedWith("Not Implemented");
  });
});
```

- Run the tests for this smart contract

  npx hardhat test

## 3. Implementing some functions

Let's implement the totalSupply function and test that it works properly;

- Remove the revert from `totalSupply()` and put `return 1000 * 10 ** 18;`

- Change the expect for the total supply in the test , to expect value instead of revert like this:

```js
expect(await myToken.totalSupply()).to.equal(1000n * 10n ** 18n);
```

## 4. Adding token ownership

Now we have a supply of tokens, but nobody can own anything. Let's keep track of who owns what.

At the time of creation, we will assign all the token supply to the contract owner.

- Add a state variable with type mapping that will store the balance of each address

```
  mapping(address => uint) public balances;
```

- Add constructor to our smart contract and assign the total supply to the owner of the contract

```
  balance[msg.sender] = 1000 * 10 ** 18;
```

- Implement the balanceOf function, to correctly return the balance

- Add a check in the test, that verifies that all the tokens are owned by the contract creator

```
    expect(await myToken.balanceOf(owner.address)).to.equal(1000n * 10n ** 18n);
```

## 5. Adding ability to transfer

OK, all the tokens are owned by a single account now, but we have no way to transfer them to another account.
Let's implement the transfer method.

- Implement the transfer method.

- Use the following test to check if you have implemented it correctly

```js
const tx = await myToken.transfer(addr1.address, 100n * 10n ** 18n);
const rc = await tx.wait();
const event = rc.events.find((event) => event.event === "Transfer");
expect(event).to.have.property("event", "Transfer");
expect(await myToken.balanceOf(addr1.address)).to.equal(100n * 10n ** 18n);
expect(await myToken.balanceOf(owner.address)).to.equal(900n * 10n ** 18n);
```
