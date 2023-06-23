# Building a PoA private network

## 1. Download and install geth

- Download the latest version of from https://geth.ethereum.org/downloads. Make sure to download the **Geth & Tools** archive, not the plain **Geth**
- Extract the archive and move it to a permanent location.
- Add this directory your shell path
  - On linux/macOS add the following to your `~/.bashrc` or `~/.zshrc`

```
      export PATH=$PATH:<EXTRACTED_GETH_DIR>
```

- On windows follow this guide https://windowsloop.com/how-to-add-to-windows-path/
- Restart your terminal and make sure geth is working

```
    ∴ geth --version
    geth version 1.12.0-stable-e501b3b0
```

## 2. Create the authority account for PoA

In a PoA configuration only certain trusted authority accounts are allowed to sign(seal) blocks. We need to first create a password for this account and then use **geth** to create the account.

- Create a text file containing the password for the new account. for example:

```
    echo "123456" > pass.txt
```

- Use geth to create the account:

```
    ∴ geth account new --password pass
    INFO [06-23|10:52:04.106] Maximum peer count                       ETH=50 LES=0 total=50

    Your new key was generated

    Public address of the key:   0xA28049654f0A7C60666224C507fA2764F49E31bE
    Path of the secret key file: /home/zaro/.ethereum/keystore/UTC--2023-06-23T07-52-04.106456119Z--a28049654f0a7c60666224c507fa2764f49e31be

    - You can share your public address with anyone. Others need it to interact with you.
    - You must NEVER share the secret key with anyone! The key controls access to your funds!
    - You must BACKUP your key file! Without the key, it's impossible to access account funds!
    - You must REMEMBER your password! Without the password, it's impossible to decrypt the key!
```

- List all the account we have locally:

```
    ∴ geth account list
    INFO [06-23|10:53:15.300] Maximum peer count                       ETH=50 LES=0 total=50
    Account #0: {a28049654f0a7c60666224c507fa2764f49e31be} keystore:///home/zaro/.ethereum/keystore/UTC--2023-06-23T07-52-04.106456119Z--a28049654f0a7c60666224c507fa2764f49e31be
```

## 3. Creating the chain genesis configuration and initializing the blockchain

Creating a new blockchain With ethereum starts by defining parameters for the chain. For **geth** this is done in a JSON file, containing all the parameters. Here is an example of such configuration:

```jsonc
{
  "config": {
    // chainId is the ID of the new chain, make sure it doesn't collide with existing one by checking https://chainlist.org/
    "chainId": ${CHAIN_ID},
    // the *Block parameters configure block numbers where breaking changes and/or forks in the mainnet. Since this is private and new network we can leave them all at 0
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0,
    "istanbulBlock": 0,
    "berlinBlock": 0,
    // we are going to use clique PoA consensus
    "clique": {
      // new block every 10 seconds
      "period": 10,
      // this is only used when voting changes in the clique, the default is good enough
      "epoch": 30000
    }
  },
  // This is useful only for hash mining, so not relevant
  "difficulty": "1",
  // set the gas limit per transaction
  "gasLimit": "90000",
  // extradata means different things with different configuration. For clique consensus we have to put here the address of the sealer for this network
  "extradata": "0x0000000000000000000000000000000000000000000000000000000000000000${AUTHORITY_ACCOUNT}0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  // alloc -  allows you to preallocate currency to certain accounts
  "alloc": {
    "${AUTHORITY_ACCOUNT}": { "balance": "100000000000000000000000000000000000000000000000000000000000000000" }
  }
}
```

- Create a new text file called _genesis.json_ and populate it with the above example by removing the comments and replacing the **${}** placeholders with their respective values.

- Initialize the blockchain with **geth init**

