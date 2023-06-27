# Simple coding exercises in Solidity

## 1. Expanding the HelloWorld contract.

Lets make our simple contract from the previous exercise more capable. We want to make the name of the greeted person configurable.

- Add argument to the greet function of type **string** and with memory location **calldata** like this:

  greet(string calldata greeted)

- Add argument of type string to our HelloWorld event and rename it to Greeting.

- Use the **string.concat(str1, str2)** function to create a new string and pass it as argument to out **Greeting** event. [string.concat](https://docs.soliditylang.org/en/latest/types.html#the-functions-bytes-concat-and-string-concat)

- Deploy the contact and check whether the enhaced greeting is working as expected.

## 2. Use return values

Right now we have one function that does it all. Let's break it down into two separate pieces, one that composes the message and one that actually emits the greeting.

- Add new function **composeGreeting** that takes the same arguments as **greet** but only returns a new string. You can use **memory** storage for the return signature, e.g **returns (string memory r)**

- Use the new function, deploy and test.

## 3. Adding state to our contract

So far our contract is stateless. Let's add a counter that counts how many times we have greeted each person. This counter will be a state variable.

- Add new public state variable of type mapping that will hold a count how many times we greeted each person, e.g. **mapping(string => uint) greetingCount;**

- Update the greet function to keep count of the greetings. **Tip:** you use square brackets to access mapping values by key, eg. **greetingCount[key]**

- Deploy and check whether your new contract is working as expected.

## 4. Make the greetings more sophisticated

Right now the only type of greeting we can use is "Hello". Let's make it configurable.

- Add new enum that will hold the greeting type.

```
    enum GreetingType { Hello, Hi, WhatsUp}
```

- Add a new argument of the enum type to both the **greet** function and the **composeGreeting** functions.

- Handle the new argument ot change the "Hello" hardcoded string to the appropriate greeting. use **revert** if the greeting type is unknown.

- Deploy the contract. When testing keep in mind that the enum value will have to be passed as number, the first enum value is 0, the second 1, and so on..

## 5. Add enhanced state to our contract

Now we count the greetings only by the name of the greeted person, but since now we have also a greeting type we would like to keep track of the counts also by greeting type.

- Add additional state mapping that will count how many times a certain greeting type has been used.

- Deploy and test the contract
