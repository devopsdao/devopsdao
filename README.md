# devopsdao

What it does

Devopsdao app is built as a uniform platform to bring all software development processes to blockchain. It will be used as work marketplace for developers and art creators. Devopsdao user currently have two roles: customer and performer, and on a later stage an auditor role will be introduced to settle disputes. Customer is able to create Task contract with ETH and aUSDC tokens as a reward. Once Performers apply for a Task, Customer is able to select the Performer for Task implementation. After the Task is implemented the Performer applies for a Customer review. Currently all negotiations are performed off-chain via Customer selected method. When Customer is happy with the work done, he signs the review and the Performer will be able to withdraw the tokens to his preferred blockchain supported by Axelar (Moonbase, Ethereum, Binance, Fantom, Avalanche, Polygon).
How we built it

Devopsdao app is built on Flutter 2 powered by Dart language. Framework optimized for fast native apps on any platform: iOS, Android, Desktop Linux Windows and MacOS, Web. Devopsdao is a early bird blockchain project based on Flutter 2, taking the advantage to be presented on major platforms. Devopsdao smart contracts are compiled with truffle and depend on Axelar GMP SDK for cross-chain interoperability. Devopsdao web app is served from Arweave decentralized cloud.
## Getting Started

Feel free to for and build it with

```
flutter build apk
``` 
or 
```
flutter build web
```

or to build a release for all platforms and deploy to ArWeave
```
cider bump patch && flutter build apk && flutter build web && arkb deploy build/web/ --force
```

### IMPORTANT:

If you are not using VScode, be sure to first get the packages:
```
flutter pub get
```
and also autogenerate smart contract interaction library with the help of WebThree:

```
dart run build_runner build
```


### Getting started continued:

You can find smart contract code at
- [Devopsdao solidity smart contract](https://github.com/devopsdao)

Devopsdao project depends on multiple awesome libraries, one of which is maintained by Devopsdao:


- [WebThree: a web3 library for dart](https://pub.dev/webthree)


For further information about the project please visit
[Devopsdao website](https://devopsdao.com)
and [Devopsdao web dapp](https://dodao.dev).