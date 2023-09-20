import 'dart:io';

import 'package:dodao/widgets/tags/tags_old.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../widgets/tags/search_services.dart';
import '../../config/theme.dart';
import 'package:flutter/material.dart';
import '../../widgets/tags/wrapped_chip.dart';

import '../collection_services.dart';
import '../create_or_mint.dart';

enum Status {
  done,
  open,
  await
}

class MintWidget extends StatefulWidget {
  const MintWidget({Key? key}) : super(key: key);

  @override
  _MintWidget createState() => _MintWidget();
}

class _MintWidget extends State<MintWidget> {
  final _searchKeywordController = TextEditingController();
  late Map<String, TagsCompare> tagsCompare = {};
  final Duration splitDuration = const Duration(milliseconds: 300);
  final Curve splitCurve = Curves.easeInOutQuart;
  final double buttonWidth = 140;




  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var searchServices = Provider.of<SearchServices>(context, listen: false);
      var tasksServices = Provider.of<TasksServices>(context, listen: false);
      searchServices.tagSelection(typeSelection: 'mint', tagName: '', unselectAll: true, tagKey: '');

      await tasksServices.collectMyTokens();
      Future.delayed(
        const Duration(milliseconds: 100), () {
          searchServices.refreshLists('mint');
        }
      );

