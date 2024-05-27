import 'package:beamer/beamer.dart';
import 'package:dodao/account_dialog/widget/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/accounts.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../widgets/badge-small-colored.dart';
import 'header.dart';

// Name of Widget & TaskDialogBeamer > TaskDialogFuture > Skeleton > Header > Pages > (topup, main, deskription, selection, widgets.chat)

class AccountFuture extends StatefulWidget {
  final String accountRole;
  final Account account;
  final bool shimmerEnabled;
  const AccountFuture({
    Key? key,
    required this.accountRole,
    required this.account,
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

    return FutureBuilder<Map<String, Account>>(
        future: tasksServices.getAccountsData(requestedAccountsList: [widget.account.walletAddress]),
        // future: tasksServices.loadOneTask(taskAddress), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<Map<String, Account>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              snapshot.error.toString();
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              return AccountDialogSkeleton(accountRole: widget.accountRole, object: snapshot.data!.values.first, isLoading: false);
            } else {
              return const Text('Empty data');
            }
          }
          account = Account(
              nickName: ' ',
              about: ' ',
              walletAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
              customerTasks: [],
              participantTasks: [],
              auditParticipantTasks: [],
              customerRating: [],
              performerRating: [],
              performerAgreedTasks: [],
              customerAgreedTasks: [],
              auditAgreed: [],
              auditCompleted: [],
              performerAuditedTasks: [],
              customerAuditedTasks: [],
              performerCompletedTasks: [],
              customerCompletedTasks: []);
          return AccountDialogSkeleton(accountRole: widget.accountRole, object: account, isLoading: true);
        });
  }
}

class AccountDialogSkeleton extends StatefulWidget {
  final String accountRole;
  final Account object;
  final bool isLoading;
  const AccountDialogSkeleton({
    Key? key,
    required this.object,
    required this.accountRole,
    required this.isLoading,
  }) : super(key: key);

  @override
  _AccountDialogSkeletonState createState() => _AccountDialogSkeletonState();
}

class _AccountDialogSkeletonState extends State<AccountDialogSkeleton> {
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
    backgroundPicture = "assets/images/cyrcle.png";

    return LayoutBuilder(builder: (context, constraints) {
      // ****** Count Screen size with keyboard and without ***** ///
      final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
      final double screenHeightSizeNoKeyboard = constraints.maxHeight - 70;
      final double screenHeightSize = screenHeightSizeNoKeyboard - keyboardSize;
      final statusBarHeight = MediaQuery.of(context).viewPadding.top;
      return Container(
        color: DodaoTheme.of(context).taskBackgroundColor,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            height: statusBarHeight,
          ),
          DialogHeader(
            account: account,
            accountRole: widget.accountRole,
          ),
          SizedBox(
              height: screenHeightSize - statusBarHeight,
              width: interface.maxStaticDialogWidth,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.easeInQuint,
                switchOutCurve: Curves.easeOutQuint,
                child: widget.isLoading == false
                    ? AccountDialogPages(
                        key: const Key("normal"),
                        account: account,
                        accountRole: widget.accountRole,
                        screenHeightSize: screenHeightSize,
                        screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard - statusBarHeight,
                      )
                    : ShimmeredPages(
                        object: account,
                      ),
              )),
        ]),
      );
    });
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
                  child: Material(
                    elevation: DodaoTheme.of(context).elevation,
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    child: Shimmer.fromColors(
                        baseColor: DodaoTheme.of(context).shimmerBaseColor,
                        highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
                        child: Container(
                          // height: 90,
                          width: innerPaddingWidth,
                          decoration: BoxDecoration(
                            borderRadius: DodaoTheme.of(context).borderRadius,
                            border: DodaoTheme.of(context).borderGradient,
                          ),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            child: Container(
                                padding: const EdgeInsets.all(4),
                                child: const Text('▇▇▇▇▇ ▇▇▇▇▇▇▇: \n▇▇▇▇ ▇▇▇▇▇▇▇ \n▇▇▇▇ ▇▇▇▇ \n▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇')),
                          ),
                        )),
                  ),
                ),
                // ************ Show prices and topup part ******** //
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Material(
                    elevation: DodaoTheme.of(context).elevation,
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    child: Shimmer.fromColors(
                        baseColor: DodaoTheme.of(context).shimmerBaseColor,
                        highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
                        child: Container(
                          // height: 90,
                          width: innerPaddingWidth,
                          decoration: BoxDecoration(
                            borderRadius: DodaoTheme.of(context).borderRadius,
                            border: DodaoTheme.of(context).borderGradient,
                          ),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(padding: const EdgeInsets.all(4), child: const Text('▇▇▇▇▇▇▇▇:')),
                                SizedBox(
                                  height: 80,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Row(
                                          children: [
                                            const BadgeSmallColored(
                                              count: 0,
                                              color: Colors.lightBlue,
                                            ),
                                            Text(
                                              ' - ▇▇▇▇▇▇',
                                              style: DodaoTheme.of(context).bodyText3,
                                              softWrap: false,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Row(
                                          children: [
                                            const BadgeSmallColored(
                                              count: 0,
                                              color: Colors.amber,
                                            ),
                                            Text(
                                              ' - ▇▇▇▇▇▇▇▇▇',
                                              style: DodaoTheme.of(context).bodyText3,
                                              softWrap: false,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Row(
                                          children: [
                                            const BadgeSmallColored(
                                              count: 0,
                                              color: Colors.redAccent,
                                            ),
                                            Text(
                                              ' - ▇▇▇▇ ▇▇▇▇▇▇▇▇▇',
                                              style: DodaoTheme.of(context).bodyText3,
                                              softWrap: false,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Material(
                    elevation: DodaoTheme.of(context).elevation,
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    child: Shimmer.fromColors(
                        baseColor: DodaoTheme.of(context).shimmerBaseColor,
                        highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
                        child: Container(
                          // height: 90,
                          width: innerPaddingWidth,
                          decoration: BoxDecoration(
                            borderRadius: DodaoTheme.of(context).borderRadius,
                            border: DodaoTheme.of(context).borderGradient,
                          ),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(padding: const EdgeInsets.all(4), child: const Text('▇▇▇▇▇▇▇▇:')),
                                SizedBox(
                                  height: 60,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Row(
                                          children: [
                                            BadgeSmallColored(
                                              count: 0,
                                              color: Colors.lightBlue,
                                            ),
                                            Text(
                                              ' - ▇▇▇▇▇▇▇ ▇▇▇▇▇',
                                              style: DodaoTheme.of(context).bodyText3,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Row(
                                          children: [
                                            BadgeSmallColored(
                                              count: 0,
                                              color: Colors.amber,
                                            ),
                                            Text(
                                              ' - ▇▇▇▇▇▇ ▇▇▇▇▇▇',
                                              style: DodaoTheme.of(context).bodyText3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
