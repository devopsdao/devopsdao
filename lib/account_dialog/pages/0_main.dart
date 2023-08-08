import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../blockchain/accounts.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../widgets/badge-small-colored.dart';
import '../../widgets/my_tools.dart';
import '../../widgets/payment.dart';
import '../../widgets/tags/search_services.dart';
import '../../widgets/tags/wrapped_chip.dart';
import '../../widgets/wallet_action_dialog.dart';
import '../widget/dialog_button_widget.dart';

import 'package:badges/badges.dart' as Badges;

import 'dart:ui' as ui;

class AccountMainPage extends StatefulWidget {
  final double screenHeightSizeNoKeyboard;
  final double innerPaddingWidth;
  final double screenHeightSize;
  final Account account;

  const AccountMainPage({
    Key? key,
    required this.screenHeightSizeNoKeyboard,
    required this.innerPaddingWidth,
    required this.screenHeightSize,
    required this.account,
  }) : super(key: key);

  @override
  _AccountMainPageState createState() => _AccountMainPageState();
}

class _AccountMainPageState extends State<AccountMainPage> {
  TextEditingController? messageForStateController;

  @override
  void initState() {
    super.initState();
    messageForStateController = TextEditingController();
  }

  @override
  void dispose() {
    messageForStateController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    final double maxStaticInternalDialogWidth = interface.maxStaticInternalDialogWidth;
    final double innerPaddingWidth = widget.innerPaddingWidth;

    final BoxDecoration materialMainBoxDecoration = BoxDecoration(
      borderRadius: DodaoTheme.of(context).borderRadius,
      border: DodaoTheme.of(context).borderGradient,
    );


    //here we save the values, so that they are not lost when we go to other pages, they will reset on close or topup button:
    messageForStateController!.text = interface.taskMessage;


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
      resizeToAvoidBottomInset: false,
      backgroundColor: DodaoTheme.of(context).taskBackgroundColor,
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 5.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxStaticInternalDialogWidth,
          ),
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
                    padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
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
                        padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
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
                                          ' - Created: ',
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
                        padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
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
                                          ' - Customer rating: ',
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
                                          ' - Performer rating: ',
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
            ],
          ),
        ),
      ),
      floatingActionButtonAnimator: NoScalingAnimation(),
      floatingActionButton: Padding(
        // padding: keyboardSize == 0 ? const EdgeInsets.only(left: 40.0, right: 28.0) : const EdgeInsets.only(right: 14.0),
        padding: const EdgeInsets.only(right: 13, left: 46),
        child: TaskDialogFAB(
          inactive: true,
          expand: true,
          buttonName: 'Do we need actions here?',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: MediaQuery.of(context).viewInsets.bottom == 0 ? 600 : 160, // Keyboard shown?
          callback: () {
            // tasksServices.addTokens(
            //   task.taskAddress,
            //   interface.tokensEntered, task.nanoId,
            //   // message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
            // );
            // Navigator.pop(context);
            // interface.emptyTaskMessage();
            //
            // showDialog(
            //     context: context,
            //     builder: (context) => WalletActionDialog(
            //       nanoId: task.nanoId,
            //       taskName: 'addTokens',
            //     ));
          },
        ),
      ),
    );
  }
}
