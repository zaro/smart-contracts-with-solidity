# Using a web based IDE

## 1. Using ChainIDE

Go to https://chainide.com/s/dashboard/ and sign in with github.

The IDE is based on VS Code so it should be familiar for anybody who ahs used VS Code.

## 2. Create a new project

- Click a new project and select **Blank template**

  There will be a popup asking you to connect to a wallet. Click on JavascriptVM.

- Create a new file called HelloWorld.sol.

- Put the following content in the file:

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelloWorld {
    event HelloWorld();

    constructor() {}

    function greet() public  {
        emit HelloWorld();
    }
}
```

- Click on **Solidity Compiler** in the toolbar on the right.
- Click **Compile HelloWorld.sol**.

- Then go to the next tool in the toolbar nad click Deploy.

- A new deployed contract will appear in the Interact pane.

- Find the greet method there and submit it.

- You cna open the Internal Transactions tool and inspect the transaction with the method execution.
