import 'package:devopsdao/widgets/tags/search_services.dart';
import 'package:flutter/services.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';
import 'package:throttling/throttling.dart';

import '../blockchain/interface.dart';
import '../widgets/my_tools.dart';
import '../widgets/payment.dart';
import '../widgets/tags/tag_open_container.dart';
import '../widgets/wallet_action.dart';
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
            image: DecorationImage(
                image: AssetImage(backgroundPicture),
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomRight
            ),
          ),
          child: SafeArea(
            minimum: EdgeInsets.only(left: safeAreaWidth, right: safeAreaWidth),
            child: CreateJobSkeleton(
                screenHeightSize: screenHeightSize,
                myMaxWidth: myMaxWidth,
            )
          )
      );
    });
  }
}


class CreateJobSkeleton extends StatefulWidget {
  final double screenHeightSize;
  final double myMaxWidth;
  const CreateJobSkeleton({Key? key,
    required this.screenHeightSize,
    required this.myMaxWidth,
  }) : super(key: key);

  @override
  _CreateJobSkeletonState createState() => _CreateJobSkeletonState();
}

class _CreateJobSkeletonState extends State<CreateJobSkeleton> {
  TextEditingController? descriptionController;
  TextEditingController? titleFieldController;
  TextEditingController? valueController;
  TextEditingController? githubLinkController;
  final scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
    titleFieldController = TextEditingController();
    valueController = TextEditingController();
    githubLinkController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var searchServices = context.watch<SearchServices>();
    var interface = context.watch<InterfaceServices>();
    final double maxStaticInternalDialogWidth = interface.maxStaticInternalDialogWidth;

    const Color textColor = Colors.black54;
    final double borderRadius = interface.borderRadius;
    final double myMaxWidth = widget.myMaxWidth;
    final double innerPaddingWidth = myMaxWidth - 50;

    final double screenHeightSize = widget.screenHeightSize;

