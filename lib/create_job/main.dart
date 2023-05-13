import 'dart:math';

import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:dodao/widgets/tags/search_services.dart';
import 'package:flutter/services.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';
import 'package:throttling/throttling.dart';
import 'package:webthree/credentials.dart';

import '../blockchain/classes.dart';
import '../blockchain/interface.dart';
import '../widgets/my_tools.dart';
import '../widgets/payment.dart';
import '../widgets/tags/tag_open_container.dart';
import '../widgets/wallet_action_dialog.dart';
import '../config/theme.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:markdown_editable_textinput/format_markdown.dart';
// import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:simple_markdown_editor_plus/simple_markdown_editor_plus.dart';

import '../blockchain/task_services.dart';
import '../task_dialog/widget/dialog_button_widget.dart';
import '../widgets/tags/wrapped_chip.dart';

// Name of Widget > skeleton > Header > Pages

class CreateJob extends StatefulWidget {
  const CreateJob({
    Key? key,
  }) : super(key: key);

  @override
  _CreateJobState createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJob> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var searchServices = Provider.of<SearchServices>(context, listen: false);
      searchServices.removeAllTagsOnPages(page: 'create');
      // searchServices.refreshLists('selection');
      // searchServices.tagsSearchFilter('', simpleTagsMap);
    });
  }

  late String backgroundPicture = "assets/images/niceshape.png";
  // late double actualFieldWidth = 300;
  late double buttonPaddingLeft = 76.0;
  late double buttonPaddingRight = 43.0;
  late double safeAreaWidth = 0;

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();

    final double maxStaticInternalDialogWidth = interface.maxStaticInternalDialogWidth;
    final double maxStaticDialogWidth = interface.maxStaticDialogWidth;
    late String backgroundPicture = "assets/images/niceshape.png";

    return LayoutBuilder(builder: (ctx, constraints) {
      final double myMaxWidth = constraints.maxWidth;
      if (myMaxWidth >= maxStaticDialogWidth) {
        // actualFieldWidth = maxStaticInternalDialogWidth;
        safeAreaWidth = (myMaxWidth - maxStaticDialogWidth) / 2;
      }

      final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
      final double screenHeightSizeNoKeyboard = constraints.maxHeight;
      final double screenHeightSize = screenHeightSizeNoKeyboard - keyboardSize;
      // print(keyboardSize);
      return Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(backgroundPicture), fit: BoxFit.scaleDown, alignment: Alignment.bottomRight),
          ),
          child: SafeArea(
              minimum: EdgeInsets.only(left: safeAreaWidth, right: safeAreaWidth),
              child: CreateJobSkeleton(
                screenHeightSize: screenHeightSize,
                myMaxWidth: myMaxWidth,
              )));
    });
  }
}

class CreateJobSkeleton extends StatefulWidget {
  final double screenHeightSize;
  final double myMaxWidth;
  const CreateJobSkeleton({
    Key? key,
    required this.screenHeightSize,
    required this.myMaxWidth,
  }) : super(key: key);

  @override
  _CreateJobSkeletonState createState() => _CreateJobSkeletonState();
}

