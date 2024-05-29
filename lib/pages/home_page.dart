import 'package:animations/animations.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:jovial_svg/jovial_svg.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webthree/src/credentials/address.dart';

import '../blockchain/chain_presets/chains_presets.dart';
import '../blockchain/interface.dart';
import '../blockchain/classes.dart';
import '../create_job/main.dart';
import '../create_job/create_job_call_button.dart';
import '../navigation/navmenu.dart';
import '../statistics/model_view/pending_model_view.dart';
import '../statistics/widget/tasks_statistics.dart';
import '../statistics/widget/token_statistics.dart';
import '../wallet/model_view/wallet_model.dart';
import '../wallet/model_view/mm_model.dart';
import '../wallet/services/wallet_service.dart';
import '../wallet/services/wc_service.dart';
import '../widgets/icon_image.dart';
import '../widgets/loading.dart';
import '../config/theme.dart';
import 'package:flutter/material.dart';

import 'package:dodao/blockchain/task_services.dart';

import '../wallet/widgets/main/main.dart';
import '../widgets/tags/tags_old.dart';
import '../widgets/tags/wrapped_chip.dart';
import 'home_page/wallet_connect_button.dart';

class HomePageWidget extends StatefulWidget {
  // final String displayUri;
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  // final _controller = SidebarXController(selectedIndex: 0, extended: true);


  // final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  // bool _flag = true;
  // late AnimationController fg_animationController;

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
    var tasksServices = context.read<TasksServices>();
    var interface = context.read<InterfaceServices>();
    final isDeviceConnected = context.select((TasksServices vm) => vm.isDeviceConnected);
    final allowedChainId = context.select((WalletModel vm) => vm.state.allowedChainId);
    final walletConnected = context.select((WalletModel vm) => vm.state.walletConnected);
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);
    TokenPendingModel tokenPendingModel = context.read<TokenPendingModel>();

    bool isFloatButtonVisible = false;
    if (listenWalletAddress != null && allowedChainId) {
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
                const WalletConnectButton(),
                if (!isDeviceConnected)
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
                            false
                            // tasksServices.isLoading
                                ? const LoadIndicator()
                                : Image.asset(
                                    'assets/images/LColor.png',
                                    width: 200,
                                    height: 200,
                                    filterQuality: FilterQuality.medium,
                                    // fit: BoxFit.fitHeight,
                                  ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  BlurryContainer(

                                    blur: 3,
                                    color: DodaoTheme.of(context).transparentCloud,
                                    padding: const EdgeInsets.all(0.5),
                                    child: Container(
                                      padding: const EdgeInsetsDirectional.fromSTEB(14, 8, 14, 8),
                                      decoration: BoxDecoration(
                                        borderRadius: DodaoTheme.of(context).borderRadius,
                                        border: DodaoTheme.of(context).borderGradient,
                                      ),
                                      child: const TokensStats(),
                                    ),
                                  ),
                                  const SizedBox(height: 16,),
                                  // const TasksStatistics(),
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
                          ],
                        ),
                      );
                    })))),
      ],
    );
  }
}

