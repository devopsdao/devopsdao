import 'package:beamer/beamer.dart';
import 'package:dodao/account_dialog/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webthree/credentials.dart';

import '../blockchain/accounts.dart';
import '../blockchain/interface.dart';
import '../blockchain/classes.dart';
import '../blockchain/task_services.dart';
import 'header.dart';

// Name of Widget & TaskDialogBeamer > TaskDialogFuture > Skeleton > Header > Pages > (topup, main, deskription, selection, widgets.chat)

class AccountFuture extends StatefulWidget {
  final String fromPage;
  final EthereumAddress? taskAddress;
  final bool shimmerEnabled;
  const AccountFuture({
    Key? key,
    required this.fromPage,
    this.taskAddress,
    required this.shimmerEnabled,
  }) : super(key: key);

  @override
  _AccountFutureState createState() => _AccountFutureState();
}

class _AccountFutureState extends State<AccountFuture> {
  String backgroundPicture = "assets/images/niceshape.png";

  late Map<String, dynamic> dialogState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late Account account;
    var tasksServices = context.read<TasksServices>();

    EthereumAddress? taskAddress = widget.taskAddress;
    return FutureBuilder<Account>(
        future: null,
        // future: tasksServices.loadOneTask(taskAddress), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<Account> snapshot) {
          // if (snapshot.connectionState == ConnectionState.done) {
          // if (true) {
          //   account = tasksServices.accountsData['2']!;
          //   return AccountSkeleton(fromPage: widget.fromPage, object: account, isLoading: false);
          // }
          account = Account(
              nickName: 'Loading ...',
              about: 'Loading ...',
              walletAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
              customerTasks: [],
              participantTasks: [],
              auditParticipantTasks: [],
              customerRating: [0],
              performerRating: [0]);
          return AccountSkeleton(fromPage: widget.fromPage, object: account, isLoading: true);
        });
  }
}

class AccountSkeleton extends StatefulWidget {
  final String fromPage;
  final Account object;
  final bool isLoading;
  const AccountSkeleton({
    Key? key,
    required this.object,
    required this.fromPage,
    required this.isLoading,
  }) : super(key: key);

  @override
  _AccountSkeletonState createState() => _AccountSkeletonState();
}

class _AccountSkeletonState extends State<AccountSkeleton> {
  String backgroundPicture = "assets/images/niceshape.png";

  late Map<String, dynamic> dialogState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var interface = context.read<InterfaceServices>();
    // var tasksServices = context.read<TasksServices>();

    final account = widget.object;
    String fromPage = widget.fromPage;
    backgroundPicture = "assets/images/cyrcle.png";

    return Container(
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(backgroundPicture), fit: BoxFit.scaleDown, alignment: Alignment.bottomRight),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        // ****** Count Screen size with keyboard and without ***** ///
        final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
        final double screenHeightSizeNoKeyboard = constraints.maxHeight - 70;
        final double screenHeightSize = screenHeightSizeNoKeyboard - keyboardSize;
        final statusBarHeight = MediaQuery.of(context).viewPadding.top;
        return Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            height: statusBarHeight,
          ),
          DialogHeader(
            account: account,
            fromPage: fromPage,
          ),
          SizedBox(
            height: screenHeightSize - statusBarHeight,
            // width: constraints.maxWidth * .8,
            // height: 550,
            width: interface.maxStaticDialogWidth,

            child: widget.isLoading == false
                ? AccountPages(
                    account: account,
                    fromPage: widget.fromPage,
                    screenHeightSize: screenHeightSize,
                    screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard - statusBarHeight,
                  )
                : ShimmeredPages(
                    object: account,
                  ),
          ),
        ]);
      }),
    );
  }
}

class ShimmeredPages extends StatelessWidget {
  final Account object;

  const ShimmeredPages({
    Key? key,
    required this.object,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();

    final double maxStaticInternalDialogWidth = interface.maxStaticInternalDialogWidth;

    return LayoutBuilder(builder: (ctx, dialogConstraints) {
      double innerPaddingWidth = dialogConstraints.maxWidth - 50;

      return Column(
        children: <Widget>[
          // if (interface.dialogCurrentState['pages'].containsKey('main'))
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxStaticInternalDialogWidth,
            ),
            child: Column(
              children: [
                // const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(height: 62, width: innerPaddingWidth, color: Colors.grey[300])),
                ),
                // ************ Show prices and topup part ******** //
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(padding: const EdgeInsets.only(top: 14), height: 50, width: innerPaddingWidth, color: Colors.grey[300])),
                ),

                // ********* Text Input ************ //
                Shimmer.fromColors(
                    baseColor: Colors.grey[350]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(padding: const EdgeInsets.only(top: 14), height: 70, width: innerPaddingWidth, color: Colors.grey[350]))
              ],
            ),
          ),
        ],
      );
    });
  }
}

class AccountBeamer extends StatelessWidget {
  final String fromPage;
  final EthereumAddress? taskAddress;
  const AccountBeamer({Key? key, this.taskAddress, required this.fromPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String taskAddressString = taskAddress.toString();
    RouteInformation routeInfo = RouteInformation(location: '/$fromPage/$taskAddressString');
    Beamer.of(context).updateRouteInformation(routeInfo);
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      // padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      alignment: Alignment.center,
      child: AccountFuture(fromPage: fromPage, taskAddress: taskAddress, shimmerEnabled: true),
    ));
  }
}
