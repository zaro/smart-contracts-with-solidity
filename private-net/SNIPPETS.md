# Send 1 ETH to address

```sh
geth1 attach
```

and in the console

```js
eth.sendTransaction({
  to: "0x53a3B605b0E44D872e3455f70Ac48807609c1B3a",
  from: eth.accounts[0],
  value: 10000000000000000000,
  gas: 21000,
});
```
