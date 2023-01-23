import 'package:animations/animations.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../create_job/create_job_as_page.dart';
import '../create_job/create_job_call_button.dart';
import '../create_job/create_job_widget.dart';
import '../widgets/loading.dart';
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

  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

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
    var interface = context.watch<InterfaceServices>();
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
          Center(
            child: Container(
              // width: 150,
              height: 30,
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),


              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Colors.purpleAccent, Colors.deepOrangeAccent, Color(0xfffadb00)],
                  stops: [0.1, 0.5, 1],
                ),
              ),
              child: InkWell(
                highlightColor: Colors.white,
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) => const WalletPageTop(
                    ),
                  );
                },
                child: tasksServices.walletConnected ? Text(
                  '${tasksServices.publicAddress.toString().substring(0, 5)}'
                  '...'
                  '${tasksServices.publicAddress.toString()
                      .substring(tasksServices.publicAddress.toString().length - 5)}'
                  ,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ) : const Text(
                  'Connect wallet',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )
              ),
            ),
          ),
          // FlutterFlowIconButton(
          //   borderColor: Colors.transparent,
          //   borderRadius: 30,
          //   borderWidth: 1,
          //   buttonSize: 60,
          //   icon: const Icon(
          //     Icons.account_balance_wallet,
          //     color: Colors.white,
          //     size: 30,
          //   ),
          //   onPressed: () async {
          //     showDialog(
          //       context: context,
          //       builder: (context) => const WalletPageTop(
          //       ),
          //     );
          //   },
          // ),
          const LoadButtonIndicator(),


          if (!tasksServices.isDeviceConnected)
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
                    // }();
                  },
                ),
              ],
            ),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFF1E2429),
      floatingActionButton: isFloatButtonVisible
          ? const CreateCallButton() : null,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
        alignment: Alignment.center,
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
          child: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
            width: interface.maxStaticGlobalWidth,
            child: LayoutBuilder(builder: (context, constraints){
              final double halfWidth = constraints.maxWidth / 2 - 8;
              final double fullWidth = constraints.maxWidth;
              return Column(
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
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: halfWidth,
                        decoration: BoxDecoration(
                          // color: const Color(0xff31d493),
                          borderRadius: BorderRadius.circular(22),
                          gradient: const LinearGradient(
                            colors: [Colors.blueAccent, Colors.purple, Colors.purpleAccent],
                            stops: [0.2, 0.7, 1],
                          ),
                        ),
                        child: Padding(
                          padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 12, 12, 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'In your wallet',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                  )
                              ),
                              Text(
                                '${tasksServices.ethBalance} DEV',
                                  style: const TextStyle(
                                    height: 1.6,
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                  )
                              ),
                              Text(
                                '${tasksServices.ethBalanceToken} aUSDC',
                                  style: const TextStyle(
                                    height: 1,
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: halfWidth,
                        decoration: BoxDecoration(
                          // color: const Color(0xffff8222),
                          borderRadius: BorderRadius.circular(22),
                          gradient: const LinearGradient(
                            colors: [Color(0xfffadb00), Colors.deepOrangeAccent, Colors.deepOrange],
                            stops: [0, 0.6, 1],
                          ),
                        ),
                        child: Padding(
                          padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 12, 12, 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pending',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                )
                              ),
                              Text(
                                '${tasksServices.pendingBalance} DEV',
                                  style: const TextStyle(
                                    height: 1.6,
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                  )
                              ),
                              Text(
                                '${tasksServices.pendingBalanceToken} aUSDC',
                                  style: const TextStyle(
                                    height: 1,
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Container(
                      width: fullWidth,
                      decoration: BoxDecoration(
                        color: Colors.white12,
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
                            const Text(
                              'Wallet address',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                )
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
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Container(
                      width: fullWidth,
                      decoration: BoxDecoration(
                        color: Colors.white12,
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
                            const Text(
                              'Your score:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                )
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
              );
            })
          ),
        )
      )
    );
  }
}