```
∴ geth init genesis.json
INFO [06-23|11:14:41.196] Maximum peer count                       ETH=50 LES=0 total=50
INFO [06-23|11:14:41.227] Set global gas cap                       cap=50,000,000
INFO [06-23|11:14:41.227] Initializing the KZG library             backend=gokzg
INFO [06-23|11:14:41.269] Defaulting to pebble as the backing database
INFO [06-23|11:14:41.269] Allocated cache and file handles         database=/home/zaro/.ethereum/geth/chaindata cache=16.00MiB handles=16
INFO [06-23|11:14:41.323] Opened ancient database                  database=/home/zaro/.ethereum/geth/chaindata/ancient/chain readonly=false
INFO [06-23|11:14:41.324] Writing custom genesis block
INFO [06-23|11:14:41.324] Persisted trie from memory database      nodes=1 size=167.00B time="19.968µs" gcnodes=0 gcsize=0.00B gctime=0s livenodes=0 livesize=0.00B
INFO [06-23|11:14:41.328] Successfully wrote genesis state         database=chaindata                           hash=f1f602..6fa52a
INFO [06-23|11:14:41.329] Defaulting to pebble as the backing database
INFO [06-23|11:14:41.329] Allocated cache and file handles         database=/home/zaro/.ethereum/geth/lightchaindata cache=16.00MiB handles=16
INFO [06-23|11:14:41.382] Opened ancient database                  database=/home/zaro/.ethereum/geth/lightchaindata/ancient/chain readonly=false
INFO [06-23|11:14:41.382] Writing custom genesis block
INFO [06-23|11:14:41.383] Persisted trie from memory database      nodes=1 size=167.00B time="13.636µs" gcnodes=0 gcsize=0.00B gctime=0s livenodes=0 livesize=0.00B
INFO [06-23|11:14:41.387] Successfully wrote genesis state         database=lightchaindata                           hash=f1f602..6fa52a
```

## 4. Start the node and check balances

Now that we have initialized our blockchain we can start a node and connect to it via the builtin geth console.

- Start the node

```
∴ geth --networkid 5342
INFO [06-23|11:18:00.634] Maximum peer count                       ETH=50 LES=0 total=50
INFO [06-23|11:18:00.674] Set global gas cap                       cap=50,000,000
INFO [06-23|11:18:00.675] Initializing the KZG library             backend=gokzg
INFO [06-23|11:18:00.718] Allocated trie memory caches             clean=154.00MiB dirty=256.00MiB
INFO [06-23|11:18:00.718] Using pebble as the backing database
INFO [06-23|11:18:00.718] Allocated cache and file handles         database=/home/zaro/.ethereum/geth/chaindata cache=512.00MiB handles=262,144
INFO [06-23|11:18:00.758] Opened ancient database                  database=/home/zaro/.ethereum/geth/chaindata/ancient/chain readonly=false
INFO [06-23|11:18:00.759] Initialising Ethereum protocol           network=5342 dbversion=<nil>
INFO [06-23|11:18:00.759]
............
```

- In another terminal open a JS console to interact with the node:

```
∴ geth attach
Welcome to the Geth JavaScript console!

instance: Geth/v1.12.0-stable-e501b3b0/linux-amd64/go1.20.3
at block: 0 (Thu Jan 01 1970 02:00:00 GMT+0200 (EET))
 datadir: /home/zaro/.ethereum
 modules: admin:1.0 clique:1.0 debug:1.0 engine:1.0 eth:1.0 miner:1.0 net:1.0 rpc:1.0 txpool:1.0 web3:1.0

To exit, press ctrl-d or type exit
>
```

- Lets check what accounts are present on this node and their balance:

```js
> eth.accounts
["0xa28049654f0a7c60666224c507fa2764f49e31be"]
> eth.getBalance(eth.accounts[0])
1e+65
// Note that the above value is in Wei, to get the ether use
> web3.fromWei(eth.accounts[0], 'ether')
1e+47
```

## 5. Transfer some ETH

Since all the ETH in our privatenet are held by the master account, we need to transfer some to our account. We can the the geth console or that.

```js
// Lets send ourselves 100ETH
// Replace the to argument with your MetaMask account address
> eth.sendTransaction({
  to: "0x53a3B605b0E44D872e3455f70Ac48807609c1B3a",
  from: eth.accounts[0],
  value: web3.toWei(100, 'ether'),
  gas: 21000,
});
Error: authentication needed: password or unlock
        at web3.js:6365:9(39)
        at send (web3.js:5099:62(29))
        at <eval>:1:20(18)
```

Since the account is locked with a password, we cannot just make transactions out of it. Let's restart the node with account unlocked.

- Stop the _geth_ node running by hitting Ctrl-C
- Start it again with _--unlock_ argument to unlock the master account

