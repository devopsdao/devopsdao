import 'package:provider/provider.dart';

import '../create_job/create_job_widget.dart';
import '../custom_widgets/loading.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

import 'package:devopsdao/blockchain/task_services.dart';

import '../wallet/main.dart';

class HomePageWidget extends StatefulWidget {
  // final String displayUri;
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
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
    'columnOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 100,
      hideBeforeAnimating: false,
      fadeIn: true,
      initialState: AnimationState(
        opacity: 0,
      ),
      finalState: AnimationState(
        opacity: 1,
      ),
    ),
    'imageOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 600,
      delay: 1100,
      hideBeforeAnimating: false,
      fadeIn: true,
      initialState: AnimationState(
        scale: 0.4,
        opacity: 0,
      ),
      finalState: AnimationState(
        scale: 1,
        opacity: 1,
      ),
    ),
    'textOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 600,
      delay: 1100,
      hideBeforeAnimating: false,
      fadeIn: true,
      initialState: AnimationState(
        offset: const Offset(0, 70),
        opacity: 0,
      ),
      finalState: AnimationState(
        offset: const Offset(0, 0),
        opacity: 1,
      ),
    ),
  };
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // bool _flag = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // startPageLoadAnimations(
    //   animationsMap.values
    //       .where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
    //   this,
    // );
    // _animationController = AnimationController(
    //     vsync: this, duration: const Duration(milliseconds: 450));
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  // final TextEditingController valueController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    // valueController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    // tasksServices.initComplete.value = false;
    // tasksServices.initComplete.addListener(() {
    //   print(tasksServices.initComplete.value);
    //   if(tasksServices.initComplete.value) {
    //
    //   }
    // });

    // tasksServices.validNetworkID.value = false;
    // tasksServices.validNetworkID.addListener(() {
    //   print(tasksServices.validNetworkID.value);
    //   if(tasksServices.validNetworkID.value) {
    //
    //   }
    // });

    bool isFloatButtonVisible = false;

    if (tasksServices.publicAddress != null && tasksServices.validChainID) {
      isFloatButtonVisible = true;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Devopsdao',
              style: FlutterFlowTheme.of(context).title2.override(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 22,
                  ),
            ),
          ],
        ),
        actions: [
          const LoadButtonIndicator(),
          // Row(
          //   mainAxisSize: MainAxisSize.max,
          //   children: [
          //     FlutterFlowIconButton(
          //       borderColor: Colors.transparent,
          //       borderRadius: 30,
          //       borderWidth: 1,
          //       buttonSize: 60,
          //       icon: Icon(
          //         Icons.account_balance_wallet,
          //         color: Colors.white,
          //         size: 30,
          //       ),
          //       onPressed: () async {
          //         await tasksServices.getCredentials();
          //       },
          //     ),
          //   ],
          // ),/
          if (tasksServices.isDeviceConnected ||
              tasksServices.platform == 'web')
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30,
                  borderWidth: 1,
                  buttonSize: 60,
                  icon: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () async {
                    // tasksServices.connectWallet();
                    // () async {
                    //   await tasksServices.connectWallet();
                    //   print(
                    //       "test fdasssssssssssssssssssssssssvczxvczxvz!!!!!!!!!");
                    // }();

                    showDialog(
                      context: context,
                      builder: (context) => const MyWalletPage(
                        title: '',
                      ),
                    );
                  },
                ),
              ],
            )
          else
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30,
                  borderWidth: 1,
                  buttonSize: 60,
                  icon: const Icon(
                    Icons.cloud_off,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () async {
                    // tasksServices.connectWallet();
                    // () async {
                    //   await tasksServices.connectWallet();
                    //   print(
                    //       "test fdasssssssssssssssssssssssssvczxvczxvz!!!!!!!!!");
                    // }();
                  },
                ),
              ],
            ),
          // Row(
          //   mainAxisSize: MainAxisSize.max,
          //   children: [
          //     Padding(
          //       padding: EdgeInsetsDirectional.fromSTEB(11, 11, 11, 11),
          //       child: Icon(
          //         Icons.settings_outlined,
          //         color: FlutterFlowTheme.of(context).primaryBtnText,
          //         size: 24,
          //       ),
          //     ),
          //   ],
          // ),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFF1E2429),
      floatingActionButton: isFloatButtonVisible
          ? FloatingActionButton(
              onPressed: () async {
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const CreateJobWidget(),
                //   ),
                // );
                showDialog(
                  context: context,
                  builder: (context) => const CreateJobDialog(),
                );
              },
              backgroundColor: FlutterFlowTheme.of(context).maximumBlueGreen,
              elevation: 8,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
            )
          : null,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // colors: [Colors.black, Colors.black, Colors.black],
            colors: [Colors.black, Colors.black, Colors.black],
            stops: [0, 0.5, 1],
            begin: AlignmentDirectional(1, -1),
            end: AlignmentDirectional(-1, 1),
          ),
          // image: DecorationImage(
          //   image: AssetImage("assets/images/background_shape_tiles_small.png"),
          //   // fit: BoxFit.cover,
          //   repeat: ImageRepeat.repeat,
          // ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tasksServices.isLoading
                  ? const LoadIndicator()
                  : Image.asset(
                      'assets/images/logo.png',
                      width: 163,
                      height: 140,
                      fit: BoxFit.fitHeight,
                    ),
                  // .animated([animationsMap['imageOnPageLoadAnimation']!]),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                child: Text(
                  'Welcome to Devopsdao',
                  style: FlutterFlowTheme.of(context).title1.override(
                        fontFamily: 'Lexend Deca',
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                    // .animated([animationsMap['textOnPageLoadAnimation']!]),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.44,
                      decoration: BoxDecoration(
                        color: const Color(0xff31d493),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'In your wallet',
                              style:
                                  FlutterFlowTheme.of(context).bodyText2.override(
                                        fontFamily: 'Poppins',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBtnText,
                                      ),
                            ),
                            Text(
                              '${tasksServices.ethBalance} DEV',
                              style: FlutterFlowTheme.of(context).title2.override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBtnText,
                                  ),
                            ),
                            Text(
                              '${tasksServices.ethBalanceToken} aUSDC',
                              style: FlutterFlowTheme.of(context).title2.override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBtnText,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.44,
                      decoration: BoxDecoration(
                        color: const Color(0xffff8222),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pending',
                              style:
                                  FlutterFlowTheme.of(context).bodyText2.override(
                                        fontFamily: 'Poppins',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBtnText,
                                      ),
                            ),
                            Text(
                              '${tasksServices.pendingBalance} DEV',
                              style: FlutterFlowTheme.of(context).title2.override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBtnText,
                                  ),
                            ),
                            Text(
                              '${tasksServices.pendingBalanceToken} aUSDC',
                              style: FlutterFlowTheme.of(context).title2.override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBtnText,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  decoration: BoxDecoration(
                    color: const Color(0xff1da5f1),
                    borderRadius: BorderRadius.circular(8),
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wallet address',
                          style: FlutterFlowTheme.of(context).bodyText2.override(
                                fontFamily: 'Poppins',
                                color:
                                    FlutterFlowTheme.of(context).primaryBtnText,
                              ),
                        ),
                        if (tasksServices.publicAddress != null)
                          SelectableText(
                            '${tasksServices.publicAddress}',
                            style: FlutterFlowTheme.of(context)
                                .bodyText2
                                .override(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color:
                                      FlutterFlowTheme.of(context).primaryBtnText,
                                ),
                          )
                        else
                          Text(
                            'Not Connected',
                            style: FlutterFlowTheme.of(context)
                                .bodyText2
                                .override(
                                  fontFamily: 'Poppins',
                                  color:
                                      FlutterFlowTheme.of(context).primaryBtnText,
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  decoration: BoxDecoration(
                    color: Color(0xffc75394),
                    borderRadius: BorderRadius.circular(8),
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your score:',
                          style: FlutterFlowTheme.of(context).bodyText2.override(
                                fontFamily: 'Poppins',
                                color:
                                    FlutterFlowTheme.of(context).primaryBtnText,
                              ),
                        ),
                        if (tasksServices.publicAddress == null)
                          Text(
                            'Not Connected',
                            style: FlutterFlowTheme.of(context)
                                .bodyText2
                                .override(
                                  fontFamily: 'Poppins',
                                  color:
                                      FlutterFlowTheme.of(context).primaryBtnText,
                                ),
                          )
                        else if (tasksServices.scoredTaskCount == 0)
                          Text(
                            'No completed evaluated tasks',
                            style: FlutterFlowTheme.of(context)
                                .bodyText2
                                .override(
                                  fontFamily: 'Poppins',
                                  color:
                                      FlutterFlowTheme.of(context).primaryBtnText,
                                ),
                          )
                        else
                          SelectableText(
                            '${tasksServices.myScore} of ${tasksServices.scoredTaskCount} tasks',
                            style: FlutterFlowTheme.of(context)
                                .bodyText2
                                .override(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color:
                                      FlutterFlowTheme.of(context).primaryBtnText,
                                ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                  'v${tasksServices.version}-${tasksServices.buildNumber}, Platform: ${tasksServices.platform}; Browser Platform: ${tasksServices.browserPlatform}',
                  style: const TextStyle(
                    height: 2,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 11,
                  )),
            ],
          ),
        )
            // .animated([animationsMap['columnOnPageLoadAnimation']!]),
      )
          // .animated([animationsMap['containerOnPageLoadAnimation']!]),
    );
  }
}
