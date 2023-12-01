# Dodao
**Dodao.dev is a Task marketplace for Developers and Art-creators**


deployed to Moonbase alpha: https://arweave.net/9evFw5LQKVqt6928hTOZ0kDGtPDCXEgjsNIFtjMDO8Q

Dodao dApp is built as an uniform platform to bring all software development processes to blockchain. 

Dodao.dev users currently have three roles:

   - customer
   - performer
   - auditor

Shortly, Dodao business flow is the following:

* User, who is in Customers' role is able to create Task contract with native, ERC-20, ERC-1155 or ERC-721 tokens as a reward. 
* Users who are in Perfomers' role can apply for a Task, and Customer is able to select Performer for Task implementation. 
* After Perfomer finishes his work on a Task, they apply for Customer review. When Customer or Performer have anything to discuss, they can use in-Task chat which is recorded on the blockchain.
* When Customer is happy with the work done, they sign a review and then Performer is able to withdraw earned tokens. 
* If any dispute occurs an Auditor can be invited to review the task and settle it in either Customer or Performer favour.

## Tech

Tech: Dart, Flutter, Fantom, Arweave, Axelar, Hyperlane, Wormhole, LayerZero, Witnet, Solidity, Walletconnect, Ethereum EIP-2535 Diamonds, EIP-1155 multi token contracts.
Blockchains: Tanssi Dancebox Appchain(thank you [Tanssi](https://www.tanssi.network/) ❤️ for onboarding us as Appchain Pioneers!), ZkSync testnet, Moonbeam Moonbase-alpha, Polygon Mumbai, Fantom testnet, Ethereum Goerli

Dodao dApp tech details:
dApp is built on Flutter 3 powered by Dart language, a framework which is optimized for fast native apps on any platform. 
EIP-2539 based smart contract Diamonds are compiled with [hardhat](https://hardhat.org) and deployed with [ethers.js](https://ethers.org)
Web version is served from Arweave decentralized cloud.
Github integration via [Witnet Oracle](https://witnet.io) (thank you Witnet team ❤️ for a grant!). 
Implemented [Axelar](https://axelar.network), [Hyperlane](https://hyperlane.xyz), [Layerzero](https://layerzero.network) and [Wormhole](https://wormhole.com/) smart contacts as Diamond facets to enable cross-chain features, integration with Dodao dApp is ongoing.
For Web3 interaction we support our own [WebThree library](github.com/devopsdao/webthree) (thank you [Archethic team](https://www.archethic.net) for contributions!).

## Building

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
flutter build apk && flutter build web && arkb deploy build/web/ --force
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


### Related repositories

You can find smart contract code at
- [Dodao.dev solidity smart contract](https://github.com/devopsdao)

Dodao.dev project depends on multiple awesome libraries, one of which is maintained by Dodao.dev:


- [WebThree: a web3 library for dart](https://pub.dev/webthree)

### More
For further information about the project please visit
[Dodao.dev website](https://docs.dodao.dev)
and [Dodao.dev web dapp](https://dodao.dev).
