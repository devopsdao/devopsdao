
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:webthree/credentials.dart';

import '../../../../blockchain/classes.dart';
import '../../../../blockchain/task_services.dart';
import '../../../wallet/model_view/wallet_model.dart';
import '../../../widgets/tags/wrapped_chip.dart';



class PendingTab extends StatelessWidget {
  const PendingTab({
    super.key,
  });



  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();
    WalletModel walletModel = context.read<WalletModel>();
    late List<TokenItem> tags = [];

    return Container(
      padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0, bottom: 16.0),
      height: 100,
      alignment: Alignment.topLeft,
      child:
      Builder(
          builder: (context) {
            late bool nft;


            // ############### collect and combine Performer Progress task:
            late Map<String, BigInt> combinedPerformerProgress = {};
            late List<String> combinedPerformerProgressNftNames = [];
            late List<BigInt> combinedPerformerProgressNftBalance = [];

            for (var element in tasksServices.tasksPerformerProgress.entries) {
              for (var i = 0; i < element.value.tokenNames.length; i++) {
                combinedPerformerProgressNftNames.addAll(element.value.tokenNames[i].cast<String>());
                combinedPerformerProgressNftBalance.addAll(element.value.tokenAmounts[i].cast<BigInt>());
              }
            }
            for (int i2 = 0; i2 < combinedPerformerProgressNftNames.length; i2++) {
              final BigInt num = combinedPerformerProgressNftBalance[i2];
              if(!combinedPerformerProgress.containsKey(combinedPerformerProgressNftNames[i2])) {
                combinedPerformerProgress[combinedPerformerProgressNftNames[i2]] = num;
              } else {
                combinedPerformerProgress[combinedPerformerProgressNftNames[i2]] = num + combinedPerformerProgress[combinedPerformerProgressNftNames[i2]]!;
              }
            }

            // incoming payment
            combinedPerformerProgress.forEach((key, value) {
              late double myBalance;
              myBalance = value.toDouble();
              late String name = key;
              if (key != tasksServices.taskTokenSymbol) {
                nft = true;
              } else {
                nft = false;
                name = walletModel.getNetworkChainCurrency(walletModel.state.chainId!);

                final ethBalancePrecise = value.toDouble() / pow(10, 18);
                myBalance = (((ethBalancePrecise * 10000).floor()) / 10000);
              }
              tags.add(
                  TokenItem(collection: true, name: name, balance: myBalance, nft: nft, type: 'performerPending')
              );
            });

            // ############### collect and combine Customer Progress task:
            late Map<String, BigInt> combinedCustomerProgress = {};
            late List<String> combinedCustomerProgressNftNames = [];
            late List<BigInt> combinedCustomerProgressNftBalance = [];

            late Map<EthereumAddress, Task> tasksCustomerProgress = {
              ...tasksServices.tasksCustomerProgress,
              ...tasksServices.tasksCustomerSelection
            };

            for (var element in tasksCustomerProgress.entries) {
              for (var i = 0; i < element.value.tokenNames.length; i++) {
                combinedCustomerProgressNftNames.addAll(element.value.tokenNames[i].cast<String>());
                combinedCustomerProgressNftBalance.addAll(element.value.tokenAmounts[i].cast<BigInt>());
              }
            }
            for (int i2 = 0; i2 < combinedCustomerProgressNftNames.length; i2++) {
              final BigInt num = combinedCustomerProgressNftBalance[i2];
              if(!combinedCustomerProgress.containsKey(combinedCustomerProgressNftNames[i2])) {
                combinedCustomerProgress[combinedCustomerProgressNftNames[i2]] = num;
              } else {
                combinedCustomerProgress[combinedCustomerProgressNftNames[i2]] = num + combinedCustomerProgress[combinedCustomerProgressNftNames[i2]]!;
              }
            }

            //outgoing payment
            combinedCustomerProgress.forEach((key, value) {
              late double myBalance;
              myBalance = value.toDouble();
              late String name = key;
              if (key != tasksServices.taskTokenSymbol) {
                nft = true;
              } else {
                nft = false;
                name = walletModel.getNetworkChainCurrency(walletModel.state.chainId!);
                final ethBalancePrecise = value.toDouble() / pow(10, 18);
                myBalance = (((ethBalancePrecise * 10000).floor()) / 10000);
              }
              tags.add(
                  TokenItem(collection: true, name: name, balance: myBalance, nft: nft, type: 'customerPending')
              );
            });

            // ############### collect and combine Completed task:
            late Map<String, BigInt> combinedCompleted = {};
            late List<String> combinedCompletedNftNames = [];
            late List<BigInt> combinedCompletedNftAmounts = [];
            late List<BigInt> combinedCompletedNftBalance = [];

            //
            // for (var element in tasksCustomerProgress.entries) {
            //   for (var i = 0; i < element.value.tokenNames.length; i++) {
            //     combinedCustomerProgressNftNames.addAll(element.value.tokenNames[i].cast<String>());
            //     combinedCustomerProgressNftBalance.addAll(element.value.tokenAmounts[i].cast<BigInt>());
            //   }
            // }
            // for (int i2 = 0; i2 < combinedCustomerProgressNftNames.length; i2++) {
            //   final BigInt num = combinedCustomerProgressNftBalance[i2];
            //   if(!combinedCustomerProgress.containsKey(combinedCustomerProgressNftNames[i2])) {
            //     combinedCustomerProgress[combinedCustomerProgressNftNames[i2]] = num;
            //   } else {
            //     combinedCustomerProgress[combinedCustomerProgressNftNames[i2]] = num + combinedCustomerProgress[combinedCustomerProgressNftNames[i2]]!;
            //   }
            // }

            for (var element in tasksServices.tasksPerformerComplete.entries) {

              for (var i = 0; i < element.value.tokenNames.length; i++) {
                if (element.value.tokenBalances[i] != 0) {
                  combinedCompletedNftNames.addAll(element.value.tokenNames[i].cast<String>());
                  combinedCompletedNftBalance.addAll(element.value.tokenAmounts[i].cast<BigInt>());
                }

              }
            }
            // print(combinedCompletedNftAmounts);
            // print(combinedCompletedNftBalance);
            for (int i2 = 0; i2 < combinedCompletedNftNames.length; i2++) {
              late BigInt num = combinedCompletedNftBalance[i2];
              if (combinedCompletedNftBalance[i2] != 0) {
                if(!combinedCompleted.containsKey(combinedCompletedNftNames[i2])) {
                  combinedCompleted[combinedCompletedNftNames[i2]] = num;
                } else {
                  combinedCompleted[combinedCompletedNftNames[i2]] = num + combinedCompleted[combinedCompletedNftNames[i2]]!;
                }
              }
            }
            // print(combinedCompleted);


            //ready to collect:
            combinedCompleted.forEach((key, value) {
              late double myBalance;
              late String name = key;
              myBalance = value.toDouble();

              if (key != tasksServices.taskTokenSymbol) {
                nft = true;
              } else {
                nft = false;
                name = walletModel.getNetworkChainCurrency(walletModel.state.chainId!);
                final ethBalancePrecise = value.toDouble() / pow(10, 18);
                myBalance = (((ethBalancePrecise * 10000).floor()) / 10000);
              }
              tags.add(
                  TokenItem(collection: true, name: name, balance: myBalance, nft: nft, selected: true, type: 'performerComplete')
              );
            });

            return SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                children: tags.map((e) {


                  return HomeWrappedChip(
                    key: ValueKey(e),
                    item: MapEntry(
                        e.name,
                        NftCollection(
                          selected: e.selected,
                          name: e.name,
                          bunch: {
                            BigInt.from(e.balance):
                            TokenItem(name: e.name, nft: e.nft, inactive: e.inactive, balance: e.balance, collection: true)
                          },
                        )),
                    nft: e.nft,
                    balance: e.balance,
                    completed: e.selected,
                    type: e.type!,
                  );
                }).toList(),
              ),
            );
          }
      ),
    );
  }
}