      // final Map<String, dynamic> emptyCollectionMap = simpleTagsMap.map((key, value) => MapEntry(key, 0));
      // final List collectionsList = await tasksServices.getCreatedTokenNames();
    });
  }

  @override
  void dispose() {
    _searchKeywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var searchServices = context.watch<SearchServices>();
    var collectionServices = context.watch<CollectionServices>();
    // var tasksServices = context.read<TasksServices>();

    return LayoutBuilder(
        builder: (context, constraints) {
          final double statusBarHeight = MediaQuery.of(context).viewPadding.top;
          late double maxHeight = constraints.maxHeight - statusBarHeight - 76;
          // late double firstPartHeight = 0.0;
          // late double secondPartHeight = 0.0;
          // late bool splitScreen = false;
          // if (collectionServices.treasuryNftSelected.name != 'empty') {
          //   splitScreen = true;
          //   firstPartHeight = maxHeight / 2;
          //   secondPartHeight = firstPartHeight;
          // }
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 16.0, right: 12.0, left: 12.0),
                height: 70,
                child: Consumer<SearchServices>(
                    builder: (context, model, child) {
                      return TextFormField(
                        controller: searchServices.searchKeywordController,
                        onChanged: (searchKeyword) {
                          model.tagsSearchFilter(page: 'mint', enteredKeyword: searchKeyword,);
                        },
                        autofocus: true,
                        obscureText: false,
                        // onTapOutside: (test) {
                        //   FocusScope.of(context).unfocus();
                        //   // interface.taskMessage = messageController!.text;
                        // },

                        decoration: InputDecoration(
                          // prefixIcon: const Icon(Icons.add, color: Color(0xFF47CBE4),),
                          suffixIcon: model.newTag ? IconButton(
                            onPressed: () async {
                              // NEW TAG
                              searchServices.tagSelection(unselectAll: true, tagName: '', typeSelection: 'mint', tagKey: '');
                              await model.addNewTag(searchServices.searchKeywordController.text, 'mint');
                              collectionServices.updateMintNft(searchServices.mintPageFilterResults[searchServices.searchKeywordController.text]!.bunch.values.first);
                              FocusScope.of(context).unfocus();
                            },
                            icon: const Icon(Icons.add_box,color: Colors.deepOrangeAccent,),
                            padding: const EdgeInsets.only(right: 12.0),
                            highlightColor: Colors.grey,
                            hoverColor: Colors.transparent,
                            color: DodaoTheme.of(context).tabIndicator,
                            splashColor: Colors.white,
                          ) : null,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide: BorderSide(
                              color: DodaoTheme.of(context).tabIndicator,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide: BorderSide(
                              color: DodaoTheme.of(context).tabIndicator,
                              width: 2.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Tag name',
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          hintText: '[Find a tag or create a new one..]',
                          hintStyle:  Theme.of(context).textTheme.bodyMedium,
                          // hintStyle:  Theme.of(context).textTheme.bodyMedium?.apply(heightFactor: 1.4),
                          // focusedBorder: const UnderlineInputBorder(
                          //   borderSide: BorderSide.none,
                          // ),

                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
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
                      padding: const EdgeInsets.only(top: 4.0, right: 8.0, left: 8.0, bottom: 4.0),
                      height: maxHeight,
                      alignment: Alignment.topLeft,
                      child: Consumer<SearchServices>(
                          builder: (context, model, child) {
                            return Wrap(
                                alignment: WrapAlignment.start,
                                direction: Axis.horizontal,
                                children: model.mintPageFilterResults.entries.map((e) {

                                  if(!tagsCompare.containsKey(e.value.name)){
                                    if (e.value.selected) {
                                      tagsCompare[e.value.name] = TagsCompare(state: 'remain',);
                                    } else {
                                      tagsCompare[e.value.name] = TagsCompare(state: 'none',);
                                    }
                                  } else if (tagsCompare.containsKey(e.value.name)) {
                                    if (e.value.selected) {
                                      if (tagsCompare[e.value.name]!.state == 'start') {
                                        tagsCompare.update(e.value.name, (val) => val = TagsCompare(state: 'remain',));
                                      }
                                      if (tagsCompare[e.value.name]!.state == 'none') {
                                        tagsCompare.update(e.value.name, (val) => val = TagsCompare(state: 'start',));
                                      }
                                      if (tagsCompare[e.value.name]!.state == 'end') {
                                        tagsCompare.update(e.value.name, (val) => val = TagsCompare(state: 'start',));
                                      }
                                    } else {
                                      if (tagsCompare[e.value.name]!.state == 'end') {
                                        tagsCompare.update(e.value.name, (val) => val = TagsCompare(state: 'none',));
                                      }
                                      if (tagsCompare[e.value.name]!.state == 'start') {
                                        tagsCompare.update(e.value.name, (val) => val = TagsCompare(state: 'end',));
                                      }
                                      if (tagsCompare[e.value.name]!.state == 'remain') {
                                        tagsCompare.update(e.value.name, (val) => val = TagsCompare(state: 'end',));
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
                                    item: e,
                                    page: 'mint',
                                    startScale: false,
                                    animationCicle: tagsCompare[e.value.name]!.state,
                                    selected: e.value.selected,
                                    wrapperRole: WrapperRole.mint,
                                  );
                                }).toList()
                            );
                          }
                      ),
                    ),
                    Consumer<CollectionServices>(
                        builder: (context, model, child) {
                        late double secondPartHeight = 0.0;
                        late bool splitScreen = false;

                        if (model.mintNftTagSelected.name != 'empty') {
                          splitScreen = true;
                        }
                        secondPartHeight = 300;

                        return AnimatedContainer(
                            duration: splitDuration,
                            height: splitScreen ? secondPartHeight : 0.0,
                            color: DodaoTheme.of(context).nftInfoBackgroundColor,
                            curve: splitCurve,
                            child: CreateOrMint(item: model.mintNftTagSelected, page: 'mint')
                        );
                      }
                    )
                  ]
              ),
            ],
          );
        }
    );
  }
}


// class MintButton extends StatelessWidget {
//   final String name;
//   final String state;
//   const MintButton({
//     Key? key,
//     required this.name,
//     required this.state,
//   }) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     // var tasksServices = context.read<TasksServices>();
//
//     if (state == 'await') {
//
//     } else if (state == 'open') {
//
//     } else if (state == 'done') {
//
//     }
//
//     return Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//             minimumSize: Size(155, 40),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//
//           // put the width and height you want
//         ),
//         onPressed: () {  },
//         child: Text(
//           name,
//           style: DodaoTheme.of(context).bodyText1.override(
//               fontFamily: 'Inter',
//               color: Colors.white,
//               fontWeight: FontWeight.w400
//           ),
//         ),
//       ),
//     );
//   }
// }