# PACT flash loan demo

Execution:

`pact flashloans.repl -t`

![image](https://user-images.githubusercontent.com/3670816/173607007-7f006a6c-c2c2-4a32-981b-05513995100b.png)


Description:

- This is just a demo to see how the flash loan workflow could be implemented.
- It only covers a subset of the use cases: only ["simple"](https://docs.aave.com/developers/core-contracts/pool#flashloansimple) flavour (one asset) and the repayment is done in the transaction, there is no debt position.
- The real workflow involves moving assets temporarily from reserve to the smart contract received and invoke the caller contract (https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/libraries/logic/FlashLoanLogic.sol) . This behaviour is only simulated in this demo.
- I don't check any address, signature, etc. It is mandatory to check them in order to avoid security risks. As long as no collateral is needed is a high-risk operation which may lead to extract liquidity from the pool. https://www.cpomagazine.com/cyber-security/flash-loan-attack-takes-beanstalk-defi-platform-for-182-million-largest-yet-of-its-type/