    return Scaffold(
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
                      elevation: 10,
                      borderRadius: BorderRadius.circular(borderRadius),
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
                              padding: const EdgeInsets.all(6.0),
                              width: innerPaddingWidth,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(borderRadius),
                              ),
                              child: TextFormField(
                                onTap: () {
                                  scrollController.animateTo(
                                    scrollController.position.minScrollExtent,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.fastOutSlowIn,
                                  );
                                },
                                controller: titleFieldController,
                                // onChanged: (_) => EasyDebounce.debounce(
                                //   'titleFieldController',
                                //   Duration(milliseconds: 2000),
                                //   () => setState(() {}),
                                // ),
                                autofocus: true,
                                obscureText: false,

                                decoration: const InputDecoration(
                                  labelText: 'Title:',
                                  labelStyle:
                                  TextStyle(fontSize: 17.0, color: textColor),
                                  hintText: '[Enter the Title..]',
                                  hintStyle:
                                  TextStyle(fontSize: 14.0, color: textColor),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: DodaoTheme.of(context).bodyText1.override(
                                  fontFamily: 'Inter',
                                  color: textColor,
                                  lineHeight: 1,
                                ),
                                maxLines: 1,
                                onChanged:  (text) {

                                  debounceNotifyListener.debounce(() {
                                    tasksServices.myNotifyListeners();
                                  });
                                },
                              ),
                            );
                          }
                        ),
                      )
                  ),
                  Container(
                    padding:  const EdgeInsets.only(top: 14.0),
                    child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: maxStaticInternalDialogWidth,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(6.0),
                            width: innerPaddingWidth,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(borderRadius),
                            ),
                            child: TextFormField(
                              onTap: () {
                                scrollController.animateTo(
                                  scrollController.position.minScrollExtent,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn,
                                );
                              },
                              controller: descriptionController,
                              // onChanged: (_) => EasyDebounce.debounce(
                              //   'descriptionController',
                              //   Duration(milliseconds: 2000),
                              //   () => setState(() {}),
                              // ),
                              autofocus: true,
                              obscureText: false,
                              onTapOutside: (test) {
                                FocusScope.of(context).unfocus();
                              },
                              decoration: const InputDecoration(
                                labelText: 'Description:',
                                labelStyle:
                                TextStyle(fontSize: 17.0, color: textColor),
                                hintText: '[Job description...]',
                                hintStyle:
                                TextStyle(fontSize: 14.0, color: textColor),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: DodaoTheme.of(context).bodyText1.override(
                                fontFamily: 'Inter',
                                color: textColor,
                                lineHeight: 1,
                              ),
                              minLines: 1,
                              maxLines: 10,
                              keyboardType: TextInputType.multiline,
                              onChanged:  (text) {

                                debounceNotifyListener.debounce(() {
                                  tasksServices.myNotifyListeners();
                                });
                              },
                            ),
                          ),
                        )
                    ),
                  ),
                  Container(
                    padding:  const EdgeInsets.only(top: 14.0),
                    child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: maxStaticInternalDialogWidth,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            width: innerPaddingWidth,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(borderRadius),
                            ),
                            child:  LayoutBuilder(
                                builder: (context, constraints) {
                                  final double width = constraints.maxWidth - 66;
                                  return Row(
                                    children: <Widget>[
                                      Consumer<SearchServices>(
                                        builder: (context, model, child) {
                                          if (model.createTagsList.isNotEmpty) {
                                            return SizedBox(
                                              width: width,
                                              child: Wrap(
                                                alignment: WrapAlignment.start,
                                                direction: Axis.horizontal,
                                                children: model.createTagsList.entries.map((e) {
                                                  return WrappedChip(
                                                    key: ValueKey(e.value),
                                                    theme: 'white',
                                                    item: e.value,
                                                    delete: true,
                                                    page: 'create',
                                                    name: e.key,
                                                    selected: e.value.selected,
                                                  );
                                                }).toList()),
                                            );
                                          } else {
                                            return Row(
                                              children: <Widget>[
                                                // Container(
                                                //   padding: const EdgeInsets.all(2.0),
                                                //   child: const Icon(Icons.new_releases,
                                                //       size: 45, color: Colors.lightGreen), //Icon(Icons.forward, size: 13, color: Colors.white),
                                                // ),
                                                RichText(
                                                  text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0), children: const <TextSpan>[
                                                    TextSpan(
                                                      text: 'Add relevant tags and NFT\'s',
                                                      style: TextStyle(
                                                        height: 1,
                                                      )),
                                                  ])),
                                              ],
                                            );
                                          }
                                        }
                                      ),
                                      const Spacer(),
                                      const Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: TagCallButton(page: 'create',),
                                      ),
                                    ],
                                  );
                                }
                            ),
                          ),
                        )
                    ),
                  ),

                  const SizedBox(height: 14),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: maxStaticInternalDialogWidth,
                    ),
                    child: Payment(
                        purpose: 'create', innerPaddingWidth: innerPaddingWidth,
                    ),
                  ),
                  Container(
                    padding:  const EdgeInsets.only(top: 14.0),
                    child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: maxStaticInternalDialogWidth,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            width: innerPaddingWidth,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(borderRadius),
                            ),
                            child:  LayoutBuilder(
                                builder: (context, constraints) {
                                  final double width = constraints.maxWidth - 66;
                                  return Column(
                                    children: <Widget>[

                                      TextFormField(
                                        controller: githubLinkController,
                                        autofocus: true,
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
                                          Future.delayed(
                                            const Duration(milliseconds: 1100),
                                              () {
                                                scrollController.animateTo(
                                                  scrollController.position.maxScrollExtent,
                                                  duration: const Duration(seconds: 1),
                                                  curve: Curves.fastOutSlowIn,
                                                );
                                              });
                                        },

                                        decoration: InputDecoration(
                                          labelText: 'Enter GitHub link here:',
                                          labelStyle:
                                          const TextStyle(fontSize: 17.0, color: textColor),
                                          // hintText: '[Job description...]',
                                          hintStyle:
                                          const TextStyle(fontSize: 14.0, color: textColor),
                                          focusedBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          suffixIcon: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                                                  setState(() {
                                                    githubLinkController!.text = '${clipboardData?.text}';
                                                  });
                                                },
                                                icon: const Icon(Icons.content_paste_outlined),
                                                padding: const EdgeInsets.only(right: 12.0),
                                                highlightColor: Colors.grey,
                                                hoverColor: Colors.transparent,
                                                color: Colors.blueAccent,
                                                splashColor: Colors.black,
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                                                  setState(() {
                                                    githubLinkController!.text = '';
                                                  });
                                                },
                                                icon: const Icon(Icons.close_rounded),
                                                padding: const EdgeInsets.only(right: 12.0),
                                                highlightColor: Colors.grey,
                                                hoverColor: Colors.transparent,
                                                color: Colors.blueAccent,
                                                splashColor: Colors.black,
                                              ),
                                            ],
                                          ),

                                        ),
                                        style: DodaoTheme.of(context).bodyText1.override(
                                          fontFamily: 'Inter',
                                          color: textColor,
                                          lineHeight: 1,
                                        ),
                                        minLines: 1,
                                        maxLines: 1,
                                        keyboardType: TextInputType.multiline,
                                        onChanged:  (text) {

                                          debounceNotifyListener.debounce(() {
                                            tasksServices.myNotifyListeners();

                                          });
                                        },
                                      ),

                                      // if (githubLinkController!.text.isNotEmpty)


                                      ExpandedSection(
                                        expand: githubLinkController!.text.isNotEmpty,
                                        callback: () {
                                          if (githubLinkController!.text.isNotEmpty) {
                                            Future.delayed(
                                              const Duration(milliseconds: 300),
                                                  () {
                                                scrollController.animateTo(
                                                  scrollController.position.maxScrollExtent,
                                                  duration: const Duration(seconds: 1),
                                                  curve: Curves.fastOutSlowIn,
                                                );
                                              });
                                          }
                                        },
                                        child: Container(

                                          width: double.infinity,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                                            // mainAxisSize: MainAxisSize.max,
                                            children:  const [
                                              Padding(
                                                padding: EdgeInsets.only(right: 12.0),
                                                child: Icon(Icons.new_releases,
                                                    size: 35, color: Colors.lightGreen),
                                              ),
                                              Flexible(

                                                // height: 35,
                                                // width: double.infinity,
                                                child: Text('This repository URL will be used for automatic Task acceptance based on accepted merge request.'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                            ),
                          ),
                        )
                    ),
                  ),
                  const SizedBox(
                    height: 65,
                  )
                ],
              ),
            ),
          ),
        ),

        floatingActionButtonAnimator:  NoScalingAnimation(),
        // floatingActionButtonLocation: keyboardSize == 0 ? FloatingActionButtonLocation.centerFloat : FloatingActionButtonLocation.endFloat,
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          // padding: keyboardSize == 0 ? const EdgeInsets.only(left: 40.0, right: 28.0) : const EdgeInsets.only(right: 14.0),
          padding: const EdgeInsets.only(right: 13, left: 46),
          child: TaskDialogFAB(
            inactive: (descriptionController!.text.isEmpty || titleFieldController!.text.isEmpty) ? true : false,
            expand: true,
            buttonName: 'Submit',
            buttonColorRequired: Colors.lightBlue.shade300,
            widthSize: MediaQuery.of(context).viewInsets.bottom == 0 ? 600 : 120, // Keyboard is here?
            // keyboardActive: keyboardSize == 0 ? false : true;
            callback: () {
              final nanoId = customAlphabet(
                '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz-',
                12);
              final List<String> tags = searchServices.createTagsList.entries.map((tags) => tags.value.tag).toList();
              tasksServices.createTaskContract(
                titleFieldController!.text,
                descriptionController!.text,
                // valueController!.text,
                interface.tokensEntered,
                nanoId,
                tags);
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => WalletAction(
                  nanoId: nanoId,
                  taskName: 'createTaskContract',
                )
              );
            },
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
                      text: const TextSpan(
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
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
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
    expandController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200)
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if(widget.expand) {
      expandController.forward();
    }
    else {
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
    return SizeTransition(
        axisAlignment: 1.0,
        sizeFactor: animation,
        child: widget.child
    );
  }
}