import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';
import 'package:throttling/throttling.dart';

import '../blockchain/interface.dart';
import '../widgets/payment.dart';
import '../widgets/tags/tag_call_button.dart';
import '../widgets/wallet_action.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:markdown_editable_textinput/format_markdown.dart';
// import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:simple_markdown_editor_plus/simple_markdown_editor_plus.dart';

import '../blockchain/task_services.dart';
import '../task_dialog/widget/dialog_button_widget.dart';
import '../widgets/tags/wrapped_chip.dart';

class CreateJobPage extends StatefulWidget {
  const CreateJobPage({Key? key}) : super(key: key);

  @override
  _CreateJobPageState createState() => _CreateJobPageState();
}

class _CreateJobPageState extends State<CreateJobPage> {
  @override
  void initState() {
    super.initState();
  }
  late String backgroundPicture = "assets/images/niceshape.png";
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(backgroundPicture),
            fit: BoxFit.scaleDown,
            alignment: Alignment.bottomRight
        ),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return StatefulBuilder(builder: (context, setState) {
          final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
          final double screenHeightSizeNoKeyboard = constraints.maxHeight - 70;
          final double screenHeightSize = screenHeightSizeNoKeyboard - keyboardSize;
          return CreateJobWidget(screenHeightSize: screenHeightSizeNoKeyboard);
        });
      }),
    );
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
    final screenHeightSize = widget.screenHeightSize;

    final statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: statusBarHeight,
          ),

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
          SizedBox(
            // *** SingleScrollChild enable here by using screenHeightSize:
            height: screenHeightSize - statusBarHeight,
            // height: 490,
            width: maxDialogWidth,

            child: const NewTaskMainPage(),
          ),
    ]);
  }
}





class NewTaskMainPage extends StatefulWidget {
  const NewTaskMainPage({Key? key,
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
    // final double innerWidth = widget.innerWidth;


    return LayoutBuilder(builder: (ctx, dialogConstraints) {
      final double innerWidth = dialogConstraints.maxWidth - 50;
      final double maxHeight = dialogConstraints.maxHeight;
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
            ),
            child: Column(
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
                            minLines: 1,
                            maxLines: 30,
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
                          maxWidth: maxInternalWidth,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          width: innerWidth,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(borderRadius),
                          ),
                          child:  LayoutBuilder(
                              builder: (context, constraints) {
                                final double width = constraints.maxWidth - 60;
                              return Row(
                                children: <Widget>[
                                  Consumer<InterfaceServices>(
                                      builder: (context, model, child) {
                                        return Container(
                                          width: width,
                                          child: Wrap(
                                              alignment: WrapAlignment.start,
                                              direction: Axis.horizontal,
                                              children: model.createTagsList.map((e) {
                                                return WrappedChip(
                                                    key: ValueKey(e),
                                                    theme: 'white',
                                                    nft: e.nft ?? false,
                                                    name: e.tag!,
                                                    control: true,
                                                    page: 'create'
                                                );
                                              }).toList()),
                                        );
                                      }
                                  ),
                                  const Spacer(),
                                  TagCallButton(page: 'create',),
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
            ),
          ),
        );
      }
    );
  }
}