// import 'dart:ffi';

// import 'package:flutter/cupertino.dart';
import 'package:dodao/widgets/tags/search_services.dart';
import 'package:dodao/widgets/tags/wrapped_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/classes.dart';
import '../blockchain/task_services.dart';
import 'badgetab.dart';


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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var searchServices = Provider.of<SearchServices>(context, listen: false);
      var tasksServices = Provider.of<TasksServices>(context, listen: false);
      // searchServices.tagSelection(typeSelection: 'treasury', tagName: '', unselectAll: true, tagKey: '');

      // final Map<String, dynamic> emptyCollectionMap = simpleTagsMap.map((key, value) => MapEntry(key, 0));
      // tasksServices.collectMyTokens();
      await tasksServices.collectMyTokens();
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
    var tasksServices = context.read<TasksServices>();
    var searchServices = context.read<SearchServices>();

    return Column(
      children: [
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
        SizedBox(
          height: 150,
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabBarController,
            children: [
              // if (tasksServices.publicAddress != null)
              Container(
                padding: const EdgeInsets.only(top: 4.0, right: 8.0, left: 8.0, bottom: 4.0),
                height: 100,
                alignment: Alignment.topLeft,
                child: FutureBuilder(
                  future: tasksServices.publicAddress != null ? tasksServices.getTokenNames(tasksServices.publicAddress!) : null,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {

                      final List<TokenItem> tags = snapshot.data.map((name) => TokenItem(collection: true, name: name)).toList();
                      for (int i = 0; i < snapshot.data.tokenNames.length; i++) {
                        for (var e in snapshot.data.tokenNames[i]) {
                          if (snapshot.data.tokenNames[i].first == 'ETH') {
                            tags.add(TokenItem(collection: true, nft: false, balance: snapshot.data.tokenBalances[i], name: e.toString()));
                          } else {
                            if (snapshot.data.tokenBalances[i] == 0) {
                              tags.add(TokenItem(collection: true, nft: true, inactive: true, name: e.toString()));
                            } else {
                              tags.add(TokenItem(collection: true, nft: true, inactive: false, name: e.toString()));
                            }
                          }
                        }
                      }
                      return Column(
                        children: [
                          Wrap(
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
                                // startScale: false,
                                selected: e.selected,
                                wrapperRole: WrapperRole.selectNew,
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(child: Text('Loading')),
                      );
                    }
                  },
                )
                // Builder(
                //   builder: (context) {
                //     // final List<TokenItem> tags = tasksServices.resultNftsMap.map((name) => TokenItem(collection: true, name: name)).toList();
                //     // for (int i = 0; i < tasksServices.resultNftsMap.length; i++) {
                //     //   for (var e in tasksServices.resultNftsMap[i]) {
                //     //     if (task.tokenNames[i].first == 'ETH') {
                //     //       tags.add(TokenItem(collection: true, nft: false, balance: task.tokenBalances[i], name: e.toString()));
                //     //     } else {
                //     //       if (task.tokenBalances[i] == 0) {
                //     //         tags.add(TokenItem(collection: true, nft: true, inactive: true, name: e.toString()));
                //     //       } else {
                //     //         tags.add(TokenItem(collection: true, nft: true, inactive: false, name: e.toString()));
                //     //       }
                //     //     }
                //     //   }
                //     // }
                //     tasksServices.getTokenNames(tasksServices.publicAddress!);
                //
                //   }
                // ),
              ),
              Container(

              ),
            ],
          ),
        ),
      ],
    );
  }
}
