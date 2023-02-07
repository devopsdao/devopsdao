// import 'package:js/js.dart';

import 'package:devopsdao/blockchain/task.dart';
import 'package:flutter/material.dart';
import 'package:webthree/credentials.dart';
import 'accounts.dart';

class EmptyClasses extends ChangeNotifier {
  final loadingTask = Task(
    nanoId: '111',
    createTime: DateTime.now(),
    taskType: 'task[2]',
    title: 'Loading...',
    description: 'Error: loading task',
    tags: [],
    tagsNFT: [],
    symbols: [],
    amounts: [],
    taskState: 'loading',
    auditState: '',
    rating: 0,
    contractOwner: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
    participant: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
    auditInitiator: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
    auditor: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
    participants: [],
    funders: [],
    auditors: [],
    messages: [],
    taskAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
    justLoaded: true,
    contractValue: 0,
    contractValueToken: 0,
    transport: ''
  );

  final emptyTask = Task(
      nanoId: '111',
      createTime: DateTime.now(),
      taskType: 'task[2]',
      title: 'empty',
      description: 'Error: task are empty',
      tags: [],
      tagsNFT: [],
      symbols: [],
      amounts: [],
      taskState: 'empty',
      auditState: '',
      rating: 0,
      contractOwner: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      participant: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      auditInitiator: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      auditor: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      participants: [],
      funders: [],
      auditors: [],
      messages: [],
      taskAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      justLoaded: true,
      contractValue: 0,
      contractValueToken: 0,
      transport: ''
  );

  final loadingAccount = Account(
      rating: 0,
      nickName: 'Loading...',
      about: 'Error: loading account',
      walletAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000')
  );

  final emptyAccount = Account(
      rating: 0,
      nickName: 'Empty',
      about: 'Error: empty account',
      walletAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000')
  );
}