class _CreateJobSkeletonState extends State<CreateJobSkeleton> with TickerProviderStateMixin {
  late AnimationController animationController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 200),
    reverseDuration: Duration(milliseconds: 200),
  );

  TextEditingController? titleFieldController;
  TextEditingController? descriptionController;
  TextEditingController? valueController;
  TextEditingController? githubLinkController;
  final scrollController = ScrollController();
  late bool isTokenApproved = false;
  late bool nftDetected = false;
  late bool tokenDetected = false;
  late bool nftApproved = false;
  late bool tokenApproved = false;

  late bool expandOnceWitnetInfo = true;
  late bool expandOnceWitnetLink = true;
  late bool validUri = true;
  late bool validGithubUri = true;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
    titleFieldController = TextEditingController();
    valueController = TextEditingController();
    githubLinkController = TextEditingController();
    githubLinkController!.addListener(_checkUri);


    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var tasksServices = context.read<TasksServices>();
      List<EthereumAddress> addrList = [tasksServices.contractAddress];
      var response = await tasksServices.isTokenApproved(addrList, [[0]]);
      isTokenApproved = response[tasksServices.contractAddress]!;
      tasksServices.myNotifyListeners();
      print('isTokenApproved $response' );
    });

  }

  void _checkUri() {
    final Uri parsedUri = Uri.parse(githubLinkController!.text);
    validUri = parsedUri.isAbsolute;

    if (parsedUri.host == 'github.com' && parsedUri.pathSegments.length == 2) {
      validGithubUri = true;
    } else {
      validGithubUri = false;
    }
  }

  @override
  void dispose() {
    descriptionController!.dispose();
    titleFieldController!.dispose();
    valueController!.dispose();
    githubLinkController!.dispose();
    scrollController.dispose();
    super.dispose();
  }

  late Debouncing debounceNotifyListener = Debouncing(duration: const Duration(milliseconds: 200));
  late bool witnetSection = false;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var searchServices = context.watch<SearchServices>();
    var interface = context.watch<InterfaceServices>();
    final double maxStaticInternalDialogWidth = interface.maxStaticInternalDialogWidth;

    const Color textColor = Colors.black54;
    final double myMaxWidth = widget.myMaxWidth;
    final double innerPaddingWidth = myMaxWidth - 50;

    final double screenHeightSize = widget.screenHeightSize;

    final BoxDecoration materialMainBoxDecoration = BoxDecoration(
      borderRadius: DodaoTheme.of(context).borderRadius,
      border: DodaoTheme.of(context).borderGradient,
    );



    if (githubLinkController!.text.isNotEmpty) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
    interface.mainDialogContext = context;


    return Scaffold(
      resizeToAvoidBottomInset: false, backgroundColor: DodaoTheme.of(context).taskBackgroundColor,
      // resizeToAvoidBottomInset: false,
      body: Container(
        height: screenHeightSize,
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenHeightSize,
            // minHeight: maxHeight
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              // mainAxisSize: MainAxisSize.max,
              children: [
                const CreateJobHeader(),
                Material(
                    elevation: DodaoTheme.of(context).elevation,
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: maxStaticInternalDialogWidth,
                      ),
                      child: LayoutBuilder(builder: (ctx, constraints) {
                        // actualFieldWidth = constraints.maxWidth;
                        // if (myMaxWidth <= maxStaticDialogWidth) {
                        //   // buttonPaddingLeft = (myMaxWidth - actualFieldWidth) / 2 + 76;
                        //   // buttonPaddingRight = (myMaxWidth - actualFieldWidth) / 2 - 10;
                        // }

                        return Container(
                          padding: DodaoTheme.of(context).inputEdge,
                          width: innerPaddingWidth,
                          decoration: materialMainBoxDecoration,
                          child: TextFormField(
                            onTap: () {
                              // scrollController.animateTo(
                              //   scrollController.position.minScrollExtent,
                              //   duration: const Duration(milliseconds: 500),
                              //   curve: Curves.fastOutSlowIn,
                              // );
                              Future.delayed(const Duration(milliseconds: 400), () {
                                scrollController.animateTo(
                                  scrollController.position.minScrollExtent,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn,
                                );
                              });
                            },
                            controller: titleFieldController,
                            // onChanged: (_) => EasyDebounce.debounce(
                            //   'titleFieldController',
                            //   Duration(milliseconds: 2000),
                            //   () => setState(() {}),
                            // ),
                            autofocus: true,
                            obscureText: false,

                            decoration: InputDecoration(
                              labelText: 'Title:',
                              labelStyle: Theme.of(context).textTheme.bodyMedium,
                              hintText: '[Enter the Title..]',
                              hintStyle: Theme.of(context).textTheme.bodyMedium?.apply(heightFactor: 1.4),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            onChanged: (text) {
                              debounceNotifyListener.debounce(() {
                                tasksServices.myNotifyListeners();
                              });
                            },
                          ),
                        );
                      }),
                    )),
                Container(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Material(
                      elevation: DodaoTheme.of(context).elevation,
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxStaticInternalDialogWidth,
                        ),
                        child: Container(
                          padding: DodaoTheme.of(context).inputEdge,
                          width: innerPaddingWidth,
                          decoration: materialMainBoxDecoration,
                          child: TextFormField(
                            onTap: () {
                              scrollController.animateTo(
                                scrollController.position.minScrollExtent,
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastOutSlowIn,
                              );
                            },
                            controller: descriptionController,
                            // onChanged: (_) => EasyDebounce.debounce(
                            //   'descriptionController',
                            //   Duration(milliseconds: 2000),
                            //   () => setState(() {}),
                            // ),
                            autofocus: false,
                            obscureText: false,
                            onTapOutside: (test) {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: InputDecoration(
                              labelText: 'Description:',
                              labelStyle: Theme.of(context).textTheme.bodyMedium,
                              hintText: '[Job description...]',
                              hintStyle: Theme.of(context).textTheme.bodyMedium?.apply(heightFactor: 1.4),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                            minLines: 1,
                            maxLines: 10,
                            keyboardType: TextInputType.multiline,
                            onChanged: (text) {
                              debounceNotifyListener.debounce(() {
                                tasksServices.myNotifyListeners();
                              });
                            },
                          ),
                        ),
                      )),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Material(
                      elevation: DodaoTheme.of(context).elevation,
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxStaticInternalDialogWidth,
                        ),
                        child: Container(
                          padding: DodaoTheme.of(context).inputEdge,
                          width: innerPaddingWidth,
                          decoration: materialMainBoxDecoration,
                          child: LayoutBuilder(builder: (context, constraints) {
                            final double width = constraints.maxWidth - 68;
                            return Row(
                              children: <Widget>[
                                Consumer<SearchServices>(builder: (context, model, child) {
                                  if (model.createTagsList.isNotEmpty) {
                                    return SizedBox(
                                      width: width,
                                      child: Wrap(
                                          alignment: WrapAlignment.start,
                                          direction: Axis.horizontal,
                                          children: model.createTagsList.entries.map((e) {
                                            return WrappedChip(
                                              key: ValueKey(e.value),
                                              item: MapEntry(
                                                  e.key,
                                                  NftCollection(
                                                    selected: false,
                                                    name: e.value.name,
                                                    bunch: e.value.bunch,
                                                  )),
                                              page: 'create',
                                              selected: e.value.selected,
                                              wrapperRole: WrapperRole.removeNew,
                                            );
                                          }).toList()),
                                    );
                                  } else {
                                    return RichText(
                                        text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: const <TextSpan>[
                                      TextSpan(
                                          text: 'Add relevant tags and NFT\'s',
                                          style: TextStyle(
                                            height: 1,
                                          )),
                                    ]));
                                  }
                                }),
                                const Spacer(),
                                const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: TagCallButton(
                                    page: 'create',
                                    tabIndex: 0,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      )),
                ),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxStaticInternalDialogWidth,
                  ),
                  child: Payment(
                    purpose: 'create',
                    innerPaddingWidth: innerPaddingWidth,
                  ),
                ),

                /// Witnet Container **********
                Container(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Material(
                      elevation: DodaoTheme.of(context).elevation,
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxStaticInternalDialogWidth,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          width: innerPaddingWidth,
                          decoration: materialMainBoxDecoration,
                          child: LayoutBuilder(builder: (context, constraints) {
                            final double width = constraints.maxWidth - 66;
                            return Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: githubLinkController,
                                  autofocus: false,
                                  obscureText: false,
                                  onTapOutside: (test) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  onTap: () {
                                    // FocusScope.of(context).;
                                    // scrollController.animateTo(
                                    //   scrollController.position.maxScrollExtent,
                                    //   duration: const Duration(seconds: 1),
                                    //   curve: Curves.fastOutSlowIn,
                                    // );
                                    Future.delayed(const Duration(milliseconds: 400), () {
                                      scrollController.animateTo(
                                        scrollController.position.maxScrollExtent,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.fastOutSlowIn,
                                      );
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: validGithubUri ? validUri ? 'Enter GitHub link here:' : 'Invalid link entered' : 'Please enter github link',
                                    labelStyle: Theme.of(context).textTheme.bodyMedium?.apply(
                                        color: (validUri && validGithubUri) ? DodaoTheme.of(context).primaryText : Colors.redAccent
                                    ),
                                    hintText: '',
                                    hintStyle: Theme.of(context).textTheme.bodyMedium?.apply(
                                       heightFactor: 1.2,
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          if (witnetSection) {
                                            witnetSection = false;
                                          } else {
                                            witnetSection = true;
                                          }
                                        });
                                      },
                                      icon: DodaoTheme.of(context).witnetLogo,
                                      highlightColor: Colors.grey,
                                      hoverColor: Colors.transparent,
                                      color: Colors.blueAccent,
                                      splashColor: Colors.black,
                                    ),
                                    suffixIcon: Builder(builder: (context) {
                                      const Duration duration = Duration(milliseconds: 750);
                                      return AnimatedIconButton(
                                        animationController: animationController,
                                        size: 24,
                                        onPressed: () {},
                                        duration: duration,
                                        initialIcon: githubLinkController!.text.isNotEmpty ? 1 : 0,
                                        icons: <AnimatedIconItem>[
                                          AnimatedIconItem(
                                            icon: Icon(
                                              Icons.content_paste_outlined,
                                              color: DodaoTheme.of(context).secondaryText,
                                              // size: 30,
                                            ),
                                            onPressed: () async {

                                              final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                                              setState(() {
                                                githubLinkController!.text = '${clipboardData?.text}';
                                              });

                                            },
                                            // backgroundColor: Colors.white,
                                          ),
                                          AnimatedIconItem(
                                            icon: Icon(
                                              Icons.close_rounded,
                                              color: DodaoTheme.of(context).secondaryText,
                                            ),
                                            onPressed: () async {
                                              // final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                                              setState(() {
                                                githubLinkController!.text = '';
                                              });
                                            },
                                            // backgroundColor: Colors.white,
                                          ),
                                        ],
                                      );
                                    }),

                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                                    //   mainAxisSize: MainAxisSize.min,
                                    //   children: [
                                    //     IconButton(
                                    //       onPressed: () async {
                                    //         final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                                    //         setState(() {
                                    //           githubLinkController!.text = '${clipboardData?.text}';
                                    //         });
                                    //       },
                                    //       icon: const Icon(Icons.content_paste_outlined),
                                    //       padding: const EdgeInsets.only(right: 12.0),
                                    //       highlightColor: Colors.grey,
                                    //       hoverColor: Colors.transparent,
                                    //       color: Colors.blueAccent,
                                    //       splashColor: Colors.black,
                                    //     ),
                                    //     IconButton(
                                    //       onPressed: () async {
                                    //         final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                                    //         setState(() {
                                    //           githubLinkController!.text = '';
                                    //         });
                                    //       },
                                    //       icon: const Icon(Icons.close_rounded),
                                    //       padding: const EdgeInsets.only(right: 12.0),
                                    //       highlightColor: Colors.grey,
                                    //       hoverColor: Colors.transparent,
                                    //       color: Colors.blueAccent,
                                    //       splashColor: Colors.black,
                                    //     ),
                                    //   ],
                                    // ),
                                  ),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  minLines: 1,
                                  maxLines: 1,
                                  keyboardType: TextInputType.multiline,
                                  onChanged: (text) {
                                    debounceNotifyListener.debounce(() {
                                      tasksServices.myNotifyListeners();
                                    });
                                  },
                                ),

                                // if (githubLinkController!.text.isNotEmpty)

                                ExpandedSection(
                                  expand: witnetSection,
                                  callback: () {
                                    if (witnetSection && expandOnceWitnetInfo) {
                                      Future.delayed(const Duration(milliseconds: 300), () {
                                        scrollController.animateTo(
                                          scrollController.position.maxScrollExtent,
                                          duration: const Duration(milliseconds: 400),
                                          curve: Curves.fastOutSlowIn,
                                        );
                                      });
                                      expandOnceWitnetInfo = false;
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                                      // mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 12.0),
                                          child: Image.asset(
                                            'assets/images/wn_dodao_mascot.png',
                                            height: 90,
                                            filterQuality: FilterQuality.medium,
                                          ),
                                        ),
                                        const Flexible(
                                          // height: 35,
                                          // width: double.infinity,
                                          child: Text('Dodao uses Witnet oracle to connect to Github API and get PR merge status'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                ExpandedSection(
                                  expand: githubLinkController!.text.isNotEmpty,
                                  callback: () {
                                    if (githubLinkController!.text.isNotEmpty && expandOnceWitnetLink) {
                                      Future.delayed(const Duration(milliseconds: 300), () {
                                        scrollController.animateTo(
                                          scrollController.position.maxScrollExtent,
                                          duration: const Duration(milliseconds: 400),
                                          curve: Curves.fastOutSlowIn,
                                        );
                                      });
                                      expandOnceWitnetLink = false;
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                                      // mainAxisSize: MainAxisSize.max,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(right: 12.0),
                                          child: Icon(Icons.new_releases, size: 35, color: Colors.lightGreen),
                                        ),
                                        Flexible(
                                          // height: 35,
                                          // width: double.infinity,
                                          child:
                                              Text('This repository URL will be used for automatic Task acceptance based on accepted merge request.'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 65,
                )
              ],
            ),
          ),
        ),
      ),

      floatingActionButtonAnimator: NoScalingAnimation(),
      // floatingActionButtonLocation: keyboardSize == 0 ? FloatingActionButtonLocation.centerFloat : FloatingActionButtonLocation.endFloat,
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        // padding: keyboardSize == 0 ? const EdgeInsets.only(left: 40.0, right: 28.0) : const EdgeInsets.only(right: 14.0),
        padding: const EdgeInsets.only(right: 13, left: 46),
        child: Builder(
          builder: (context) {
            final nanoId = customAlphabet('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz-', 12);
            final double buttonWidth = MediaQuery.of(context).viewInsets.bottom == 0 ? 600 : 120; // Keyboard is here?



            for (var e in searchServices.createTagsList.entries) {
              if (e.value.bunch.values.first.nft) {
                nftDetected = true;
              }
            }

            //
            //
            // if (interface.tokenSelected == 'USDC' && !tokenApproved) {
            //   print('fired USDC');
            //   interface.tokenSelected == '';
            //
            // }


            var submitButton = TaskDialogFAB(
              inactive: (descriptionController!.text.isEmpty || titleFieldController!.text.isEmpty) ? true : false,
              expand: true,
              buttonName: 'Submit',
              buttonColorRequired: Colors.lightBlue.shade300,
              widthSize: buttonWidth,
              // keyboardActive: keyboardSize == 0 ? false : true;
              callback: () {
                final List<String> tags = [];
                final List<BigInt> tokenId = [];
                final List<BigInt> amounts = [];
                //final List<String> tokenNames = [];

                late List<EthereumAddress> tokenContracts = [];
                late List<List<BigInt>> tokenIds = [];
                late List<List<BigInt>> tokenAmounts = [];

                late bool nftPresent = false;

                for (var e in searchServices.createTagsList.entries) {
                  for (var e2 in e.value.bunch.entries) {
                    if (e2.value.nft) {
                      if (e2.value.selected) {
                        tokenId.add(e2.key);
                        amounts.add(BigInt.from(1));
                        nftPresent = true;
                        //  tokenNames.add(e2.value.name);
                      }
                    } else {
                      tags.add(e.value.name);
                    }
                  }
                }

                if (nftPresent) {
                  tokenIds = [tokenId];
                  tokenAmounts = [amounts];
                  tokenContracts.add(tasksServices.contractAddress);
                  nftPresent = false;
                }

                if (interface.tokensEntered != 0) {
                  // add taskTokenSymbol if there any tokens(expl: ETH) added to contract
                  tokenIds.insert(0, [BigInt.from(0)]);
                  tokenAmounts.insert(0, [BigInt.from(interface.tokensEntered * pow(10, 18))]);
                  tokenContracts.insert(0, EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'));
                  // tokenIds = [tokenId];
                  // tokenAmounts = [amounts];
                }

                final Uri parsedUri = Uri.parse(githubLinkController!.text);
                print('parsedUri.path: ${parsedUri.path}');

                tasksServices.createTaskContract(titleFieldController!.text, descriptionController!.text, parsedUri.path,
                    interface.tokensEntered, nanoId, tags, tokenIds, tokenAmounts, tokenContracts);
                // Navigator.pop(context);
                interface.createJobPageContext = context;
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => WalletActionDialog(
                      nanoId: nanoId,
                      taskName: 'createTaskContract',
                    ));
              }
            );

            var approveButtonERC1155 = TaskDialogFAB(
              inactive: false,
              expand: true,
              buttonName: 'Approve(Nft)',
              buttonColorRequired: Colors.lightBlue.shade300,
              widthSize: buttonWidth,
              // keyboardActive: keyboardSize == 0 ? false : true;
              callback: () async {
                // tasksServices.approveSpend(tasksServices.contractAddress, tasksServices.publicAddress!, BigInt.from(1), nanoId, true, 'approveSpend');
                final List<EthereumAddress> tokenContracts = [];
                tokenContracts.add(tasksServices.contractAddress);
                tasksServices.myNotifyListeners();
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => const WalletActionDialog(
                      nanoId: 'setApprovalForAll',
                      taskName: 'setApprovalForAll',
                    ));
                await tasksServices.setApprovalForAll(tokenContracts, [[0]]);
                var response = await tasksServices.isTokenApproved(tokenContracts, [[0]]);
                setState(() {
                  isTokenApproved = response[tasksServices.contractAddress]!;
                });
                tasksServices.myNotifyListeners();
                print('isTokenApproved $response' );
                // List<EthereumAddress> addrList = [tasksServices.contractAddress];
                // var response = await tasksServices.isTokenApproved(addrList);
                // nftApproved = response[tasksServices.contractAddress]!;

              },
            );

            var approveButtonERC20 = TaskDialogFAB(
              inactive: isTokenApproved ? true : false,
              expand: true,
              buttonName: 'Approve(Token)',
              buttonColorRequired: Colors.lightBlue.shade300,
              widthSize: buttonWidth,
              callback: () async {
                // tasksServices.approveSpend(tasksServices.contractAddress, tasksServices.publicAddress!, BigInt.from(1), nanoId, true, 'approveSpend');
                tokenApproved = true;
                tasksServices.myNotifyListeners();
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => WalletActionDialog(
                      nanoId: nanoId,
                      taskName: 'createTaskContract',
                    ));

                // List<EthereumAddress> addrList = [tasksServices.contractAddress];
                // var response = await tasksServices.isTokenApproved(addrList);
                // tokenApproved = response[tasksServices.contractAddress]!;

              },
            );

            var errorButton = TaskDialogFAB(
              inactive: false,
              expand: true,
              buttonName: 'Error',
              buttonColorRequired: Colors.lightBlue.shade300,
              widthSize: MediaQuery.of(context).viewInsets.bottom == 0 ? 600 : 120, // Keyboard is here?
              callback: () async {},
            );


            if (nftDetected && !isTokenApproved) {
              // if (nftDetected && !nftApproved) {
              //   print('nftDetected fired');
              //   nftDetected = false;
              // }
              return approveButtonERC1155;
            }

            // else if (!nftApproved && interface.tokenSelected == 'USDC') {
            //   if (tokenApproved && interface.tokenSelected != 'USDC') {
            //     print('fired USDC');
            //     interface.tokenSelected == '';
            //   }
            //   return approveButtonERC20;
            // }

            else if ((nftApproved && tokenApproved) || (!nftDetected || interface.tokenSelected == '')) {
              interface.tokenSelected == '';
              nftDetected = false;
              return submitButton;
            } else {
              return errorButton;
            }
            //
            // if (!tokenApproved && nftDetected) {
            //   if (nftDetected && !nftApproved) {
            //     print('nftDetected fired');
            //
            //     nftDetected = false;
            //   }
            //   return approveButtonERC1155;
            // } else if (!nftApproved && interface.tokenSelected == 'USDC') {
            //   if (tokenApproved && interface.tokenSelected != 'USDC') {
            //     print('fired USDC');
            //     interface.tokenSelected == '';
            //   }
            //   return approveButtonERC20;
            // }
            //
            // else if ((nftApproved && tokenApproved) || (!nftDetected || interface.tokenSelected == '')) {
            //   interface.tokenSelected == '';
            //   nftDetected = false;
            //   return submitButton;
            // } else {
            //   return errorButton;
            // }

          }
        ),
      ),
    );
  }
}

