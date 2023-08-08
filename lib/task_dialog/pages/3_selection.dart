import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:dodao/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dodao/task_dialog/widget/dialog_button_widget.dart';
import 'package:dodao/task_dialog/states.dart';
import 'package:webthree/credentials.dart';

import '../../account_dialog/account_transition_effect.dart';
import '../../blockchain/empty_classes.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/notify_listener.dart';
import '../../blockchain/task_services.dart';
import '../../widgets/badge-small-colored.dart';
import '../../widgets/my_tools.dart';
import '../../widgets/wallet_action_dialog.dart';
import '../contractor_info.dart';
import '../widget/participants_list.dart';

class SelectionPage extends StatefulWidget {
  final double screenHeightSize;
  final double innerPaddingWidth;
  final Task task;

  const SelectionPage({
    Key? key,
    required this.screenHeightSize,
    required this.innerPaddingWidth,
    required this.task,
  }) : super(key: key);

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  ScrollController? selectionScrollController;
  // final selectionScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectionScrollController = ScrollController();
  }

  @override
  void dispose() {
    selectionScrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var myNotifyListener = context.watch<MyNotifyListener>();
    var tasksServices = context.watch<TasksServices>();
    var interface = context.read<InterfaceServices>();
    var emptyClasses = context.read<EmptyClasses>();
    final double innerPaddingWidth = widget.innerPaddingWidth;
    final Task task = widget.task;
    final double participantPaddingSize = 2.0;



    final Widget contractorList = Material(
      elevation: DodaoTheme.of(context).elevation,
      borderRadius: DodaoTheme.of(context).borderRadius,
      child: Container(
        decoration: BoxDecoration(
          // color:  Color(0xFFF8F8F8),
          // color: DodaoTheme.of(context).walletBackgroundColor,
          borderRadius: DodaoTheme.of(context).borderRadius,
          border: DodaoTheme.of(context).borderGradient,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                // color: DodaoTheme.of(context).walletBackgroundColor,
                borderRadius: DodaoTheme.of(context).borderRadius,
                // borderRadius: BorderRadius.all(Radius.circular(6.0)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 1),
                    alignment: Alignment.topLeft,
                    child: RichText(
                        text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: <TextSpan>[
                      TextSpan(text: 'Choose contractor: ', style: Theme.of(context).textTheme.bodySmall),
                    ])),
                  ),
                  if (task.participants.isEmpty && interface.dialogCurrentState['name'] == 'customer-new')
                    RichText(
                        text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: const <TextSpan>[
                      TextSpan(
                          text: 'Participants not applied to your Task yet. ',
                          style: TextStyle(
                            height: 4.5,
                          )),
                    ])),
                  if (task.auditors.isEmpty &&
                      (interface.dialogCurrentState['name'] == 'customer-audit-requested' ||
                          interface.dialogCurrentState['name'] == 'performer-audit-requested'))
                    RichText(
                        text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: const <TextSpan>[
                      TextSpan(
                          text: 'Auditors not applied to your request yet. ',
                          style: TextStyle(
                            height: 4.5,
                          )),
                    ])),
                ],
              ),
            ),
            Expanded(
              child: ParticipantList(
                task: task,
              ),
            ),
          ],
        ),
      ),
    );

    // final Widget contractorInfo = Column(
    //   children: [
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         const SizedBox(
    //           width: 20,
    //         ),
    //         RichText(
    //             maxLines: 10,
    //             softWrap: true,
    //             text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: <TextSpan>[
    //               TextSpan(
    //                   text: interface.selectedUser.nickName.isNotEmpty ? interface.selectedUser.nickName : 'Nameless'),
    //             ])),
    //         InkWell(
    //           onTap: () {
    //             setState(() {
    //               interface.selectedUser = emptyClasses.emptyAccount; // reset
    //             });
    //           },
    //           borderRadius: BorderRadius.circular(16),
    //           child: Container(
    //             padding: const EdgeInsets.all(0.0),
    //             height: 18,
    //             width: 20,
    //             child: const Row(
    //               children: <Widget>[
    //                 Expanded(
    //                   child: Icon(
    //                     Icons.close,
    //                     size: 18,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //     Row(
    //       children: [
    //         Container(
    //           // padding: const EdgeInsets.only(right: 14),
    //           width: 100,
    //           height: 100,
    //           decoration: BoxDecoration(
    //             image: const DecorationImage(
    //               image: AssetImage("assets/images/logo.png"),
    //               fit: BoxFit.scaleDown,
    //               alignment: Alignment.bottomRight,
    //             ),
    //             borderRadius: DodaoTheme.of(context).borderRadius,
    //           ),
    //         ),
    //         Container(
    //           width: 14,
    //         ),
    //
    //         Flexible(
    //           child: Row(
    //             children: [
    //               Column(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Row(
    //                     children: [
    //                       Padding(
    //                         padding: EdgeInsets.all(participantPaddingSize),
    //                         child: BadgeSmallColored(count: interface.selectedUser.customerTasks.length, color: Colors.lightBlue,),
    //                       ),
    //                       Text(
    //                         'Created',
    //                         style: DodaoTheme.of(context).bodyText3,
    //                         softWrap: false,
    //                         overflow: TextOverflow.ellipsis,
    //                         maxLines: 1,
    //                       ),
    //
    //                     ],
    //                   ),
    //                   Row(
    //                     children: [
    //                       Padding(
    //                         padding: EdgeInsets.all(participantPaddingSize),
    //                         child: BadgeSmallColored(count: interface.selectedUser.participantTasks.length, color: Colors.amber,),
    //                       ),
    //                       Text(
    //                         'Participated',
    //                         style: DodaoTheme.of(context).bodyText3,
    //                         softWrap: false,
    //                         overflow: TextOverflow.ellipsis,
    //                         maxLines: 1,
    //                       ),
    //                     ],
    //                   ),
    //                   Row(
    //                     children: [
    //                       Padding(
    //                         padding: EdgeInsets.all(participantPaddingSize),
    //                         child: BadgeSmallColored(count: interface.selectedUser.auditParticipantTasks.length, color: Colors.redAccent,),
    //                       ),
    //                       Text(
    //                         'Audit requested',
    //                         style: DodaoTheme.of(context).bodyText3,
    //                         softWrap: false,
    //                         overflow: TextOverflow.ellipsis,
    //                         maxLines: 1,
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //               const Spacer(),
    //               Column(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children: [
    //                   Row(
    //                     children: [
    //                       Padding(
    //                         padding: EdgeInsets.all(participantPaddingSize),
    //                         child: BadgeSmallColored(count: interface.selectedUser.customerRating.length, color: Colors.deepPurpleAccent,),
    //                       ),
    //                       Text(
    //                         'Customer rating',
    //                         style: DodaoTheme.of(context).bodyText3,
    //                         softWrap: false,
    //                         overflow: TextOverflow.ellipsis,
    //                         maxLines: 1,
    //                       ),
    //
    //                     ],
    //                   ),
    //                   Row(
    //                     children: [
    //                       Padding(
    //                         padding: EdgeInsets.all(participantPaddingSize),
    //                         child: BadgeSmallColored(count:interface.selectedUser.performerRating.length, color: Colors.deepPurple,),
    //                       ),
    //                       Text(
    //                         'Performer rating',
    //                         style: DodaoTheme.of(context).bodyText3,
    //                         softWrap: false,
    //                         overflow: TextOverflow.ellipsis,
    //                         maxLines: 1,
    //                       ),
    //
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //               const Spacer(),
    //             ],
    //           ),
    //         )
    //       ],
    //     ),
    //     RichText(
    //         maxLines: 10,
    //         softWrap: true,
    //         text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: <TextSpan>[
    //           TextSpan(text: '${interface.selectedUser.walletAddress}', style: Theme.of(context).textTheme.bodySmall),
    //         ])
    //     )
    //   ],
    // );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: DodaoTheme.of(context).taskBackgroundColor,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 5.0),
          width: innerPaddingWidth,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: interface.maxStaticInternalDialogWidth,
              maxHeight: widget.screenHeightSize,
              // minHeight: widget.screenHeightSize
            ),
            child: Column(
              children: [
                Builder(builder: (context) {
                  final bool accountSelected = interface.selectedUser.walletAddress != EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');
                  // Collect paddings of all participant addresses
                  final double doubledPaddingSize = participantPaddingSize * 2;
                  late double screenLayoutHeight = widget.screenHeightSize - MediaQuery.of(context).viewPadding.top - 106; // minus mobile statusbar and set space for button
                  late double participantInfoHeight = 0;
                  // Collect entire height for all participant:
                  late double heightOfAllParticipant = (interface.tileHeight + doubledPaddingSize) * (task.participants.length + 1);

                  // change participant info panel height if account selected
                  if (accountSelected) {
                    participantInfoHeight = interface.participantInfoHeight;
                  }
                  // If address LIST doesn't take up the entire height set height for those addresses:
                  if (screenLayoutHeight < heightOfAllParticipant + participantInfoHeight) {
                    if (accountSelected) {
                      heightOfAllParticipant = screenLayoutHeight - participantInfoHeight;
                    } else {
                      heightOfAllParticipant = screenLayoutHeight;
                    }
                  }
                  // If address LIST empty set default height:
                  if (task.participants.isEmpty) {
                    heightOfAllParticipant = 90;
                  }
                  //
                  // print('heightOfAllParticipant: $heightOfAllParticipant');
                  // print('screenLayoutHeight: $screenLayoutHeight');
                  // // print('screenLayoutHeightLeft: $screenLayoutHeightLeft');
                  // print('widget.screenHeightSize: ${widget.screenHeightSize}');
                  // print('task.participants.length: ${task.participants.length}');

                  return Column(
                    children: <Widget>[
                      Builder(builder: (context) {
                        // print('ofset' + selectionScrollController!.offset.toString());

                        return AnimatedContainer(
                          // color: Colors.amber,
                          duration: const Duration(milliseconds:250),
                          height: heightOfAllParticipant,
                          curve: Curves.fastOutSlowIn,
                          child: contractorList,
                        );
                      }),
                      const Padding(padding: EdgeInsets.only(top: 14.0)),
                      AnimatedContainer(
                        // color: Colors.amber,
                        duration: const Duration(milliseconds: 200),
                        height: accountSelected ? participantInfoHeight : 0,
                        width: accountSelected ? widget.innerPaddingWidth : 0,
                        child: Container(
                          alignment: Alignment.center,
                          child: ExpandInformation(
                            expand: accountSelected,
                            child: Material(
                              elevation: 10,
                              borderRadius: DodaoTheme.of(context).borderRadius,
                              child: Container(
                                decoration: BoxDecoration(
                                  // gradient: DodaoTheme.of(context).smallButtonGradient,
                                  borderRadius: DodaoTheme.of(context).borderRadius,
                                  border: DodaoTheme.of(context).borderGradient,
                                ),
                                height: participantInfoHeight,
                                // padding: const EdgeInsets.all(14),
                                // child: const ContractorInfo(),
                                child: const ClickOnAccount(index: 0,
                                )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                const Spacer(),
                const SizedBox(
                  height: 65,
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonAnimator: NoScalingAnimation(),
      floatingActionButton: Padding(
        // padding: keyboardSize == 0 ? const EdgeInsets.only(left: 40.0, right: 28.0) : const EdgeInsets.only(right: 14.0),
        padding: const EdgeInsets.only(right: 13, left: 46),
        child: TaskDialogFAB(
          inactive: interface.selectedUser.walletAddress == EthereumAddress.fromHex('0x0000000000000000000000000000000000000000') ? true : false,
          expand: true,
          buttonName: interface.dialogCurrentState['selectButtonName'] ?? 'null: no name',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: MediaQuery.of(context).viewInsets.bottom == 0 ? 600 : 120, // Keyboard shown?
          callback: () {
            setState(() {
              task.loadingIndicator = true;
            });
            late String status;
            if (interface.dialogCurrentState['name'] == 'customer-new') {
              status = 'agreed';
            } else if (interface.dialogCurrentState['name'] == 'performer-audit-requested' ||
                interface.dialogCurrentState['name'] == 'customer-audit-requested') {
              status = 'audit';
            }
            tasksServices.taskStateChange(task.taskAddress, EthereumAddress.fromHex(interface.selectedUser.walletAddress.toString()), status, task.nanoId);
            interface.selectedUser = emptyClasses.emptyAccount; // reset
            Navigator.pop(context);
            interface.emptyTaskMessage();
            RouteInformation routeInfo = const RouteInformation(location: '/customer');
            Beamer.of(context).updateRouteInformation(routeInfo);

            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                      nanoId: task.nanoId,
                      taskName: 'taskStateChange',
                    ));
          },
        ),
      ),
    );
  }
}

class ExpandInformation extends StatefulWidget {
  final Widget child;
  final bool expand;
  const ExpandInformation({super.key, this.expand = false, required this.child});

  @override
  _ExpandInformationState createState() => _ExpandInformationState();
}

class _ExpandInformationState extends State<ExpandInformation> with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  void prepareAnimations() {
    expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      // value: 0.0,
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.easeInOutQuint,
    );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      Future.delayed(const Duration(milliseconds: 50), () {
        expandController.forward();
      });
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandInformation oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
        // axisAlignment: 20.5,
        scale: animation,
        child: widget.child);
  }
}
