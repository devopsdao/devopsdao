## Inspiration
Our mission is to make Devopsdao a major platform for software development in the blockchain community. It will be owned and governed by developers.
We have been inspired by the low gas fees and speed of Moonbeam network and its compatibility with ERC20, and strongly believe that traditional recruitment processes in an epoch of post-covid shift from offices to home-office work needs to be changed and decentralized. Our app aims to help crypto community to manage recruitment in a preferred crypto way, residing in crypto space.

## What it does
Devopsdao app is built as a uniform platform to bring all software development processes to blockchain. It will be used as work marketplace for developers and art creators.
Devopsdao user currently have two roles: customer and performer, and on a later stage an auditor role will be introduced to settle disputes. Customer is able to create Task contract with ETH and aUSDC tokens as a reward. Once Performers apply for a Task, Customer is able to select the Performer for Task implementation. After the Task is implemented the Performer applies for a Customer review. Currently all negotiations are performed off-chain via Customer selected method. When Customer is happy with the work done, he signs the review and the Performer will be able to withdraw the tokens to his preferred blockchain supported by Axelar (Moonbase, Ethereum, Binance, Fantom, Avalanche, Polygon).


## How we built it

Devopsdao app is built on Flutter 2 powered by Dart language. Framework optimized for fast native apps on any platform: iOS, android, Desktop Linux and Windows, MacOs, Web. Devopsdao is a early bird blockchain project based on Flutter 2, taking the advantage to be presented on major platforms.
Devopsdao smart contracts are compiled with truffle and depend on Axelar GMP SDK for cross-chain interoperability.
Devopsdao web app is served from Arweave decentralized cloud.

## Challenges we ran into

Dart language lacks libraries supporting Web3, we had to experiment a lot with Wallet Connect and Moonbeam network and port some Axelar SDK functions from JS to Dart.

## Accomplishments that we're proud of

Devopsdao is built using a single codebase for all major platforms: Android, IOS and Web, we have managed to implement cross-chain withdrawals from Moonbeam with the help of Axelar and have gained some progress of making it fully available from any chain supported by Axelar.

## What we learned

We learned about Moonbeam cross-chain network capabilities and Axelar network inter-chain calls.

## What's next for Devopsdao

We are going to complete the implementation of inter-chain operation with the help of Axelar, add Auditor role, prepare Solidity code for a security review, add NFT support for user roles and achievements, add multi-user funding ability for community initiatives, port Metamask connector to Dart, refactor the Flutter code and gamify in-app processes.