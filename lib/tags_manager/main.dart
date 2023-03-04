import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/classes.dart';
import '../blockchain/task_services.dart';
import '../task_dialog/beamer.dart';
import '../task_dialog/task_transition_effect.dart';
import '../widgets/badgetab.dart';
import '../widgets/loading.dart';
import '../widgets/tags/search_services.dart';
import '../widgets/tags/tag_open_container.dart';
import '../flutter_flow/theme.dart';
import 'package:flutter/material.dart';
import '../widgets/tags/wrapped_chip.dart';

import 'package:webthree/credentials.dart';

import 'manager_services.dart';
import 'nft_templorary.dart';

class TagManagerPage extends StatefulWidget {
  final EthereumAddress? taskAddress;
  const TagManagerPage({Key? key, this.taskAddress}) : super(key: key);

  @override
  _TagManagerPagetState createState() => _TagManagerPagetState();
}

class _TagManagerPagetState extends State<TagManagerPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (widget.taskAddress != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.taskAddress != null) {
          showDialog(
              context: context,
              builder: (context) => TaskDialogBeamer(
                    taskAddress: widget.taskAddress,
                    fromPage: 'performer',
                  ));
        }
      });
    }
  }

  final _searchKeywordController = TextEditingController();
  @override
  void dispose() {
    _searchKeywordController.dispose();
    super.dispose();
  }

  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    var searchServices = context.read<SearchServices>();

    Map tabs = {"new": 0, "agreed": 1, "progress": 1, "review": 1, "audit": 1, "completed": 2, "canceled": 2};

    if (widget.taskAddress != null) {
      final task = tasksServices.tasks[widget.taskAddress];

      if (task != null) {
        tabIndex = tabs[task.taskState];
      }
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Tags Manager',
                  style: DodaoTheme.of(context).title2.override(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 22,
                      ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFF1E2429),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black, Colors.black],
            stops: [0, 0.5, 1],
            begin: AlignmentDirectional(1, -1),
            end: AlignmentDirectional(-1, 1),
          ),
        ),
        child: SizedBox(
          width: interface.maxStaticGlobalWidth,
          child: DefaultTabController(
            length: 2,
            initialIndex: tabIndex,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  TabBar(
                    labelColor: Colors.white,
                    labelStyle: DodaoTheme.of(context).bodyText1,
                    indicatorColor: const Color(0xFF47CBE4),
                    indicatorWeight: 3,
                    // isScrollable: true,
                    onTap: (index) {
                    },
                    tabs: [
                      Tab(
                        child: BadgeTab(
                          taskCount: tasksServices.tasksPerformerParticipate.length,
                          tabText: 'Mint',
                        ),
                      ),
                      Tab(

                        child: BadgeTab(
                          taskCount: tasksServices.tasksPerformerProgress.length,
                          tabText: 'The treasury',
                        ),
                      ),
                    ],
                  ),
                  const Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        // MintWidget(
                        // ),
                        TreasuryWidget(
                        ),
                        TreasuryWidget(
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

// class ChipNotifierWrapper extends StatefulWidget {
//   final Widget child;
//   ChipNotifierWrapper({Key? key, required this.child}) : super(key: key);
//
//   static ChipNotifierWrapperState of(BuildContext context) {
//     return (context.dependOnInheritedWidgetOfExactType<ChipNotifier>())!.data;
//   }
//
//   @override
//   ChipNotifierWrapperState createState() => ChipNotifierWrapperState();
// }
//
// class ChipNotifierWrapperState extends State<ChipNotifierWrapper> {
//   int counter = 0;
//
//   void incrementCounter() {
//     setState(() {
//       counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ChipNotifier(
//         data: this,
//         counter:counter,
//         child: widget.child
//     );
//   }
// }
//
// class ChipNotifier extends InheritedWidget {
//   ChipNotifier({
//     Key? key,
//     required this.child,
//     required this.data,
//     required this.counter
//   }) : super(key: key, child: child);
//
//   final Widget child;
//   final int counter;
//   final ChipNotifierWrapperState data;
//
//
//   @override
//   bool updateShouldNotify(ChipNotifier oldWidget) {
//     return counter != oldWidget.counter;
//   }
// }

class TreasuryWidget extends StatefulWidget {
  const TreasuryWidget({Key? key}) : super(key: key);

  @override
  _TreasuryWidget createState() => _TreasuryWidget();
}

class _TreasuryWidget extends State<TreasuryWidget> {

  final _searchKeywordController = TextEditingController();
  late Map<String, TagsCompare> tagsCompare = {};

  final Duration splitDuration = const Duration(milliseconds: 600);
  final Curve splitCurve = Curves.easeInOutQuart;

  @override
  void dispose() {
    _searchKeywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();
    // var managerServices = context.read<ManagerServices>();
    var searchServices = context.read<SearchServices>();



    if (_searchKeywordController.text.isEmpty) {
      searchServices.resetNFTFilter(nftTagsMap);
    }
    start();

    return LayoutBuilder(
      builder: (context, constraints) {
        final double statusBarHeight = MediaQuery.of(context).viewPadding.top;
        late double maxHeight = constraints.maxHeight - statusBarHeight - 84;
        // late double firstPartHeight = 0.0;
        // late double secondPartHeight = 0.0;
        // late bool splitScreen = false;
        // if (managerServices.treasuryNftSelected.tag != 'empty') {
        //   splitScreen = true;
        //   firstPartHeight = maxHeight / 2;
        //   secondPartHeight = firstPartHeight;
        // }
        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(2, 6, 2, 2),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 16.0, right: 12.0, left: 12.0),
                  height: 70,
                  child: Consumer<SearchServices>(
                      builder: (context, model, child) {
                        return TextFormField(
                          controller: _searchKeywordController,
                          onChanged: (searchKeyword) {
                            model.tagsNFTFilter(searchKeyword, nftTagsMap);
                          },
                          autofocus: true,
                          obscureText: false,
                          // onTapOutside: (test) {
                          //   FocusScope.of(context).unfocus();
                          //   // interface.taskMessage = messageController!.text;
                          // },

                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.add),
                            // suffixIcon: model.newTag ? IconButton(
                            //   onPressed: () {
                            //     // NEW TAG
                            //     nftTagsMap[_searchKeywordController.text] =
                            //         SimpleTags(tag: _searchKeywordController.text, icon: "", selected: true);
                            //     model.tagsUpdate(nftTagsMap);
                            //   },
                            //   icon: const Icon(Icons.add_box),
                            //   padding: const EdgeInsets.only(right: 12.0),
                            //   highlightColor: Colors.grey,
                            //   hoverColor: Colors.transparent,
                            //   color: Colors.blueAccent,
                            //   splashColor: Colors.black,
                            // ) : null,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: Colors.blueAccent,
                                width: 1.0,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Tag name',
                            labelStyle: const TextStyle(
                                fontSize: 17.0, color: Colors.black54),
                            hintText: '[Enter your tag here..]',
                            hintStyle: const TextStyle(
                                fontSize: 14.0, color: Colors.black54),
                            // focusedBorder: const UnderlineInputBorder(
                            //   borderSide: BorderSide.none,
                            // ),

                          ),
                          style: DodaoTheme.of(context).bodyText1.override(
                            fontFamily: 'Inter',
                          ),
                          minLines: 1,
                          maxLines: 1,
                        );
                      }
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: maxHeight,
                      alignment: Alignment.topLeft,
                      child: Consumer<SearchServices>(
                          builder: (context, model, child) {
                            return Wrap(
                                alignment: WrapAlignment.start,
                                direction: Axis.horizontal,
                                children: model.nftFilterResults.entries.map((e) {

                                  if(!tagsCompare.containsKey(e.key)){
                                    if (e.value.selected) {
                                      tagsCompare[e.key] = TagsCompare(state: 'remain',);
                                    } else {
                                      tagsCompare[e.key] = TagsCompare(state: 'none',);
                                    }
                                  } else if (tagsCompare.containsKey(e.key)) {
                                    if (e.value.selected) {
                                      if (tagsCompare[e.key]!.state == 'start') {
                                        tagsCompare.update(e.key, (val) => val = TagsCompare(state: 'remain',));
                                      }
                                      if (tagsCompare[e.key]!.state == 'none') {
                                        tagsCompare.update(e.key, (val) => val = TagsCompare(state: 'start',));
                                      }
                                      if (tagsCompare[e.key]!.state == 'end') {
                                        tagsCompare.update(e.key, (val) => val = TagsCompare(state: 'start',));
                                      }
                                    } else {
                                      if (tagsCompare[e.key]!.state == 'end') {
                                        tagsCompare.update(e.key, (val) => val = TagsCompare(state: 'none',));
                                      }
                                      if (tagsCompare[e.key]!.state == 'start') {
                                        tagsCompare.update(e.key, (val) => val = TagsCompare(state: 'end',));
                                      }
                                      if (tagsCompare[e.key]!.state == 'remain') {
                                        tagsCompare.update(e.key, (val) => val = TagsCompare(state: 'end',));
                                      }
                                    }


                                    // if (e.value.selected && tagsCompare[e.value.tag]!.state == 'none') {
                                    //   // Start animation on clicked Widget
                                    //   tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'start',));
                                    // } else if (tagsCompare[e.value.tag]!.state == 'none' && !e.value.selected) {
                                    //   // End(exit) animation
                                    //   tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'end',));
                                    // }


                                    // for (var entry in entriesCopy.entries) {
                                    //   print(DateTime.now().difference(entry.value.timestamp).inSeconds);
                                    //   if (DateTime.now().difference(entry.value.timestamp).inSeconds > 1) {
                                    //     tagsCompare.remove(e.value.tag);
                                    //   }
                                    // }
                                  }
                                  // print('state: ${tagsCompare[e.value.tag]!.state} actual: ${e.value.selected} ${e.value.tag}');
                                  return WrappedChip(
                                      key: ValueKey(e),
                                      theme: 'black',
                                      item: SimpleTags(tag: 'bunch', nft: true),
                                      delete: false,
                                      page: 'treasury',
                                      startScale: false,
                                      mint: true,
                                      name: e.key,
                                      selected: e.value.selected,
                                      expandAnimation: tagsCompare[e.key]!.state
                                  );
                                }).toList()
                            );
                          }
                      ),
                    ),
                    Consumer<ManagerServices>(
                      builder: (context, model, child) {
                        late double secondPartHeight = 0.0;
                        late bool splitScreen = false;
                        if (model.treasuryNftSelected.bunch.first.tag != 'empty') {
                          splitScreen = true;
                        }
                        secondPartHeight = maxHeight / 2;

                        return AnimatedContainer(
                          duration: splitDuration,
                          height: splitScreen ? secondPartHeight : 0.0,
                          color: Colors.grey[900],
                          curve: splitCurve,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Material(
                                  type: MaterialType.transparency,
                                  elevation: 6.0,
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0, bottom: 18, left: 8, right: 8),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            InkResponse(
                                              radius: 35,
                                              containedInkWell: false  ,
                                              onTap: () {
                                              },
                                              child: const Icon(
                                                Icons.arrow_back_ios_new,
                                                size: 24,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                              child: Text(
                                                model.treasuryNftSelected.bunch.length.toString(),
                                                style: DodaoTheme.of(context).bodyText1.override(
                                                  fontFamily: 'Inter',
                                                  color: Colors.white
                                                ),
                                              ),
                                            ),
                                            InkResponse(
                                              radius: 35,
                                              containedInkWell: false  ,
                                              onTap: () {
                                              },
                                              child: const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 24,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                          child: Text(
                                            model.treasuryNftSelected.bunch.first.tag,
                                            style: DodaoTheme.of(context).bodyText1.override(
                                                fontFamily: 'Inter',
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        InkResponse(
                                          radius: 35,
                                          containedInkWell: false  ,
                                          onTap: () {
                                            model.clearTreasuryNft();
                                          },
                                          child: const Icon(
                                            Icons.arrow_downward,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    )
                  ]
                ),
              ],
            )
        );
      }
    );
  }
}

// class MintWidget extends StatefulWidget {
//   const MintWidget({Key? key}) : super(key: key);
//
//   @override
//   _MintWidget createState() => _MintWidget();
// }
//
// class _MintWidget extends State<MintWidget> {
//
//   @override
//   Widget build(BuildContext context) {
//     var tasksServices = context.watch<TasksServices>();
//     var interface = context.watch<InterfaceServices>();
//
//     return LayoutBuilder(
//         builder: (context, constraints) {
//           final double statusBarHeight = MediaQuery.of(context).viewPadding.top;
//           late double maxHeight = constraints.maxHeight - statusBarHeight - 84;
//           // late double firstPartHeight = 0.0;
//           // late double secondPartHeight = 0.0;
//           // late bool splitScreen = false;
//           // if (managerServices.treasuryNftSelected.tag != 'empty') {
//           //   splitScreen = true;
//           //   firstPartHeight = maxHeight / 2;
//           //   secondPartHeight = firstPartHeight;
//           // }
//           return Padding(
//               padding: const EdgeInsetsDirectional.fromSTEB(2, 6, 2, 2),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.only(top: 16.0, right: 12.0, left: 12.0),
//                     height: 70,
//                     child: Consumer<SearchServices>(
//                         builder: (context, model, child) {
//                           return TextFormField(
//                             controller: _searchKeywordController,
//                             onChanged: (searchKeyword) {
//                               model.tagsFilter(searchKeyword, nftTagsMap);
//                             },
//                             autofocus: true,
//                             obscureText: false,
//                             // onTapOutside: (test) {
//                             //   FocusScope.of(context).unfocus();
//                             //   // interface.taskMessage = messageController!.text;
//                             // },
//
//                             decoration: InputDecoration(
//                               prefixIcon: const Icon(Icons.add),
//                               suffixIcon: model.newTag ? IconButton(
//                                 onPressed: () {
//                                   // NEW TAG
//                                   nftTagsMap[_searchKeywordController.text] =
//                                       SimpleTags(tag: _searchKeywordController.text, icon: "", selected: true);
//                                   model.tagsUpdate(nftTagsMap);
//                                 },
//                                 icon: const Icon(Icons.add_box),
//                                 padding: const EdgeInsets.only(right: 12.0),
//                                 highlightColor: Colors.grey,
//                                 hoverColor: Colors.transparent,
//                                 color: Colors.blueAccent,
//                                 splashColor: Colors.black,
//                               ) : null,
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15.0),
//                                 borderSide: const BorderSide(
//                                   color: Colors.blueAccent,
//                                   width: 1.0,
//                                 ),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15.0),
//                               ),
//                               floatingLabelBehavior: FloatingLabelBehavior.always,
//                               labelText: 'Tag name',
//                               labelStyle: const TextStyle(
//                                   fontSize: 17.0, color: Colors.black54),
//                               hintText: '[Enter your tag here..]',
//                               hintStyle: const TextStyle(
//                                   fontSize: 14.0, color: Colors.black54),
//                               // focusedBorder: const UnderlineInputBorder(
//                               //   borderSide: BorderSide.none,
//                               // ),
//
//                             ),
//                             style: DodaoTheme.of(context).bodyText1.override(
//                               fontFamily: 'Inter',
//                             ),
//                             minLines: 1,
//                             maxLines: 1,
//                           );
//                         }
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 6,
//                   ),
//                   Stack(
//                       alignment: Alignment.bottomCenter,
//                       children: [
//                         Container(
//                           height: maxHeight,
//                           alignment: Alignment.topLeft,
//                           child: Consumer<SearchServices>(
//                               builder: (context, model, child) {
//                                 return Wrap(
//                                     alignment: WrapAlignment.start,
//                                     direction: Axis.horizontal,
//                                     children: model.tagsFilterResults.entries.map((e) {
//
//                                       if(!tagsCompare.containsKey(e.value.tag)){
//                                         if (e.value.selected) {
//                                           tagsCompare[e.value.tag] = TagsCompare(state: 'remain',);
//                                         } else {
//                                           tagsCompare[e.value.tag] = TagsCompare(state: 'none',);
//                                         }
//                                       } else if (tagsCompare.containsKey(e.value.tag)) {
//                                         if (e.value.selected) {
//                                           if (tagsCompare[e.value.tag]!.state == 'start') {
//                                             tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'remain',));
//                                           }
//                                           if (tagsCompare[e.value.tag]!.state == 'none') {
//                                             tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'start',));
//                                           }
//                                           if (tagsCompare[e.value.tag]!.state == 'end') {
//                                             tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'start',));
//                                           }
//                                         } else {
//                                           if (tagsCompare[e.value.tag]!.state == 'end') {
//                                             tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'none',));
//                                           }
//                                           if (tagsCompare[e.value.tag]!.state == 'start') {
//                                             tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'end',));
//                                           }
//                                           if (tagsCompare[e.value.tag]!.state == 'remain') {
//                                             tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'end',));
//                                           }
//                                         }
//
//
//                                         // if (e.value.selected && tagsCompare[e.value.tag]!.state == 'none') {
//                                         //   // Start animation on clicked Widget
//                                         //   tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'start',));
//                                         // } else if (tagsCompare[e.value.tag]!.state == 'none' && !e.value.selected) {
//                                         //   // End(exit) animation
//                                         //   tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'end',));
//                                         // }
//
//
//                                         // for (var entry in entriesCopy.entries) {
//                                         //   print(DateTime.now().difference(entry.value.timestamp).inSeconds);
//                                         //   if (DateTime.now().difference(entry.value.timestamp).inSeconds > 1) {
//                                         //     tagsCompare.remove(e.value.tag);
//                                         //   }
//                                         // }
//                                       }
//                                       // print('state: ${tagsCompare[e.value.tag]!.state} actual: ${e.value.selected} ${e.value.tag}');
//                                       return WrappedChip(
//                                           key: ValueKey(e),
//                                           theme: 'black',
//                                           item: e.value,
//                                           delete: false,
//                                           page: 'treasury',
//                                           startScale: false,
//                                           mint: true,
//                                           isActive: e.value.selected,
//                                           expandAnimation: tagsCompare[e.value.tag]!.state
//                                       );
//                                     }).toList()
//                                 );
//                               }
//                           ),
//                         ),
//                         Consumer<ManagerServices>(
//                             builder: (context, model, child) {
//                               late double secondPartHeight = 0.0;
//                               late bool splitScreen = false;
//                               if (model.treasuryNftSelected.tag != 'empty') {
//                                 splitScreen = true;
//                               }
//                               secondPartHeight = maxHeight / 2;
//
//                               return AnimatedContainer(
//                                 duration: splitDuration,
//                                 height: splitScreen ? secondPartHeight : 0.0,
//                                 color: Colors.grey[900],
//                                 curve: splitCurve,
//                                 child: SingleChildScrollView(
//                                   child: Column(
//                                     children: [
//                                       Material(
//                                         type: MaterialType.transparency,
//                                         elevation: 6.0,
//                                         color: Colors.transparent,
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(top: 10.0, bottom: 18, left: 8, right: 8),
//                                           child: Row(
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   InkResponse(
//                                                     radius: 35,
//                                                     containedInkWell: false  ,
//                                                     onTap: () {
//                                                     },
//                                                     child: const Icon(
//                                                       Icons.arrow_back_ios_new,
//                                                       size: 24,
//                                                       color: Colors.white,
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(left: 5.0, right: 5.0),
//                                                     child: Text(
//                                                       '4',
//                                                       style: DodaoTheme.of(context).bodyText1.override(
//                                                           fontFamily: 'Inter',
//                                                           color: Colors.white
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   InkResponse(
//                                                     radius: 35,
//                                                     containedInkWell: false  ,
//                                                     onTap: () {
//                                                     },
//                                                     child: const Icon(
//                                                       Icons.arrow_forward_ios,
//                                                       size: 24,
//                                                       color: Colors.white,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               const Spacer(),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(left: 5.0, right: 5.0),
//                                                 child: Text(
//                                                   model.treasuryNftSelected.tag,
//                                                   style: DodaoTheme.of(context).bodyText1.override(
//                                                       fontFamily: 'Inter',
//                                                       color: Colors.white
//                                                   ),
//                                                 ),
//                                               ),
//                                               const Spacer(),
//                                               InkResponse(
//                                                 radius: 35,
//                                                 containedInkWell: false  ,
//                                                 onTap: () {
//                                                   model.clearTreasuryNft();
//                                                 },
//                                                 child: const Icon(
//                                                   Icons.arrow_downward,
//                                                   size: 24,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }
//                         )
//                       ]
//                   ),
//                 ],
//               )
//           );
//         }
//     );
//   }
// }
