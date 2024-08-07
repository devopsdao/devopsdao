import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  // TextEditingController? messageForStateController;

  @override
  void initState() {
    super.initState();
    // messageForStateController = TextEditingController();
  }

  @override
  void dispose() {
    // messageForStateController!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    final double maxStaticInternalDialogWidth = InterfaceSettings.maxStaticInternalDialogWidth;
    final double innerPaddingWidth = widget.innerPaddingWidth;

    final BoxDecoration materialMainBoxDecoration = BoxDecoration(
      borderRadius: DodaoTheme.of(context).borderRadius,
      border: DodaoTheme.of(context).borderGradient,
    );


    //here we save the values, so that they are not lost when we go to other pages, they will reset on close or topup button:
    // messageForStateController!.text = interface.taskMessage;


    // Widget badgeWidget(count, color) {
    //   return Badges.Badge(
    //     badgeStyle: Badges.BadgeStyle(
    //       badgeColor: color,
    //       elevation: 0,
    //       shape: Badges.BadgeShape.circle,
    //       borderRadius: BorderRadius.circular(4),
    //     ),
    //     badgeAnimation: const Badges.BadgeAnimation.fade(
    //       // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
    //       // curve: Curves.easeInCubic,
    //     ),
    //     badgeContent: Container(
    //       width: 8,
    //       height: 10,
    //       alignment: Alignment.center,
    //       child: Text(count,
    //           style: const TextStyle(
    //               fontWeight: FontWeight.bold,
    //               fontSize: 8,
    //               color: Colors.white)
    //       ),
    //     ),
    //   );
    // }

    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
                  child: GestureDetector(
                    onTap: () {
                      // interface.accountsDialogPagesController.animateToPage(interface.dialogCurrentState['pages']['description']!,
                      //     duration: const Duration(milliseconds: 300), curve: Curves.ease);
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                      width: innerPaddingWidth,
                      decoration: materialMainBoxDecoration,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('General information:', style: DodaoTheme.of(context).bodyText2,),
                          Text(
                            widget.account.nickName.isNotEmpty ? widget.account.nickName : 'Nameless',
                            style: DodaoTheme.of(context).bodyText3,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            widget.account.about.isNotEmpty ? widget.account.about : 'About info not filled',
                            style: DodaoTheme.of(context).bodyText3,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            widget.account.walletAddress.toString(),
                            style: DodaoTheme.of(context).bodyText3,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      )
                    ),
                  ),
                ),

                /////// Activities:
                Container(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Material(
                    elevation: DodaoTheme.of(context).elevation,
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    child: GestureDetector(
                      onTap: () {
                        // interface.accountsDialogPagesController.animateToPage(interface.dialogCurrentState['pages']['description']!,
                        //     duration: const Duration(milliseconds: 300), curve: Curves.ease);
                      },
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                          width: innerPaddingWidth,
                          decoration: materialMainBoxDecoration,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Activities:', style: DodaoTheme.of(context).bodyText2,),

                              SizedBox(
                                height: 80,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        children: [
                                          BadgeSmallColored(count: widget.account.customerTasks.length, color: Colors.lightBlue,),
                                          Text(
                                            ' - Created ',
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
                                          BadgeSmallColored(count: widget.account.participantTasks.length, color: Colors.amber,),
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
                                          BadgeSmallColored(count: widget.account.auditParticipantTasks.length, color: Colors.redAccent,),
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

                                  ],
                                ),
                              )
                            ],
                          )
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
                    child: GestureDetector(
                      onTap: () {
                        // interface.accountsDialogPagesController.animateToPage(interface.dialogCurrentState['pages']['description']!,
                        //     duration: const Duration(milliseconds: 300), curve: Curves.ease);
                      },
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                          width: innerPaddingWidth,
                          decoration: materialMainBoxDecoration,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Scores:', style: DodaoTheme.of(context).bodyText2,),
                              Container(
                                height: 55,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        children: [
                                          BadgeSmallColored(count: widget.account.customerRating.length, color: Colors.deepPurpleAccent,),
                                          Text(
                                            ' - Customer rating ',
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
                                          BadgeSmallColored(count: widget.account.performerRating.length, color: Colors.deepPurple,),
                                          Text(
                                            ' - Performer rating',
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
                          )
                      ),
                    ),
                  ),
                ),


                /////// Last activities:
                Container(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Material(
                    color:  DodaoTheme.of(context).taskBackgroundColor,
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
                            Text('Last Activities:', style: DodaoTheme.of(context).bodyText2,),
                            Builder(
                              builder: (context) {
                                // Collect paddings of all participant addresses
                                const double participantPaddingSize = 0.0;
                                const double doubledPaddingSize = participantPaddingSize * 2;
                                late double heightOfAllParticipant = (interface.tileHeight + doubledPaddingSize) * (
                                    widget.account.participantTasks.length + widget.account.customerTasks.length + widget.account.auditParticipantTasks.length);

                                // If address LIST empty set default height:
                                if (widget.account.participantTasks.length + widget.account.customerTasks.length + widget.account.auditParticipantTasks.length == 0) {
                                  heightOfAllParticipant = 55;
                                }
                                return SizedBox(
                                  // height: heightOfAllParticipant,
                                  child: LastActivitiesList(
                                    account: widget.account,
                                  ),
                                );
                              }
                            )
                          ],
                        )
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
        // padding: keyboardSize == 0 ? const EdgeInsets.only(left: 40.0, right: 28.0) : const EdgeInsets.only(right: 14.0),
        padding: const EdgeInsets.only(right: 13, left: 46),
        child: tasksServices.roleNfts['governor'] > 0 ? SetsOfFabButtonsForAccountDialog(account: widget.account, accountRole: widget.accountRole) : null,
      ),
    );
  }
}
