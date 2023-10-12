import 'package:animations/animations.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:jovial_svg/jovial_svg.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blockchain/interface.dart';
import '../blockchain/classes.dart';
import '../create_job/main.dart';
import '../create_job/create_job_call_button.dart';
import '../navigation/navmenu.dart';
import '../widgets/home_statistics.dart';
import '../widgets/loading.dart';
import '../config/flutter_flow_animations.dart';
import '../config/flutter_flow_icon_button.dart';
import '../config/theme.dart';
import 'package:flutter/material.dart';

import 'package:dodao/blockchain/task_services.dart';

import '../wallet/main.dart';
import '../widgets/tags/tags_old.dart';
import '../widgets/tags/wrapped_chip.dart';

class HomePageWidget extends StatefulWidget {
  // final String displayUri;
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  // final animationsMap = {
  //   'containerOnPageLoadAnimation': AnimationInfo(
  //     trigger: AnimationTrigger.onPageLoad,
  //     duration: 1000,
  //     delay: 1000,
  //     hideBeforeAnimating: false,
  //     fadeIn: false, // changed to false(orig from FLOW true)
  //     initialState: AnimationState(
  //       opacity: 0,
  //     ),
  //     finalState: AnimationState(
  //       opacity: 1,
  //     ),
  //   ),
  //   'columnOnPageLoadAnimation': AnimationInfo(
  //     trigger: AnimationTrigger.onPageLoad,
  //     duration: 100,
  //     hideBeforeAnimating: false,
  //     fadeIn: true,
  //     initialState: AnimationState(
  //       opacity: 0,
  //     ),
  //     finalState: AnimationState(
  //       opacity: 1,
  //     ),
  //   ),
  //   'imageOnPageLoadAnimation': AnimationInfo(
  //     trigger: AnimationTrigger.onPageLoad,
  //     duration: 600,
  //     delay: 1100,
  //     hideBeforeAnimating: false,
  //     fadeIn: true,
  //     initialState: AnimationState(
  //       scale: 0.4,
  //       opacity: 0,
  //     ),
  //     finalState: AnimationState(
  //       scale: 1,
  //       opacity: 1,
  //     ),
  //   ),
  //   'textOnPageLoadAnimation': AnimationInfo(
  //     trigger: AnimationTrigger.onPageLoad,
  //     duration: 600,
  //     delay: 1100,
  //     hideBeforeAnimating: false,
  //     fadeIn: true,
  //     initialState: AnimationState(
  //       offset: const Offset(0, 70),
  //       opacity: 0,
  //     ),
  //     finalState: AnimationState(
  //       offset: const Offset(0, 0),
  //       opacity: 1,
  //     ),
  //   ),
  // };

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    bool isFloatButtonVisible = false;
    if (tasksServices.publicAddress != null && tasksServices.validChainID) {
      isFloatButtonVisible = true;
    }

    late bool desktopWidth = false;
    if (MediaQuery.of(context).size.width > 700) {
      desktopWidth = true;
    }

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;