class CreateJobHeader extends StatefulWidget {
  const CreateJobHeader({
    Key? key,
  }) : super(key: key);

  @override
  _CreateJobHeaderState createState() => _CreateJobHeaderState();
}

class _CreateJobHeaderState extends State<CreateJobHeader> {
  @override
  void initState() {
    super.initState();
  }

  late String backgroundPicture = "assets/images/niceshape.png";
  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    return Container(
      padding: const EdgeInsets.only(bottom: 18),
      width: interface.maxStaticDialogWidth,
      child: Row(
        children: [
          const SizedBox(
            width: 30,
          ),
          const Spacer(),
          Expanded(
              flex: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RichText(
                      // softWrap: false,
                      // overflow: TextOverflow.ellipsis,
                      // maxLines: 1,
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          // const WidgetSpan(
                          //     child: Padding(
                          //       padding:
                          //       EdgeInsets.only(right: 5.0),
                          //       child: Icon(
                          //         Icons.copy,
                          //         size: 20,
                          //         color: Colors.black26,
                          //       ),
                          //     )),
                          TextSpan(
                            text: 'Add new Task',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
          const Spacer(),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              // RouteInformation routeInfo = RouteInformation(
              //     location: '/${widget.fromPage}');
              // Beamer.of(context)
              //     .updateRouteInformation(routeInfo);
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(0.0),
              height: 30,
              width: 30,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(6),
              // ),
              child: Row(
                children: const <Widget>[
                  Expanded(
                    child: Icon(
                      Icons.close,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandedSection extends StatefulWidget {
  final VoidCallback callback;

  final Widget child;
  final bool expand;
  const ExpandedSection({super.key, this.expand = false, required this.child, required this.callback});

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection> with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  void prepareAnimations() {
    expandController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.callback();
    return SizeTransition(axisAlignment: 1.0, sizeFactor: animation, child: widget.child);
  }
}