```
∴ geth --networkid 5342 --unlock a28049654f0a7c60666224c507fa2764f49e31be --password pass
INFO [06-23|11:58:19.549] Maximum peer count                       ETH=50 LES=0 total=50
INFO [06-23|11:58:19.577] Set global gas cap                       cap=50,000,000
INFO [06-23|11:58:19.577] Initializing the KZG library             backend=gokzg
.......................................
INFO [06-23|11:58:20.324] Unlocked account                         address=0xA28049654f0A7C60666224C507fA2764F49E31bE
........................................
```

- Lets retry the send transaction:

```js
> eth.sendTransaction({
  to: "0x53a3B605b0E44D872e3455f70Ac48807609c1B3a",
  from: eth.accounts[0],
  value: web3.toWei(100, 'ether'),
  gas: 21000,
});

"0x2855d8dbc4d803c795a1e67e1a6f014864635565a6ecbc64dcef9b009ba6170d"
```

- Check the pending transaction:

```js
> eth.pendingTransactions
[{
    blockHash: null,
    blockNumber: null,
    chainId: "0x14de",
    from: "0xa28049654f0a7c60666224c507fa2764f49e31be",
    gas: 21000,
    gasPrice: 1000000000,
    hash: "0x2855d8dbc4d803c795a1e67e1a6f014864635565a6ecbc64dcef9b009ba6170d",
    input: "0x",
    nonce: 0,
    r: "0x517848adb50596a74fad71541579fa526128d10695d4f3c1c536400b2d668a17",
    s: "0x5d2c4d4ae14fdd5b093ec654d2c1825f68c23cbf6b73a67283055d444639e5ad",
    to: "0x53a3b605b0e44d872e3455f70ac48807609c1b3a",
    transactionIndex: null,
    type: "0x0",
    v: "0x29e0",
    value: 100000000000000000000
}]
```

NOTE: No matter how log you wait , the transaction will be pending

## 6. Running a miner/sealer

Our transaction from the previous step will be forever in pending until the block of the transaction is sealed. Usually it is the consensus layer that will do that, but in our simple privatenet we are going to use the builtin miner in geth. It's called miner because originally with PoW the blocks were sealed by doing work(or mining). In a PoA system there is no need to mine anything, the blocks are simply sealed by the authority account of the network.

Let's restart out node with miner enabled.

- Stop your node with Ctrl-C
- Start it again with _--mine_ and _--miner.etherbase_ arguments

```
∴ geth --networkid 5342 --unlock a28049654f0a7c60666224c507fa2764f49e31be --password pass --mine --miner.etherbase 0xa28049654f0a7c60666224c507fa2764f49e31be
.......
INFO [06-23|12:10:38.001] Successfully sealed new block            number=4 sealhash=c54644..ccfe65 hash=f8cfe0..c4d029 elapsed=4.998s
INFO [06-23|12:10:38.001] "🔨 mined potential block"                number=4 hash=f8cfe0..c4d029
INFO [06-23|12:10:38.002] Commit new sealing work                  number=5 sealhash=297153..5c97ef uncles=0 txs=0 gas=0     fees=0       elapsed=1.004ms
INFO [06-23|12:10:38.003] Commit new sealing work                  number=5 sealhash=297153..5c97ef uncles=0 txs=0 gas=0     fees=0       elapsed=1.620ms
INFO [06-23|12:10:43.000] Successfully sealed new block            number=5 sealhash=297153..5c97ef hash=af96f9..79a548 elapsed=4.998s
INFO [06-23|12:10:43.000] "🔨 mined potential block"                number=5 hash=af96f9..79a548
INFO [06-23|12:10:43.002] Commit new sealing work                  number=6 sealhash=1cf225..298b18 uncles=0 txs=0 gas=0     fees=0       elapsed=1.210ms
INFO [06-23|12:10:43.002] Commit new sealing work                  number=6 sealhash=1cf225..298b18 uncles=0 txs=0 gas=0     fees=0       elapsed=2.118ms
INFO [06-23|12:10:44.625] Looking for peers                        peercount=0 tried=113 static=0
INFO [06-23|12:10:48.002] Successfully sealed new block            number=6 sealhash=1cf225..298b18 hash=0fe41d..1583ff elapsed=5.000s

```

- Go back to geth console and check the pending transactions again

```js
> eth.pendingTransactions
[]
```

- Check our wallet balance

```
> web3.fromWei(eth.getBalance('53a3B605b0E44D872e3455f70Ac48807609c1B3a'), 'ether')
100
```

