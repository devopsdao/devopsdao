import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../custom_widgets/payment.dart';
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

typedef void GetColor(Color? color, String? string);

class CreateJobWidget extends StatefulWidget {
  const CreateJobWidget({Key? key}) : super(key: key);

  @override
  _CreateJobWidgetState createState() => _CreateJobWidgetState();
}

class _CreateJobWidgetState extends State<CreateJobWidget>
    with TickerProviderStateMixin {
  TextEditingController? descriptionController;
  TextEditingController? titleFieldController;
  TextEditingController? valueController;
  // TextEditingController valueController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 1000,
      delay: 1000,
      hideBeforeAnimating: false,
      fadeIn: false, // changed to false(orig from FLOW true)
      initialState: AnimationState(
        opacity: 0,
      ),
      finalState: AnimationState(
        opacity: 1,
      ),
    ),
  };

  @override
  void initState() {
    super.initState();
    startPageLoadAnimations(
      animationsMap.values
          .where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
      this,
    );
    descriptionController = TextEditingController();
    titleFieldController = TextEditingController();
    valueController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    String description = '';
    TextEditingController _controller = TextEditingController();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () async {
            Navigator.pop(context);

            // showDialog(
            //     context: context,
            //     builder: (context) => WalletAction()
            // );
          },
        ),
        title: Text(
          'Create  job',
          style: FlutterFlowTheme.of(context).title2.override(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 22,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFF1E2429),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white, Colors.white],
            stops: [0, 0.5, 1],
            begin: AlignmentDirectional(1, -1),
            end: AlignmentDirectional(-1, 1),
          ),
          // image: DecorationImage(
          //   image: AssetImage("assets/images/background.png"),
          //   // fit: BoxFit.cover,
          //   repeat: ImageRepeat.repeat,
          // ),
        ),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                decoration: const BoxDecoration(
                    // color: Colors.white70,
                    // borderRadius: BorderRadius.circular(8),
                    ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextFormField(
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
                            TextStyle(fontSize: 17.0, color: Colors.black),
                        hintText: '[Enter the Title..]',
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.black),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            lineHeight: 2,
                          ),
                      maxLines: 1,
                    ),
                    // const Spacer(),

                    // MarkdownTextInput(
                    //   (String value) => setState(() => description = value),
                    //   description,
                    //   label: 'Description',
                    //   maxLines: 10,
                    //   actions: MarkdownType.values,
                    //   controller: controller,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10),
                    //   child: MarkdownBody(
                    //     data: description,
                    //     shrinkWrap: true,
                    //   ),
                    // ),
                    // const MarkdownAutoPreview(
                    //   decoration: InputDecoration(
                    //     hintText: 'Markdown Auto Preview',
                    //   ),
                    //   style: TextStyle(color: Colors.black),
                    //   emojiConvert: true,
                    //   cursorColor: Colors.black,
                    //   maxLines: 10,
                    //   // minLines: 1,
                    //   // expands: true,
                    // ),
                    // const SplittedMarkdownFormField(
                    //   markdownSyntax: '## Headline',
                    //   style: TextStyle(color: Colors.black),
                    //   toolbarBackground: Colors.black,
                    //   expandableBackground: Colors.black,
                    //   decoration: InputDecoration(
                    //       hintText: 'Splitted Markdown FormField',
                    //       iconColor: Colors.black),
                    //   cursorColor: Colors.black,
                    //   emojiConvert: true,
                    //   minLines: 5,
                    //   maxLines: 5,
                    // ),
                    // MarkdownFormField(
                    //   controller: _controller,
                    //   enableToolBar: true,
                    //   emojiConvert: true,
                    //   autoCloseAfterSelectEmoji: false,
                    // ),

                    TextFormField(
                      controller: descriptionController,
                      // onChanged: (_) => EasyDebounce.debounce(
                      //   'descriptionController',
                      //   Duration(milliseconds: 2000),
                      //   () => setState(() {}),
                      // ),
                      autofocus: true,
                      obscureText: false,
                      decoration: const InputDecoration(
                        labelText: 'Description:',
                        labelStyle:
                            TextStyle(fontSize: 17.0, color: Colors.black),
                        hintText: '[Job description...]',
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.black),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            lineHeight: 2,
                          ),
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                    ),

                    // TextFormField(
                    //   controller: valueController,
                    //   // onChanged: (_) => EasyDebounce.debounce(
                    //   //   'valueController',
                    //   //   Duration(milliseconds: 2000),
                    //   //       () => setState(() {}),
                    //   // ),
                    //   inputFormatters: [
                    //     LengthLimitingTextInputFormatter(8),
                    //     FilteringTextInputFormatter.allow(RegExp(r'\d*\.?\d*')),
                    //   ],
                    //   autofocus: true,
                    //   obscureText: false,
                    //   decoration: InputDecoration(
                    //     labelText: 'Value',
                    //     labelStyle: TextStyle(fontSize: 17.0, color: Colors.black),
                    //     hintText: '[Please enter the value]',
                    //     hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
                    //     enabledBorder: UnderlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Color(0x00000000),
                    //         width: 1,
                    //       ),
                    //       borderRadius: const BorderRadius.only(
                    //         topLeft: Radius.circular(4.0),
                    //         topRight: Radius.circular(4.0),
                    //       ),
                    //     ),
                    //     focusedBorder: UnderlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Color(0x00000000),
                    //         width: 1,
                    //       ),
                    //       borderRadius: const BorderRadius.only(
                    //         topLeft: Radius.circular(4.0),
                    //         topRight: Radius.circular(4.0),
                    //       ),
                    //     ),
                    //   ),
                    //   style: FlutterFlowTheme.of(context).bodyText1.override(
                    //     fontFamily: 'Poppins',
                    //     color: Colors.black,
                    //   ),
                    //   maxLines: 1,
                    //   keyboardType: TextInputType.number,
                    // ),
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 15),
                    //   child: SliderTheme(
                    //     data: SliderThemeData(
                    //       // thumbColor: Colors.red,
                    //       thumbShape: RoundSliderThumbShape(enabledThumbRadius: 14),
                    //       activeTrackColor: Colors.black,
                    //       inactiveTrackColor: Colors.black,
                    //       trackHeight: 5.0,
                    //     ),
                    //     child: Slider(
                    //       value: _currentPriceValue,
                    //       min: 0,
                    //       max: 0.125,
                    //       divisions: 100,
                    //       label: _currentPriceValue.toString(),
                    //       onChanged: (double value) {
                    //         setState(() {
                    //           _currentPriceValue = value;
                    //           valueController!.text = value.toString();
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),
                    // SelectTokenMenu(),
                    const Payment(
                      purpose: 'create',
                    ),
                    const Spacer(),
                    FFButtonWidget(
                      onPressed: () {
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
                      text: 'Submit',
                      options: FFButtonOptions(
                        width: 130,
                        height: 40,
                        color: FlutterFlowTheme.of(context).maximumBlueGreen,
                        textStyle:
                            FlutterFlowTheme.of(context).subtitle2.override(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ).animated([animationsMap['containerOnPageLoadAnimation']!]),
    );
  }
}
