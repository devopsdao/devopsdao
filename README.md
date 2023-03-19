# Dodao

deployed to Moonbase alpha: https://arweave.net/9evFw5LQKVqt6928hTOZ0kDGtPDCXEgjsNIFtjMDO8Q

Dodao.dev dApp is built as an uniform platform to bring all software development processes to blockchain. It will be used as work marketplace for developers and art creators. Dodao.devusers currently have three roles:

   - customer
   - performer
   - auditor

Customer is able to create Task contract with DEV and USDC tokens as a reward. Once Performers apply for a Task, Customer is able to select the Performer for Task implementation. After the Task is implemented the Performer applies for a Customer review. Currently all negotiations are performed off-chain via Customer selected method (such as Telegram or Discord for example). When Customer is happy with the work done, he signs the review and the Performer will be able to withdraw the tokens. If any dispute occurs an Auditor can be invited to review the task and settle it.

## Tech

Tech: Dart, Flutter, Fantom, Arweave, Axelar, Hyperlane, Wormhole, LayerZero, Witnet, Solidity, Walletconnect, Ethereum EIP-2535 Diamonds, EIP-1155 multi token contracts.

Devopsdao dApp is built on Flutter 3 powered by Dart language. Framework optimized for fast native apps on any platform. Devopsdao is a early bird blockchain project based on Flutter, taking the advantage to be presented on major platforms. Devopsdao EIP-2539 based smart contract Diamonds are compiled with hardhat and depend on Axelar GMP SDK for cross-chain interoperability. Devopsdao web app is served from Arweave decentralized cloud. Ongoing integration with Web APIs(like Github) via Witnet. Implemented Axelar, Hyperlane, Layerzero and Wormhole smart contacts as Diamond facets to enable cross-chain features. Dodao dApp is deployed on Fantom and is available via Axelar GMP from Axelar supported blockchains. It is also available via Hyperlane, Wormhole and LayerZero bridges. For Web3 interaction we support our own WebThree library.
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
- [Dodao.dev solidity smart contract](https://github.com/devopsdao)

Dodao.dev project depends on multiple awesome libraries, one of which is maintained by Dodao.dev:


- [WebThree: a web3 library for dart](https://pub.dev/webthree)


For further information about the project please visit
[Dodao.dev website](https://docs.dodao.dev)
and [Dodao.dev web dapp](https://dodao.dev).