## 7. Connecting MetaMask to our privatenet

Now that we have some ETH in our MetaMask account let's try to access it from MetaMask. MetaMask connect to the network by HTTP API. For the public/testnets there are many public endpoints for this API and MetaMask si pre-configured to use them. For our own privatenet we have to first enable this api on our node, and then use it to connect with MetaMask to our network.

### 7.1 Enabling HTTP API on geth

The following **geth** options control the HTTP api:

```
    --http                         (default: false)
    --http.addr value              (default: "localhost")
    --http.api value
    --http.corsdomain value
    --http.port value              (default: 8545)
    --http.rpcprefix value
    --http.vhosts value            (default: "localhost")
```

- Stop our node and restart it while adding _--http_ options to configure the HTTP API.

```
∴ geth --networkid 5342 --unlock a28049654f0a7c60666224c507fa2764f49e31be --password pass --mine --miner.etherbase 0xa28049654f0a7c60666224c507fa2764f49e31be --http
........
INFO [06-23|12:23:47.263] HTTP server started                      endpoint=[::]:8545 auth=false prefix= cors=* vhosts=localhost
INFO [06-23|12:23:47.264] WebSocket enabled                        url=ws://127.0.0.1:8551
INFO [06-23|12:23:47.264] HTTP server started                      endpoint=127.0.0.1:8551 auth=true  prefix= cors=localhost vhosts=localhost
Fatal: Account unlock with HTTP access is forbidden!
```

**This error is normal.** For security reasons it is not allowed to but have unlocked account and HTTP API on the same node. It seems we will have to add new node to our network only HTTP access.

- Start the node atain w/o the _--http_ argument

```
∴ geth --networkid 5342 --unlock a28049654f0a7c60666224c507fa2764f49e31be --password pass --mine --miner.etherbase 0xa28049654f0a7c60666224c507fa2764f49e31be
```

### 7.2 Adding a second node to our private net

All our node configuration and data is located in _~/.ethereum/geth_ on Linux/macOS and _%localappdata%\Ethereum\geth_ on Windows. In order to run a second node we need to use a different data directory for the second node.

Since geth opens few ports by default for communication we need to tell it to use different ports so it doesn't clash with the first node.

Also we need to tell the second node how to connect to the first node.

- Repeat exercise 3 to create a second node but with _--datadir=_ argument set to a different directory that the default one. eg.

```
∴  geth --datadir ~/.ethereum/geth2 ........
```

- Obtain the first node ENODE identifier

```sh
# Get the node private key
∴ cat ~/.ethereum/geth/nodekey
70211671c5185f74854b6a311c134eb4f2907809066bac75a71ec5fb45e3a41f
# Obtain public key from it
∴ bootnode --nodekeyhex 70211671c5185f74854b6a311c134eb4f2907809066bac75a71ec5fb45e3a41f --writeaddress
66f1ff5949a5cedfae238ae27bb1e1aae46c13509b78c815a284273042b89d546b9361217c04dfd966cd1ad812e4b71a8c5e4e348457d1fa620fff881841f342
# This last number is our ENODE id
```

- Start a second node with HTTP API enabled, different network ports and configured to connect to the first node

```
∴ geth --datadir ~/.ethereum/geth2 --networkid 5342 --port 30304  --authrpc.port 8552 --http '--http.corsdomain=*' --bootnodes enode://66f1ff5949a5cedfae238ae27bb1e1aae46c13509b78c815a284273042b89d546b9361217c04dfd966cd1ad812e4b71a8c5e4e348457d1fa620fff881841f342@127.0.0.1:30303
..........
INFO [06-23|12:53:48.668] HTTP server started                      endpoint=127.0.0.1:8545 auth=false prefix= cors= vhosts=localhost
..........
NFO [06-23|12:54:19.840] Looking for peers                        peercount=1 tried=159 static=0
..........
```

### 7.3 Connect with MetaMask

- Open **MetaMask Settings**, and go to _Networks_
- Click **Add Network**
- Fill in the required fields:
  - Network name, give any name you like
  - RPC URL: https://127.0.0.1:8545
  - Chain ID: the chain ID you selected for your network (5342)
  - Currency Symbol, give any name you like to your currency
- If everything is correct, you should be able to save the new network and see that you have 100 ETH( or whatever you called your currency) in your account.

## 8 Q&A
