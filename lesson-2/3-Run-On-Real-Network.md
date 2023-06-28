# Running code on a real network

## 1. Start up our private net from lesson 1

Make sure your the private net we've built in Lesson 01 is up and running.

It it is not available, you can use the docker compose setup in private-net directory. Simply run **docker-compose up** in this directory and after everything starts, use **docker-compose exec node1 /bin/sh** to enter node` and **gethX attach** inside it to transfer currency to your Metamask account.

## 2. Deploy the contract from exercise 1

- Open MetaMask Settings, go to Advanced , the find **Customize transaction nonce** and set it to **On**

- Click on the **Connected** tab in your ChainIDE in the upper right corner, disconnect the JavascriptVM and connect your MetaMask wallet.

- Deploy the smart contract and test by invoking the greet method.
