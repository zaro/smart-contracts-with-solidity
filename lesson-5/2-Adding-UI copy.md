# Adding UI

## 1. Let's start by creating a simple HTML page

- Make a new directory called `frontend` in the project directory

- Add `index.html` with the following content:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script src="https://cdn.jsdelivr.net/gh/ethereum/web3.js/dist/web3.min.js"></script>
    <style>
      .header {
        font-family: sans-serif;
        text-align: center;
      }
    </style>
  </head>
  <body>
    <h2>Lottery page</h2>
    <h2 id="info"></h2>
    <br />
    <button>Buy Ticket</button>
    <p>Lottery Prize Pool: <span id="balance"> 0</span></p>
    Status: <span id="status">Loading...</span>
    <script type="text/javascript"></script>
  </body>
</html>
```

- Add a simple web server to serve out HTML

```sh
npm install serve
```

- Start the server and check if the page is being shown

```sh
npx serve frontend/
```

## 2. Initializing the Web3 library

- Add the following JavaScript in the existing `<script>` tag near the end of the file.

```js
let web3;

async function loadWeb3() {
  if (window.ethereum) {
    web3 = new Web3(window.ethereum);
    window.ethereum.enable();
  } else {
    alert("No Ethereum provider found!");
  }
}

async function load() {
  await loadWeb3();
}
load();
```

- Save, and open the page in your browser where you have MetaMask Installed

- You should see a dialog asking you to allow the page to use your MetaMask account

- Allow the connection

## 3. Initializing the contract

- Add the following variables below our `web3` variable:

```js
let web3;

let contractABI = [];
let contractAddress = "0x0";

let contract;
```

- Add the following line in the load function

```js
contract = new web3.eth.Contract(contractABI, contractAddress);
```

- Replace the values of `contractABI` and `contractAddress` with their respective values
  - `contractABI` should be set to the content of the `abi` key in our compiled contract JSON in the artifacts directory
  - `contractAddress` should be set to the address which you got when deploying the the contract

## 4. Showing the prize pool of our lottery

This is as simple as showing the balance of our lottery contract;

- Add the following function to show the contact balance

```js
async function updatePrizePool() {
  const amount = await web3.eth.getBalance(contractAddress);
  const balanceEl = document.getElementById("balance");
  const balanceToEther = web3.utils.fromWei(amount.toString(), "ether");
  balanceEl.innerHTML = balanceToEther;
}
```

- Call the function once in the `load()` function and check that you have some number instead of the question mark after you refresh the page

## 5. Buying a ticket

Lets now add a way for the user to buy a ticket. We have a **Buy Ticket** button, let's make it call our buyTicket contract function. Also since this is an operation that takes time, we will add a simple function that will let us update the status message on the page;

- Add the `updateStatus()` function

```js
function updateStatus(status) {
  const statusEl = document.getElementById("status");
  statusEl.innerHTML = status;
  console.log(status);
}
```

- Call the update status function at the end of `load()` so that we know app is initialized

```js
updateStatus("Ready");
```

- Now let's add the actual buyTicket function

```js
async function onBuyTicket() {
  updateStatus("Buying a ticket....");
  const account = (await web3.eth.getAccounts())[0];
  const rc = await contract.methods
    .buyTicket()
    .send({ from: account, value: web3.utils.toWei("1", "ether") });
  console.log(rc);
  updateStatus("Done");
}
```

- Make sure to call it in the `onclick` event of the **Buy Ticket** button

- Test that buying a ticket actually works without errors

## 6. Improving the user experience

Right now we can buy a ticket, but we don't know whether we won or lost. Let's improve our buyTicket function to update the status message based on the result.
Just as with the tests we have a recept for the transaction and in this receipt we can access the events emitted during the transaction.

- Open the browser console and inspect the receipt
- Use this information to update the status accordingly instead of simply displaying _Done_
  - In case of winning display a message like: "You've won ${amount} ETH"
  - In case of loosing display: "You lost. Try again!"

## 7. Showing balances

Right now we only show the contract balance and it is updated only on page load.

- Make sure you update the contract (prize pool) balance after each ticket bought
- Add a second field displaying the player wallet balance and update it after each ticket bought

## 8. Showing the number of tickets bought

- Alter the smart contract , and add a counter counting how many tickets were sold (if it doesn't exists already)
- Recompile and redeploy the contract
- Show this counter below the balances and update it in a similar manner
