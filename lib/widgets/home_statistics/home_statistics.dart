// import 'dart:ffi';

// import 'package:flutter/cupertino.dart';
import 'dart:math';

import 'package:dodao/widgets/tags/wrapped_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../wallet/wallet_service.dart';


class HomeStatistics extends StatefulWidget {
  const HomeStatistics({Key? key}) : super(key: key);

  @override
  State<HomeStatistics> createState() => HomeStatisticsState();
}

class HomeStatisticsState extends State<HomeStatistics>  with SingleTickerProviderStateMixin{

  final colors = [const Color(0xFFF62BAD), const Color(0xFFF75D21)];
  late Color indicatorColor = colors[0];
  late TabController tabBarController;
  final double tabPadding = 12;
  late List<TokenItem> tags = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // var searchServices = Provider.of<SearchServices>(context, listen: false);
      // var tasksServices = Provider.of<TasksServices>(context, listen: false);
      // searchServices.tagSelection(typeSelection: 'treasury', tagName: '', unselectAll: true, tagKey: '');

      // final Map<String, dynamic> emptyCollectionMap = simpleTagsMap.map((key, value) => MapEntry(key, 0));
      // tasksServices.collectMyTokens();
      // await tasksServices.collectMyTokens();
      // Future.delayed(
      //     const Duration(milliseconds: 100), () {
      //   searchServices.refreshLists('treasury');
      //   searchServices.tagSelection(typeSelection: 'mint', tagName: '', unselectAll: true, tagKey: '');
      // }
      // );
    });
    tabBarController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          indicatorColor = colors[tabBarController.index];
        });
      });
    indicatorColor = colors[0];
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch <TasksServices>();
    WalletProvider walletProvider = context.watch<WalletProvider>();
    // var searchServices = context.read<SearchServices>();
    // var notify = context.watch<MyNotifyListener>();

    if (tasksServices.walletConnected
        || walletProvider.wcCurrentState == WCStatus.error
    ) {
      tags = [];
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          if(tasksServices.walletConnected && tasksServices.publicAddress != null)
          SizedBox(
            height: 30,
            child: TabBar(
              controller: tabBarController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: indicatorColor,
              ),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    // Use the default focused overlay color
                    return states.contains(MaterialState.focused) ? null : Colors.transparent;
                  }
              ),
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              // indicatorColor: DodaoTheme.of(context).tabIndicator,
              indicatorWeight: 1,
              // isScrollable: true,
              onTap: (index) {
                // AppBarWithSearchSwitch.of(appbarServices.searchBarContext)?.stopSearch();
              },
              tabs: [
                Tab(
                  // icon: const FaIcon(
                  //   FontAwesomeIcons.smileBeam,
                  // ),
                  child: Padding(
                    padding: EdgeInsets.only(left: tabPadding, right: tabPadding),
                    child: const Text('In your wallet'),
                  ),
                ),
                Tab(
                  // icon: const Icon(
                  //   Icons.card_travel_outlined,
                  // ),
                  child: Padding(
                    padding: EdgeInsets.only(left: tabPadding, right: tabPadding),
                    child: const Text('Pending'),
                  ),
                ),
              ],
            ),
          ),
          if(tasksServices.walletConnected && tasksServices.publicAddress != null)
          SizedBox(
            height: 150,
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabBarController,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 4.0, right: 8.0, left: 8.0, bottom: 4.0),
                  height: 100,
                  alignment: Alignment.topLeft,
                  child: FutureBuilder(
                    future: tasksServices.publicAddress != null ? tasksServices.getAccountBalances(tasksServices.publicAddress!) : null,
                    initialData: tasksServices.initialBalances,
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.error != null) {
                        print('FutureBuilder error in HomeStatistics:');
                        print(snapshot.error);
                      }

                      if (tasksServices.initialBalances.isNotEmpty) {
                        final List<TokenItem> tags = [];
                        late bool nft = false;

                        if (snapshot.data != null) {
                          for (var element in snapshot.data.entries) {
                            if (element.key == tasksServices.tokenContractKeyName ) {
                              nft = true;
                            }


                            element.value.forEach((k,v) {
                              final double myBalance;
                              if (nft) {
                                myBalance = v.toDouble();
                              } else {
                                final ethBalancePrecise = v.toDouble() / pow(10, 18);
                                myBalance = (((ethBalancePrecise * 10000).floor()) / 10000).toDouble();
                              }
                              tags.add(
                                  TokenItem(collection: true, name: k.toString(), balance: myBalance, nft: nft)
                              );
                            });
                          }
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 16.0, left: 4, right: 4, bottom: 16),
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            direction: Axis.horizontal,
                            children: tags.map((e) {
                              return HomeWrappedChip(
                                key: ValueKey(e),
                                item: MapEntry(
                                    e.name,
                                    NftCollection(
                                      selected: false,
                                      name: e.name,
                                      bunch: {
                                        BigInt.from(e.balance):
                                        TokenItem(name: e.name, nft: e.nft, inactive: e.inactive, balance: e.balance, collection: true, type: 'myNft')
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
                      } else {
                        return Shimmer.fromColors(
                            baseColor: DodaoTheme.of(context).shimmerBaseColor,
                            highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0, left: 4, right: 4, bottom: 16),
                              child: LayoutBuilder(builder: (context, constraints) {
                                List<TokenItem> tags = [
                                  TokenItem(collection: true, name: 'empty', id: BigInt.from(0)),
                                  TokenItem(collection: true, name: 'empty123', id: BigInt.from(0)),
                                  TokenItem(collection: true, name: 'empt', id: BigInt.from(0)),
                                ];
                                return Wrap(
                                  alignment: WrapAlignment.start,
                                  direction: Axis.horizontal,
                                  children: tags.map((e) {
                                    return WrappedChip(
                                      key: ValueKey(e),
                                      item: MapEntry(
                                          e.name,
                                          NftCollection(
                                            selected: false,
                                            name: e.name,
                                            bunch: {
                                              BigInt.from(0):
                                              TokenItem(name: e.name, nft: e.nft, inactive: e.inactive, balance: e.balance, collection: true)
                                            },
                                          )),
                                      page: 'tasks',
                                      selected: e.selected,
                                      wrapperRole: WrapperRole.selectNew,
                                    );
                                  }).toList()
                                );
                              }),
                            )
                        );
                      }
                    },
                  )

                ),
                Container(
                    padding: const EdgeInsets.only(top: 4.0, right: 8.0, left: 8.0, bottom: 4.0),
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
                      // baikova ana vlad
                      combinedPerformerProgress.forEach((key, value) {
                        late double myBalance;
                        myBalance = value.toDouble();
                        if (key != tasksServices.taskTokenSymbol) {
                          nft = true;
                        } else {
                          nft = false;
                          final ethBalancePrecise = value.toDouble() / pow(10, 18);
                          myBalance = (((ethBalancePrecise * 10000).floor()) / 10000);
                        }
                        tags.add(
                            TokenItem(collection: true, name: key, balance: myBalance, nft: nft, type: 'performerPending')
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

                      combinedCustomerProgress.forEach((key, value) {
                        late double myBalance;
                        myBalance = value.toDouble();
                        if (key != tasksServices.taskTokenSymbol) {
                          nft = true;
                        } else {
                          nft = false;
                          final ethBalancePrecise = value.toDouble() / pow(10, 18);
                          myBalance = (((ethBalancePrecise * 10000).floor()) / 10000);
                        }
                        tags.add(
                            TokenItem(collection: true, name: key, balance: myBalance, nft: nft, type: 'customerPending')
                        );
                      });

                      // ############### collect and combine Completed task:
                      late Map<String, double> combinedCompleted = {};
                      late List<String> combinedCompletedNftNames = [];
                      late List<BigInt> combinedCompletedNftAmounts = [];
                      late List<double> combinedCompletedNftBalance = [];

                      for (var element in tasksServices.tasksPerformerComplete.entries) {
                        for (var i = 0; i < element.value.tokenNames.length; i++) {
                          combinedCompletedNftNames.addAll(element.value.tokenNames[i].cast<String>());
                          combinedCompletedNftAmounts.addAll(element.value.tokenAmounts[i].cast<BigInt>());

                        }
                        combinedCompletedNftBalance.addAll(element.value.tokenBalances.cast<double>());
                      }
                      // print(combinedCompletedNftAmounts);
                      // print(combinedCompletedNftBalance);
                      for (int i2 = 0; i2 < combinedCompletedNftNames.length; i2++) {
                        late double num = 1;
                        if (combinedCompletedNftBalance[i2] != 0) {
                          if(!combinedCompleted.containsKey(combinedCompletedNftNames[i2])) {
                            combinedCompleted[combinedCompletedNftNames[i2]] = num;
                          } else {
                            combinedCompleted[combinedCompletedNftNames[i2]] = num + combinedCompleted[combinedCompletedNftNames[i2]]!;
                          }
                        }
                      }
                      // print(combinedCompleted);

                      combinedCompleted.forEach((key, value) {
                        late double myBalance;
                        myBalance = value.toDouble();
                        if (key != tasksServices.taskTokenSymbol) {
                          nft = true;
                        } else {
                          nft = false;
                          // final ethBalancePrecise = value.toDouble() / pow(10, 18);
                          // myBalance = (((ethBalancePrecise * 10000).floor()) / 10000);
                        }
                        tags.add(
                            TokenItem(collection: true, name: key, balance: myBalance, nft: nft, selected: true, type: 'performerComplete')
                        );
                      });

                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 4, right: 4, bottom: 16),
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
                ),
              ],
            ),
          ),
            
            if(!tasksServices.walletConnected)
              const SizedBox(
                height: 200,
                child: Center(
                  child: Text('Please connect your wallet')
                ),
              )
        ],
      ),
    );
  }
}

