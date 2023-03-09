import 'dart:io';

import 'package:devopsdao/widgets/tags/tags_old.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../widgets/tags/search_services.dart';
import '../../flutter_flow/theme.dart';
import 'package:flutter/material.dart';
import '../../widgets/tags/wrapped_chip.dart';

import '../manager_services.dart';
import '../nft_templorary.dart';

class MintWidget extends StatefulWidget {
  const MintWidget({Key? key}) : super(key: key);

  @override
  _MintWidget createState() => _MintWidget();
}

class _MintWidget extends State<MintWidget> {
  final _searchKeywordController = TextEditingController();
  late Map<String, TagsCompare> tagsCompare = {};
  final Duration splitDuration = const Duration(milliseconds: 600);
  final Curve splitCurve = Curves.easeInOutQuart;
  final double buttonWidth = 180;

  XFile? image;

  final ImagePicker picker = ImagePicker();


  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   var searchServices = Provider.of<SearchServices>(context, listen: false);
    //   searchServices.tagSelection(typeSelection: 'mint', tagName: '', unselectAll: true);
    // });
  }
  @override
  void dispose() {
    _searchKeywordController.dispose();
    super.dispose();
  }


  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }


  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }



  @override
  Widget build(BuildContext context) {
    var searchServices = context.read<SearchServices>();
    var managerServices = context.read<ManagerServices>();
    // searchServices.resetTagsFilter(simpleTagsMap);

    final Widget nftCreate = Consumer<ManagerServices>(
        builder: (context, model, child) {
          late double secondPartHeight = 0.0;
          late bool splitScreen = false;
          final String collectionName = model.mintNftTagSelected.tag;
          if (model.mintNftTagSelected.tag != 'empty') {
            splitScreen = true;
          }
          secondPartHeight = 290;

          return AnimatedContainer(
            duration: splitDuration,
            height: splitScreen ? secondPartHeight : 0.0,
            color: Colors.grey[900],
            curve: splitCurve,
            child: SingleChildScrollView(
              child: Column(
                children: [

                  // Top:
                  Material(
                    type: MaterialType.transparency,
                    elevation: 6.0,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 18, left: 8, right: 8),
                      child: Row(
                        children: [
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Text(
                              collectionName,
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
                              model.clearSelectedInManager();
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
                  ),

                  //Body:
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [
                        Container(
                          height: 160,
                          // width: 160,
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(4.0),

                          decoration: BoxDecoration(
                            border: const GradientBoxBorder(
                              gradient: LinearGradient(colors: [Color(
                                  0xFFD0D0D0), Color(0xFF6E6E6E)]),
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: image != null
                              ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                //to show image, you type like this.
                                File(image!.path),
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                              ),
                            ),
                          )
                              :  ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),

                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 150,
                              filterQuality: FilterQuality.medium,
                              isAntiAlias: true,
                            ),
                          ),
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Create:
                            Row(
                              children: [
                                // Text(
                                //   'Create collection: ',
                                //   style: DodaoTheme.of(context).bodyText1.override(
                                //       fontFamily: 'Inter',
                                //       color: Colors.white
                                //   ),
                                // ),
                                // const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Material(
                                    elevation: 8,
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.lightBlue.shade600,
                                    child: InkWell(
                                      onTap: () {
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                        width: buttonWidth,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Create collection',
                                          style: DodaoTheme.of(context).bodyText1.override(
                                              fontFamily: 'Inter',
                                              color: Colors.white,
                                            fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            //Upload:
                            Row(
                              children: [
                                // Text(
                                //   'Upload/Generate picture: ',
                                //   style: DodaoTheme.of(context).bodyText1.override(
                                //       fontFamily: 'Inter',
                                //       color: Colors.white
                                //   ),
                                // ),
                                // const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Material(
                                    elevation: 8,
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.lightBlue.shade600,
                                    child: InkWell(
                                      onTap: () {
                                        myAlert();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                        width: buttonWidth,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Upload picture',
                                          style: DodaoTheme.of(context).bodyText1.override(
                                              fontFamily: 'Inter',
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            //Mint nft:
                            Row(
                              children: [
                                // Text(
                                //   'Mint NFT: ',
                                //   style: DodaoTheme.of(context).bodyText1.override(
                                //       fontFamily: 'Inter',
                                //       color: Colors.white
                                //   ),
                                // ),
                                // const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Material(
                                    elevation: 8,
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.lightBlue.shade600,
                                    child: InkWell(
                                      onTap: () {
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                        width: buttonWidth,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Mint',
                                          style: DodaoTheme.of(context).bodyText1.override(
                                              fontFamily: 'Inter',
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            //Add features:
                            Row(
                              children: [
                                // Text(
                                //   'Add features: ',
                                //   style: DodaoTheme.of(context).bodyText1.override(
                                //       fontFamily: 'Inter',
                                //       color: Colors.white
                                //   ),
                                // ),
                                // const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Material(
                                    elevation: 8,
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.lightBlue.shade600,
                                    child: InkWell(
                                      onTap: () {
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                        width: buttonWidth,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Add features',
                                          style: DodaoTheme.of(context).bodyText1.override(
                                              fontFamily: 'Inter',
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );

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
                              model.tagsSearchFilter(searchKeyword, simpleTagsMap);
                            },
                            autofocus: true,
                            obscureText: false,
                            // onTapOutside: (test) {
                            //   FocusScope.of(context).unfocus();
                            //   // interface.taskMessage = messageController!.text;
                            // },

                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.add, color: Color(0xFF47CBE4),),
                              suffixIcon: model.newTag ? IconButton(
                                onPressed: () {
                                  // NEW TAG
                                  simpleTagsMap[_searchKeywordController.text] =
                                      SimpleTags(tag: _searchKeywordController.text, icon: "", selected: true);
                                  searchServices.tagSelection( unselectAll: true, tagName: '', typeSelection: 'mint');
                                  model.tagsAddAndUpdate(simpleTagsMap);
                                  managerServices.updateMintNft(searchServices.tagsFilterResults[_searchKeywordController.text]!);
                                },
                                icon: const Icon(Icons.add_box),
                                padding: const EdgeInsets.only(right: 12.0),
                                highlightColor: Colors.grey,
                                hoverColor: Colors.transparent,
                                color: const Color(0xFF47CBE4),
                                splashColor: Colors.white,
                              ) : null,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFF47CBE4),
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFF47CBE4),
                                  width: 2.0,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'Tag name',
                              labelStyle:  TextStyle(
                                  fontSize: 17.0, color: Colors.grey[300]),
                              hintText: '[Find a tag or create a new one..]',
                              hintStyle:  TextStyle(
                                  fontSize: 14.0, color: Colors.grey[300]),
                              // focusedBorder: const UnderlineInputBorder(
                              //   borderSide: BorderSide.none,
                              // ),

                            ),
                            style: DodaoTheme.of(context).bodyText1.override(
                              fontFamily: 'Inter',
                              color: Colors.grey[300]
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
                                    children: model.tagsFilterResults.entries.map((e) {

                                      if(!tagsCompare.containsKey(e.value.tag)){
                                        if (e.value.selected) {
                                          tagsCompare[e.value.tag] = TagsCompare(state: 'remain',);
                                        } else {
                                          tagsCompare[e.value.tag] = TagsCompare(state: 'none',);
                                        }
                                      } else if (tagsCompare.containsKey(e.value.tag)) {
                                        if (e.value.selected) {
                                          if (tagsCompare[e.value.tag]!.state == 'start') {
                                            tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'remain',));
                                          }
                                          if (tagsCompare[e.value.tag]!.state == 'none') {
                                            tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'start',));
                                          }
                                          if (tagsCompare[e.value.tag]!.state == 'end') {
                                            tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'start',));
                                          }
                                        } else {
                                          if (tagsCompare[e.value.tag]!.state == 'end') {
                                            tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'none',));
                                          }
                                          if (tagsCompare[e.value.tag]!.state == 'start') {
                                            tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'end',));
                                          }
                                          if (tagsCompare[e.value.tag]!.state == 'remain') {
                                            tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'end',));
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
                                        item: e.value,
                                        delete: false,
                                        page: 'mint',
                                        startScale: false,
                                        name: e.key,
                                        mint: true,
                                        expandAnimation: tagsCompare[e.value.tag]!.state,
                                        selected: e.value.selected,
                                      );
                                    }).toList()
                                );
                              }
                          ),
                        ),
                        nftCreate
                      ]
                  ),
                ],
              )
          );
        }
    );
  }
}
