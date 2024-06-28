import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../blockchain/accounts.dart';
import '../../../blockchain/interface.dart';
import '../../../blockchain/task_services.dart';
import '../../../config/theme.dart';
import '../../../widgets/badge-small-colored.dart';
import '../../../config/utils/my_tools.dart';

import 'package:badges/badges.dart' as Badges;

import 'dart:ui' as ui;

import '../fab_buttons.dart';
import '../widget/last_activities_list.dart';

class AccountMainPage extends StatefulWidget {
  final double screenHeightSizeNoKeyboard;
  final double innerPaddingWidth;
  final double screenHeightSize;
  final Account account;
  final String accountRole;

  const AccountMainPage({
    Key? key,
    required this.accountRole,
    required this.screenHeightSizeNoKeyboard,
    required this.innerPaddingWidth,
    required this.screenHeightSize,
    required this.account,
  }) : super(key: key);

  @override
  _AccountMainPageState createState() => _AccountMainPageState();
}

class _AccountMainPageState extends State<AccountMainPage> {
  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    // var interface = context.watch<InterfaceServices>();

    final double maxStaticInternalDialogWidth = InterfaceSettings.maxStaticInternalDialogWidth;
    final double innerPaddingWidth = widget.innerPaddingWidth;

    final BoxDecoration materialMainBoxDecoration = BoxDecoration(
      borderRadius: DodaoTheme.of(context).borderRadius,
      border: DodaoTheme.of(context).borderGradient,
    );

    double calculateAverageRating(List<BigInt> ratings) {
      if (ratings.isEmpty) return 0;
      int sum = ratings.fold(0, (sum, rating) => sum + rating.toInt());
      return sum / ratings.length;
    }

    return Scaffold(
      backgroundColor: DodaoTheme.of(context).taskBackgroundColor,
      body: Container(
        height: widget.screenHeightSize,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 5.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxStaticInternalDialogWidth,
            maxHeight: widget.screenHeightSize,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 3, bottom: 14),
            child: Column(
              children: [
                //////// General information about Account:
                Material(
                  elevation: DodaoTheme.of(context).elevation,
                  borderRadius: DodaoTheme.of(context).borderRadius,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                    width: innerPaddingWidth,
                    decoration: materialMainBoxDecoration,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('General information:', style: DodaoTheme.of(context).bodyText2),
                        Row(
                          children: [
                            const FaIcon(FontAwesomeIcons.user, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              widget.account.nickName.isNotEmpty ? widget.account.nickName : 'Nameless',
                              style: DodaoTheme.of(context).bodyText3,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const FaIcon(FontAwesomeIcons.infoCircle, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              widget.account.about.isNotEmpty ? widget.account.about : 'About info not filled',
                              style: DodaoTheme.of(context).bodyText3,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const FaIcon(FontAwesomeIcons.wallet, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              widget.account.walletAddress.toString(),
                              style: DodaoTheme.of(context).bodyText3,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                /////// Activities:
                Container(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Material(
                    elevation: DodaoTheme.of(context).elevation,
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                      width: innerPaddingWidth,
                      decoration: materialMainBoxDecoration,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Activities:', style: DodaoTheme.of(context).bodyText2),
                          SizedBox(
                            height: 100,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    children: [
                                      const FaIcon(FontAwesomeIcons.folderPlus, size: 16),
                                      const SizedBox(width: 8),
                                      BadgeSmallColored(count: widget.account.customerTasks.length, color: Colors.lightBlue),
                                      Text(
                                        ' - Created',
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
                                      const FaIcon(FontAwesomeIcons.handshake, size: 16),
                                      const SizedBox(width: 8),
                                      BadgeSmallColored(count: widget.account.participantTasks.length, color: Colors.amber),
                                      Text(
                                        ' - Participated',
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
                                      const FaIcon(FontAwesomeIcons.searchDollar, size: 16),
                                      const SizedBox(width: 8),
                                      BadgeSmallColored(count: widget.account.auditParticipantTasks.length, color: Colors.redAccent),
                                      Text(
                                        ' - Audit requested',
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
                                      const FaIcon(FontAwesomeIcons.check, size: 16),
                                      const SizedBox(width: 8),
                                      BadgeSmallColored(count: widget.account.performerCompletedTasks.length, color: Colors.green),
                                      Text(
                                        ' - Completed',
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /////// Scores:
                Container(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Material(
                    elevation: DodaoTheme.of(context).elevation,
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                      width: innerPaddingWidth,
                      decoration: materialMainBoxDecoration,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Scores:', style: DodaoTheme.of(context).bodyText2),
                          Container(
                            height: 55,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    children: [
                                      const FaIcon(FontAwesomeIcons.solidStar, size: 16, color: Colors.amber),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Customer rating: ${calculateAverageRating(widget.account.customerRating).toStringAsFixed(2)}',
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
                                      const FaIcon(FontAwesomeIcons.solidStar, size: 16, color: Colors.amber),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Performer rating: ${calculateAverageRating(widget.account.performerRating).toStringAsFixed(2)}',
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /////// Last activities:
                Container(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Material(
                    color: DodaoTheme.of(context).taskBackgroundColor,
                    elevation: DodaoTheme.of(context).elevation,
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12.0, 14.0, 12.0, 8.0),
                      width: innerPaddingWidth,
                      decoration: materialMainBoxDecoration,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Last Activities:', style: DodaoTheme.of(context).bodyText2),
                          Builder(
                            builder: (context) {
                              return SizedBox(
                                child: LastActivitiesList(account: widget.account),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonAnimator: NoScalingAnimation(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 13, left: 46),
        child: tasksServices.roleNfts['governor'] > 0
            ? SetsOfFabButtonsForAccountDialog(account: widget.account, accountRole: widget.accountRole)
            : null,
      ),
    );
  }
}
