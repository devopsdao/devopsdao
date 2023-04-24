// import 'package:js/js.dart';

import 'package:dodao/blockchain/classes.dart';
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
      repository: 'https://github.com/devopsdao/dodao',
      tags: [],
      tagsNFT: [],
      symbols: [],
      amounts: [],
      taskState: 'loading',
      auditState: '',
      rating: 0,
      contractOwner: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      performer: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      auditInitiator: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      auditor: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      participants: [],
      funders: [],
      auditors: [],
      messages: [],
      taskAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      justLoaded: true,
      tokenNames: [],
      tokenValues: [],
      transport: '');

  final emptyTask = Task(
      nanoId: '111',
      createTime: DateTime.now(),
      taskType: 'task[2]',
      title: 'empty',
      description: 'Error: task are empty',
      repository: 'https://github.com/devopsdao/dodao',
      tags: [],
      tagsNFT: [],
      symbols: [],
      amounts: [],
      taskState: 'empty',
      auditState: '',
      rating: 0,
      contractOwner: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      performer: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      auditInitiator: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      auditor: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      participants: [],
      funders: [],
      auditors: [],
      messages: [],
      taskAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      justLoaded: true,
      tokenNames: [],
      tokenValues: [],
      transport: '');

  final loadingAccount = Account(
      nickName: 'Loading...',
      about: 'Error: loading account',
      walletAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      customerTasks: [],
      participantTasks: [],
      auditParticipantTasks: [],
      customerRating: [0],
      performerRating: [0]);

  final emptyAccount = Account(
      nickName: 'Empty',
      about: 'Error: empty account',
      walletAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      customerTasks: [],
      participantTasks: [],
      auditParticipantTasks: [],
      customerRating: [0],
      performerRating: [0]);
}
