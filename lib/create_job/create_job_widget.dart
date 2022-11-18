import 'package:another_flushbar/flushbar.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';
import 'package:throttling/throttling.dart';

import '../blockchain/interface.dart';
import '../custom_widgets/payment.dart';
import '../custom_widgets/task_dialog.dart';
import '../custom_widgets/wallet_action.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:markdown_editable_textinput/format_markdown.dart';
// import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:simple_markdown_editor_plus/simple_markdown_editor_plus.dart';

import '../blockchain/task_services.dart';


class CreateJobDialog extends StatefulWidget {
  const CreateJobDialog({Key? key}) : super(key: key);

  @override
  _CreateJobDialogState createState() => _CreateJobDialogState();
}

class _CreateJobDialogState extends State<CreateJobDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: StatefulBuilder(builder: (context, setState) {
          final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
          final double screenHeightSizeNoKeyboard = constraints.maxHeight - 120;
          final double screenHeightSize = screenHeightSizeNoKeyboard - keyboardSize;
          return WillPopScope(
            child:  Dialog(
              insetPadding: const EdgeInsets.all(20),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: CreateJobWidget(screenHeightSize: screenHeightSize)
            ), onWillPop: () async => false,);
        }),
      );
    });
  }
}





class CreateJobWidget extends StatefulWidget {
  final double screenHeightSize;
  const CreateJobWidget({Key? key,
    required this.screenHeightSize,
  }) : super(key: key);
  @override
  _CreateJobWidgetState createState() => _CreateJobWidgetState();
}

class _CreateJobWidgetState extends State<CreateJobWidget> {


  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    final double maxDialogWidth = interface.maxDialogWidth;
    late String backgroundPicture = "assets/images/niceshape.png";
    final screenHeightSize = widget.screenHeightSize;

    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
      Container(
        padding: const EdgeInsets.all(20),
        width: maxDialogWidth,
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
                        maxLines: 1,
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
      ),
      Container(
        // *** SingleScrollChild enable here by using screenHeightSize:
        height: screenHeightSize,
        // height: 490,
        width: maxDialogWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          image: DecorationImage(
            image: AssetImage(backgroundPicture),
            fit: BoxFit.cover,
          ),
        ),
        child: const NewTaskPages(),
      ),
    ]);
  }
}





class NewTaskPages extends StatefulWidget {
  const NewTaskPages({Key? key,
  }) : super(key: key);
  @override
  _NewTaskPagesState createState() => _NewTaskPagesState();
}

class _NewTaskPagesState extends State<NewTaskPages> {

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (ctx, dialogConstraints) {
      double innerWidth = dialogConstraints.maxWidth - 50;
      return PageView(
          scrollDirection: Axis.horizontal,
          // controller: interface.pageViewNewTaskController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (number) {
          },
          children: <Widget>[
            NewTaskMainPage(
                innerWidth: innerWidth)
          ]
      );
    });
  }
}




class NewTaskMainPage extends StatefulWidget {
  final double innerWidth;
  const NewTaskMainPage({Key? key,
    required this.innerWidth,
  }) : super(key: key);

  @override
  _NewTaskMainPageState createState() => _NewTaskMainPageState();
}

class _NewTaskMainPageState extends State<NewTaskMainPage> {
  TextEditingController? descriptionController;
  TextEditingController? titleFieldController;
  TextEditingController? valueController;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
    titleFieldController = TextEditingController();
    valueController = TextEditingController();
  }

  @override
  void dispose() {
    // Don't forget to dispose all of your controllers!
    descriptionController!.dispose();
    titleFieldController!.dispose();
    valueController!.dispose();
    super.dispose();
  }

  late Debouncing debounceNotifyListener = Debouncing(duration: const Duration(milliseconds: 200));

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    final double maxInternalWidth = interface.maxInternalDialogWidth;

    const Color textColor = Colors.black54;
    final double borderRadius = interface.borderRadius;
    final double innerWidth = widget.innerWidth;

    return Column(
      children: [
        Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(borderRadius),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: maxInternalWidth,
              ),
              child: Container(
                  padding: const EdgeInsets.all(6.0),
                  width: innerWidth,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(borderRadius),
                  ),
                  child: TextFormField(
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
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                      fontFamily: 'Poppins',
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
                  maxWidth: maxInternalWidth,
                ),
                child: Container(
                  padding: const EdgeInsets.all(6.0),
                  width: innerWidth,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(borderRadius),
                  ),
                  child: TextFormField(
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
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                      fontFamily: 'Poppins',
                      color: textColor,
                      lineHeight: 1,
                    ),
                    maxLines: 3,
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
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxInternalWidth,
          ),
          child: Payment(
              purpose: 'create', innerWidth: innerWidth,
              borderRadius: borderRadius
          ),
        ),
        const Spacer(),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxInternalWidth,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 16.0),
            width: innerWidth + 8,
            child: Row(
              children: [
                TaskDialogButton(
                  inactive: (descriptionController!.text.isEmpty || titleFieldController!.text.isEmpty) ? true : false,
                  buttonName: 'Submit',
                  buttonColorRequired: Colors.lightBlue.shade600,
                  callback: () {
                    final nanoId = customAlphabet(
                        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz-',
                        12);
                    tasksServices.createTaskContract(
                        titleFieldController!.text,
                        descriptionController!.text,
                        // valueController!.text,
                        interface.tokensEntered,
                        nanoId);
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) => WalletAction(
                          nanoId: nanoId,
                          taskName: 'createTaskContract',
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}