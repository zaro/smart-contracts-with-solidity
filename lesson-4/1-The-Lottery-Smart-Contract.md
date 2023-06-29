# The Lottery smart contract

## 1. Create new hardhat project

- Create a new hardhat project as we've shown in lesson 3.

- Remove the default smart contract and test

- Create a new file _Lottery.sol_ in contracts directory.

- Put the following content

```
contract Lottery {
    function random(uint maxNum, uint minNum) public view returns (uint) {
        return 0;
    }

}
```

- Compile the contract

## 2. Add automated test

- Add new test file called _Lottery.js_ in the test directory with the following content

```js
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Lottery", function () {
  let owner, player;
  let lottery;

  // Setup only once at the beginning of the test
  this.beforeAll(async function () {
    [owner, player] = await ethers.getSigners();
    lottery = await ethers.deployContract("Lottery");
  });

  it("Randomness", async function () {
    for (let i = 0; i < 20; i++) {
      const number = await lottery.random(5 + i, 3);
      expect(number)
        .to.be.greaterThanOrEqual(3)
        .and.to.be.lessThanOrEqual(5 + i);
    }
  });
});
```

- Run the tests for this smart contract

  npx hardhat test

## 3. Implementing the random() function

- Implement the random function as shown in the presentation. Since we don't have any state variables yet You can skip them for now, we will add them later.

## 4. Implementing isWinning function

- We want each ticket to have 50/50 % chance to win. Implement isWinning function in the smart contract that returns bool.

```
    function isWinning() public view returns (bool) {
      ....
    }
```

## 5. Testing the isWinning function

Testing if our new function is fair, and produces 50/50 chance for winning is very hard and outside of the scope of this exercise. But we can at least test that it produces both true(win) and false(loose).

- Add the following test case to our test file

```js
it("Win/Loose", async function () {
  const wins = [];
  for (let i = 0; i < 20; i++) {
    wins.push(await lottery.isWinning());
  }
  expect(wins).to.contain(true);
  expect(wins).to.contain(false);
});
```

- No matter what you do the test will always fail with all true or all false

## 6. Improving the test of isWinning function

The test is always failing because all our entropy sources don't change during the test.
Both `block.prevrandao` and `block.timestamp` stays the same for the duration of the current block,
and our test ir too fast and manages to do all 20 calls in the same block. Let's fix that.

We are going to need some helper functions to properly test that.

- Install the helper functions

```sh
  npm install --save-dev @nomicfoundation/hardhat-network-helpers
```

- Import the helper functions

```js
// At the top
const helpers = require("@nomicfoundation/hardhat-network-helpers");
```

- Add a function called `waitNextBlock` that looks like that:

```
async  function waitNextBlock() {
  return helpers.mine();
};

```

- Use this new function in the test loop ,to make sure each call to `lottery.random` happens in a different block.

```js
await waitNextBlock();
```

## 7. Implementing the buy ticket function

- Add the following function to our smart contract

```
    function buyTicket() public payable {
    }

```

- Add the following two events also

```
    event Win(address sender, uint amount);
    event Loose(address sender);
```

- Use the `isWinning()` function to decide whether we win or loose.
  In case of winning just return the ticket price to the winner like this :

```
    payable(msg.sender).transfer(amount);
```

- Also make sure you emit the appropriate event in both cases

## 8. Add test for our buyTicket function

For properly testing this function we will need also a way to check the balance of an address.

Let's first add a helper function that will allow us to conveniently check balances of accounts.

- Add a new variable called getBalances in the test scope

```js
describe("Lottery", function () {
  let owner, player;
  let lottery;
  let getBalances; // add this
```

- Initialize it's value in beforeAll function

```js
getBalances = async () => ({
  lotteryBalance: await ethers.provider.getBalance(lottery.address),
  playerBalance: await ethers.provider.getBalance(player.address),
  ownerBalance: await ethers.provider.getBalance(owner.address),
});
```

- Add the following testcase

```js
it("Test buyTicket", async function () {
  // get balances before buying a ticket
  const before = await getBalances();
  // Buy a ticket, we the the transaction receipt as return value
  const rc = await (
    await lottery
      .connect(player)
      .buyTicket({ value: ethers.utils.parseEther("1") })
  ).wait();

  // get balances after buying a ticket
  const after = await getBalances();

  const win = rc.events.find((e) => e.event === "Win");
  const loose = rc.events.find((e) => e.event === "Loose");

  // Calculate the transaction price based on gas used and the gas price
  const txPrice = ethers.BigNumber.from(rc.effectiveGasPrice).mul(
    ethers.BigNumber.from(rc.gasUsed)
  );

  if (loose) {
    expect(win).to.be.undefined;

    // Check balances in case we lost
    expect(after.lotteryBalance).to.be.equal(
      before.lotteryBalance.add(ethers.utils.parseEther("1"))
    );
    expect(after.playerBalance).to.be.equal(
      before.playerBalance.sub(ethers.utils.parseEther("1")).sub(txPrice)
    );
  } else if (win) {
    expect(loose).to.be.undefined;

    // Check balances in case we won
    expect(after.lotteryBalance).to.be.equal(
      before.lotteryBalance
        .add(ethers.utils.parseEther("1"))
        .sub(win.args.amount)
    );

    expect(after.playerBalance).to.be.equal(
      before.playerBalance
        .sub(ethers.utils.parseEther("1"))
        .sub(txPrice)
        .add(win.args.amount)
    );
  } else {
    expect.fail("No win/loose event was emitted");
  }
});
```

## 9. Add prize ratio to buyTicket

Right now the only thing we win is the price of the ticket sent back to us.
Let's make it more interesting.

Use the random function to get a price divider and multiplier to achieve different prize levels.

```
    // First we calculate the maximum prize
    uint maxPayable = address(this).balance < (2 * msg.value)
        ? address(this).balance
        : (2 * msg.value);
    // Prize is betweeh 1/5th and 2x the ticket price, so choose a random divider
    uint prizeCoef = random(10, 1);
    // The actual prize is the maxim prize divided by our random prize divider
    uint prize = maxPayable / prizeCoef;

```

## 10. Improving the buy ticket test

- Change the `Test buyTicket` test and make it similar to the `Win/Loose` test, so that it runs 20 times in a loop and check that we had both wins and loses.

## 11. Add more entropy to our random() function

- Let's add some state variable(s) that change when tickets are being bought, and feed them to the random() function