    return Stack(
      children: [
        if (!desktopWidth)
        Image.asset(
          "assets/images/background_part_top.png",
          fit: BoxFit.none,
          height: height,
          width: width,
          filterQuality: FilterQuality.medium,
          alignment: Alignment.topRight,
          scale: 1.0,
        ),
        if (!desktopWidth)
        Image.asset(
          "assets/images/background_part_bottom.png",
          fit: BoxFit.none,
          height: height,
          width: width,
          filterQuality: FilterQuality.medium,
          alignment: Alignment.bottomLeft,
          scale: 1.0,
        ),
        if (desktopWidth)
          Image.asset(
            "assets/images/background_part_top_big.png",
            fit: BoxFit.none,
            height: height,
            width: width,
            filterQuality: FilterQuality.medium,
            alignment: Alignment.topRight,
            scale: 0.8,
          ),
        if (desktopWidth)
          Image.asset(
            "assets/images/background_part_bottom_big.png",
            fit: BoxFit.none,
            height: height,
            width: width,
            filterQuality: FilterQuality.medium,
            alignment: Alignment.bottomLeft,
            scale: 0.8,
          ),
        Scaffold(
            backgroundColor: Colors.transparent,
            key: scaffoldKey,
            // drawer: const NavDrawer(),
            // extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            drawer: SideBar(controller: SidebarXController(selectedIndex: 0, extended: true)),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              // automaticallyImplyLeading: false,
              title: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('Dodao', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0, right: 14, top: 8, bottom: 8),
                    child: Container(
                      // width: 150,
                      height: 30,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),

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
                              builder: (context) => const WalletPageTop(),
                            );
                          },
                          child: tasksServices.walletConnected && tasksServices.publicAddress != null
                              ? Row(
                                children: [
                                  interface.networkLogo(tasksServices.chainId, Colors.white, 24),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                        // '${tasksServices.publicAddress.toString().substring(0, 4)}'
                                        '..'
                                        '${tasksServices.publicAddress.toString().substring(tasksServices.publicAddress.toString().length - 5)}',
                                        // textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 14, color: Colors.white),
                                      ),
                                  ),
                                ],
                              )
                              : const Text(
                                  'Connect wallet',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14, color: Colors.white),
                                )),
                    ),
                  ),
                ),
                if (!tasksServices.isDeviceConnected)
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 14),
                    child: Icon(
                      Icons.cloud_off,
                      color: DodaoTheme.of(context).primaryText,
                      size: 26,
                    ),
                  ),
              ],
              centerTitle: false,
            ),
            // backgroundColor: Colors.black,
            floatingActionButton: isFloatButtonVisible ? const CreateCallButton() : null,
            body: Align(
                alignment: Alignment.center,
                child: Container(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                    width: interface.maxStaticDialogWidth,
                    child: LayoutBuilder(builder: (context, constraints) {
                      // final double halfWidth = constraints.maxWidth / 2 - 8;
                      // final double fullWidth = constraints.maxWidth;
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            tasksServices.isLoading
                                ? const LoadIndicator()
                                : Image.asset(
                                    'assets/images/LColor.png',
                                    width: 250,
                                    height: 250,
                                    filterQuality: FilterQuality.medium,
                                    // fit: BoxFit.fitHeight,
                                  ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  BlurryContainer(

                                    blur: 4,
                                    color: DodaoTheme.of(context).transparentCloud,
                                    padding: const EdgeInsets.all(0.5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: DodaoTheme.of(context).borderRadius,
                                        border: DodaoTheme.of(context).borderGradient,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(22, 12, 22, 12),
                                        child: LayoutBuilder(builder: (context, constraints) {
                                          // final double width = constraints.maxWidth - 66;
                                          // List<TokenItem> tags = [];
                                          // if (tasksServices.roleNfts['auditor'] > 0) {
                                          //   tags.add(TokenItem(collection: true, name: "Auditor", icon: ""));
                                          // }
                                          // if (tasksServices.roleNfts['governor'] > 0) {
                                          //   tags.add(TokenItem(collection: true, name: "Governor", icon: ""));
                                          // }
                                          // tags.add(TokenItem(collection: true, name: "Get more...", icon: ""));

                                          return const HomeStatistics();


                                          // return Column(
                                          //   mainAxisSize: MainAxisSize.max,
                                          //   crossAxisAlignment: CrossAxisAlignment.start,
                                          //   children: [
                                          //     Row(
                                          //       mainAxisSize: MainAxisSize.max,
                                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //       children: [
                                          //         Padding(
                                          //           padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 22),
                                          //           child: Column(
                                          //             mainAxisSize: MainAxisSize.max,
                                          //             mainAxisAlignment: MainAxisAlignment.center,
                                          //             crossAxisAlignment: CrossAxisAlignment.start,
                                          //             children: [
                                          //               Text('In your wallet:',
                                          //                   style: Theme.of(context).textTheme.bodyMedium),
                                          //               Text('${tasksServices.ethBalance} ${tasksServices.chainTicker}',
                                          //                   style: Theme.of(context).textTheme.bodyLarge),
                                          //               Text('${tasksServices.ethBalanceToken} USDC',
                                          //                   style: Theme.of(context).textTheme.bodyLarge),
                                          //             ],
                                          //           ),
                                          //         ),
                                          //         // const Spacer(),
                                          //         Padding(
                                          //           padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 22),
                                          //           child: Column(
                                          //             mainAxisSize: MainAxisSize.max,
                                          //             mainAxisAlignment: MainAxisAlignment.center,
                                          //             crossAxisAlignment: CrossAxisAlignment.start,
                                          //             children: [
                                          //               Text('Pending:',
                                          //                   style: Theme.of(context).textTheme.bodyMedium),
                                          //               Text('${tasksServices.pendingBalance} ${tasksServices.chainTicker}',
                                          //                   style: Theme.of(context).textTheme.bodyLarge),
                                          //               Text('${tasksServices.pendingBalanceToken} USDC',
                                          //                   style: Theme.of(context).textTheme.bodyLarge),
                                          //             ],
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //     Text('Your Nft\'s:',
                                          //         style: Theme.of(context).textTheme.bodyMedium),
                                          //     SizedBox(
                                          //       // width: width,
                                          //       child: Wrap(
                                          //           alignment: WrapAlignment.start,
                                          //           direction: Axis.horizontal,
                                          //           children: tags.map((e) {
                                          //             return WrappedChip(
                                          //               key: ValueKey(e),
                                          //               item: MapEntry(
                                          //                   e.name,
                                          //                   NftCollection(
                                          //                     selected: false,
                                          //                     name: e.name,
                                          //                     bunch: {BigInt.from(0): TokenItem(name: e.name, collection: true)},
                                          //                   )),
                                          //               page: 'home',
                                          //               selected: e.selected,
                                          //               wrapperRole: e.name == 'Get more...' ? WrapperRole.getMore : WrapperRole.onStartPage,
                                          //             );
                                          //           }).toList()),
                                          //     ),
                                          //   ],
                                          // );




                                        }),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16,),
                                  BlurryContainer(
                                    width: interface.maxStaticDialogWidth,
                                    color: DodaoTheme.of(context).transparentCloud,
                                    blur: 4,
                                    padding: const EdgeInsets.all(0.5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: DodaoTheme.of(context).borderRadius,
                                        border: DodaoTheme.of(context).borderGradient,
                                      ),
                                      padding: const EdgeInsetsDirectional.fromSTEB(22, 12, 12, 12),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Your score:',
                                              style: Theme.of(context).textTheme.bodyMedium),
                                          if (tasksServices.publicAddress == null)
                                            Text(
                                              'Not Connected',
                                              style: Theme.of(context).textTheme.titleSmall,
                                            )
                                          else if (tasksServices.scoredTaskCount == 0)
                                            Text(
                                              'No completed evaluated tasks',
                                              style: Theme.of(context).textTheme.titleSmall,
                                            )
                                          else
                                            SelectableText(
                                              '${tasksServices.myScore} of ${tasksServices.scoredTaskCount} tasks',
                                              style: Theme.of(context).textTheme.titleSmall,
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(height: 1,),
                                  Container(
                                      padding: const EdgeInsets.only(top: 10.0, bottom: 6),
                                      alignment: Alignment.center,
                                      child: InkWell(
                                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            Icon(
                                              Icons.library_books_outlined,
                                              color: DodaoTheme.of(context).secondaryText,
                                              size: 18,
                                            ),
                                            Text(
                                              ' docs.dodao.dev',
                                              style: DodaoTheme.of(context)
                                                  .bodyText3
                                                  .override(fontFamily: 'Inter', color: DodaoTheme.of(context).secondaryText, fontSize: 14),
                                            ),
                                          ]),
                                          onTap: () => launchUrl(Uri.parse('https://docs.dodao.dev/'))))
                                ],
                              ),
                            ),

                            // Column(
                            //   children: [
                            //     Container(
                            //         padding: const EdgeInsets.only(top: 13.0, bottom: 6),
                            //         alignment: Alignment.center,
                            //         child: InkWell(
                            //             child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            //               Icon(
                            //                 Icons.library_books_outlined,
                            //                 color: DodaoTheme.of(context).primaryText,
                            //                 size: 18,
                            //               ),
                            //               Text(
                            //                 ' docs.dodao.dev',
                            //                 style: DodaoTheme.of(context)
                            //                     .bodyText3
                            //                     .override(fontFamily: 'Inter', color: DodaoTheme.of(context).primaryText, fontSize: 14),
                            //               ),
                            //             ]),
                            //             onTap: () => launchUrl(Uri.parse('https://docs.dodao.dev/')))),
                            //     Text(
                            //         tasksServices.browserPlatform ??
                            //             'v${tasksServices.version}-${tasksServices.buildNumber}, Platform: ${tasksServices.platform}; Browser Platform: ${tasksServices.browserPlatform}',
                            //         style: TextStyle(
                            //           height: 2,
                            //           fontWeight: FontWeight.bold,
                            //           color: DodaoTheme.of(context).primaryText,
                            //           fontSize: 10,
                            //         )),
                            //   ],
                            // )


                          ],
                        ),
                      );
                    })))),
      ],
    );
  }
}
