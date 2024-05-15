import 'dart:io';
import 'dart:math';

import 'package:chips_choice/chips_choice.dart';
import 'package:dodao/widgets/tags/tags_old.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/utils/my_tools.dart';
import '../../main.dart';
import '../../widgets/tags/search_services.dart';
import '../../config/theme.dart';
import 'package:flutter/material.dart';
import '../../widgets/tags/wrapped_chip.dart';

import '../../widgets/tags/wrapped_mint_chip.dart';
import '../collection_services.dart';
import '../create_or_mint.dart';
import '../widgets/bottom_sheet.dart';

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
  final Duration splitDuration = const Duration(milliseconds: 500);
  final Curve splitCurve = Curves.easeInOutQuart;
  final double buttonWidth = 140;

  String tag = '';
  late PersistentBottomSheetController bottomSheetController;
  List<String> list = [];
  bool chipsLoading = true;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var searchServices = Provider.of<SearchServices>(context, listen: false);
      var tasksServices = Provider.of<TasksServices>(context, listen: false);
      Future.delayed(
        const Duration(milliseconds: 400), () async {
        searchServices.tagSelection(typeSelection: 'mint', tagName: '', unselectAll: true, tagKey: '');
        await tasksServices.collectMyTokens();
          searchServices.refreshLists('mint');
        }
      );
    });
  }

  @override
  void dispose() {
    _searchKeywordController.dispose();
    bottomSheetController.close();
    list = [];
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var searchServices = context.watch<SearchServices>();
    var collectionServices = context.watch<CollectionServices>();
    var interface = context.read<InterfaceServices>();

    void openBottomSheet(val) {
      Future.delayed(const Duration(milliseconds: 100), () async {
        bottomSheetController = showBottomSheet(
          constraints: BoxConstraints(maxWidth: interface.maxStaticGlobalWidth,),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
          context: context,
          builder: (BuildContext context) {
            return MintBottomSheet(collectionName: val);
          },
        );
      });
    }

    return LayoutBuilder(
        builder: (context, constraints) {
          final double statusBarHeight = MediaQuery.of(context).viewPadding.top;
          late double maxHeight = constraints.maxHeight - statusBarHeight - 76;
          var modelTheme = context.read<ModelTheme>();

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 16.0, right: 12.0, left: 12.0),
                height: 70,
                child: TextFormField(
                  maxLength: 50,
                  controller: searchServices.searchKeywordController,
                  onChanged: (searchKeyword) {
                    searchServices.tagsSearchFilter(page: 'mint', enteredKeyword: searchKeyword,);
                  },
                  autofocus: true,
                  obscureText: false,
                  // onTapOutside: (test) {
                  //   FocusScope.of(context).unfocus();
                  //   // interface.taskMessage = messageController!.text;
                  // },
                  onTap: () {
                    bottomSheetController.close();
                    setState(() {
                      tag = '';
                    });
                  },
                  decoration: InputDecoration(
                    // prefixIcon: const Icon(Icons.add, color: Color(0xFF47CBE4),),
                    counterText: "",
                    suffixIcon: searchServices.newTag ? IconButton(
                      onPressed: () async {
                        // NEW TAG
                        tag = searchServices.searchKeywordController.text;
                        openBottomSheet(tag);
                        // searchServices.tagSelection(unselectAll: true, tagName: '', typeSelection: 'mint', tagKey: '');
                        // await searchServices.addNewTag(searchServices.searchKeywordController.text, 'mint');
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
                )
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
                            list = [];
                            for (var v in model.mintPageFilterResults.values) {
                              if (v.name == ' ' || v.name == '') { } else {
                                if (v.name.length >= 50) {
                                  // list.add('${v.name.substring(0, min(v.name.length, 50))} ...');
                                } else {
                                  list.add(v.name);
                                }
                              }
                            }
                            if (list.isNotEmpty) {
                              return SingleChildScrollView(
                                  child: ChipsChoice<String>.single(
                                    wrapped: true,
                                    value: tag,
                                    onChanged: (val) {
                                      setState(() => tag = val);
                                      openBottomSheet(val);
                                    },
                                    choiceItems: C2Choice.listFrom<String, String>(
                                      source: list,
                                      value: (i, v) => v,
                                      label: (i, v) => v,
                                    ),
                                    spacing: 6,
                                    choiceStyle: C2ChipStyle.when(
                                      enabled: modelTheme.isDark ? C2ChipStyle.filled(
                                        color: DodaoTheme.of(context).chipBodyColor,
                                        foregroundColor: DodaoTheme.of(context).chipTextColor,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ) : C2ChipStyle.outlined(
                                        backgroundColor: DodaoTheme.of(context).chipBodyColor,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                        borderWidth: 1,
                                      ),
                                      selected: C2ChipStyle.filled(
                                        color: DodaoTheme.of(context).chipSelectedColor,
                                        foregroundColor: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      pressed: C2ChipStyle.filled(
                                        color: DodaoTheme.of(context).chipSelectedColor,
                                        foregroundColor: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      hovered: C2ChipStyle.filled(
                                        color: DodaoTheme.of(context).chipSelectedColor,
                                        foregroundColor: Colors.black,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                  )
                              );
                            } else {
                              return const Center();
                            }

                          }
                      ),
                    ),
                  ]
              ),
            ],
          );
        }
    );
  }
}



