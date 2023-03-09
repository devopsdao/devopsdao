import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devopsdao/task_dialog/widget/dialog_button_widget.dart';
import 'package:devopsdao/task_dialog/states.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../widgets/my_tools.dart';
import '../../widgets/wallet_action.dart';
import '../widget/participants_list.dart';

class SelectionPage extends StatefulWidget {
  final double screenHeightSize;
  final double innerPaddingWidth;
  final Task task;


  const SelectionPage(
      {Key? key,
        required this.screenHeightSize,
        required this.innerPaddingWidth,
        required this.task,
      })
      : super(key: key);

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
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    final double innerPaddingWidth = widget.innerPaddingWidth;
    final Task task = widget.task;

    late double heightForInfo = 0;

    final Widget contractorList = Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(interface.borderRadius),
      child: Container(
        decoration: const BoxDecoration(
          // color:  Color(0xFFF8F8F8),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color:  Color(0xFFF8F8F8),
                borderRadius: BorderRadius.all(
                   Radius.circular(8.0),
                  // topLeft: Radius.circular(8.0),
                ),
                // borderRadius: BorderRadius.all(Radius.circular(6.0)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    child: RichText(
                        text: TextSpan(
                            style: DefaultTextStyle.of(context)
                                .style
                                .apply(fontSizeFactor: 1.0),
                            children: const <TextSpan>[
                              TextSpan(
                                  text: 'Choose contractor: ',
                                  style: TextStyle(
                                      height: 1,
                                      fontWeight: FontWeight.bold)),
                            ])),
                  ),
                  if (task.participants.isEmpty &&
                      interface.dialogCurrentState['name'] == 'customer-new')
                    RichText(
                        text: TextSpan(
                            style: DefaultTextStyle.of(context)
                                .style
                                .apply(fontSizeFactor: 1.0),
                            children: const <TextSpan>[
                              TextSpan(
                                  text: 'Participants not applied to your Task yet. ',
                                  style: TextStyle(
                                    height: 2,)),
                            ])),
                  if (task.auditors.isEmpty && (
                      interface.dialogCurrentState['name'] == 'customer-audit-requested' ||
                          interface.dialogCurrentState['name'] == 'performer-audit-requested'
                  ))
                    RichText(
                        text: TextSpan(
                            style: DefaultTextStyle.of(context)
                                .style
                                .apply(fontSizeFactor: 1.0),
                            children: const <TextSpan>[
                              TextSpan(
                                  text: 'Auditors not applied to your request yet. ',
                                  style: TextStyle(
                                    height: 2,)),
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


    final Widget contractorInfo = Column(
      children: [
        Row(
          children: [
            Container(
              // padding: const EdgeInsets.only(right: 14),
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomRight
                ),
              ),
            ),
            Container(
              width: 14,
            ),
            Flexible(
              child: RichText(
                  maxLines: 10,
                  softWrap: true,
                  text: TextSpan(
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 1.0),
                      children: <TextSpan>[
                        TextSpan(
                            text: '${interface.selectedUser['address']} \n \n',
                            style: const TextStyle(
                                height: 1,
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                                // backgroundColor: Colors.black12
                            )),
                        const TextSpan(
                            text: 'Wallet nickname \n',
                            style: TextStyle(
                              height: 1,
                            )),
                        const TextSpan(
                            text: 'Scores \n\n',
                            style: TextStyle(
                              height: 1,
                            )),
                        const TextSpan(
                            text: 'And other information about this wallet',
                            style: TextStyle(
                              height: 1,
                            )),

                        const TextSpan(
                            text: ' will goes here ',
                            style: TextStyle(
                              height: 1,
                            )),
                      ])),

            )
          ],
        ),

      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                Builder(
                  builder: (context) {
                    final bool walletSelected = interface.selectedUser['address'] != null ? true : false;
                    late double layoutHeight =
                        widget.screenHeightSize - MediaQuery.of(context).viewPadding.top - 100; // minus mobile statusbar
                    // Set height for INFO panel if address selected:
                    if (walletSelected) {
                      heightForInfo = interface.heightForInfo;
                    }
                    // Set height for address LIST when address selected:
                    late double heightLeft = layoutHeight - heightForInfo;
                    // If address LIST empty set default height:
                    if (task.participants.isEmpty) {
                      layoutHeight = 90;
                    }
                    // Collect entire height for all addresses:
                    final double heightOfAllParticipant = interface.tileHeight * task.participants.length;
                    // If address LIST doesn't take up the entire height set height for those addresses:
                    if (layoutHeight > heightOfAllParticipant && task.participants.isNotEmpty) {
                      layoutHeight = heightOfAllParticipant + 42;
                      heightLeft = layoutHeight;
                    }
                    //
                    // print('heightOfAllParticipant: $heightOfAllParticipant');
                    // print('layoutHeight: $layoutHeight');
                    // print('task.participants.length: ${task.participants.length}');

                    return Column(
                      children: <Widget>[
                        Builder(
                          builder: (context) {
                            // print('ofset' + selectionScrollController!.offset.toString());

                            return AnimatedContainer(
                              // color: Colors.amber,
                              duration:  const Duration(milliseconds: 300),
                              height: walletSelected ? heightLeft : layoutHeight,
                              curve: Curves.fastOutSlowIn,
                              child: contractorList,
                            );
                          }
                        ),
                        const Padding(padding: EdgeInsets.only(top: 14.0)),
                        // if(interface.selectedUser['address'] != null)
                          AnimatedContainer(
                            // color: Colors.amber,
                            duration:  const Duration(milliseconds: 50),
                            height: walletSelected ? heightForInfo : 0,
                            width: walletSelected ? widget.innerPaddingWidth : 0,
                            child: Container(
                              alignment: Alignment.center,
                              child:  ExpandInformation(
                                expand: walletSelected,
                                child: Material(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(interface.borderRadius),
                                  child: Container(
                                    height: heightForInfo,
                                    padding: const EdgeInsets.all(14),
                                    child: contractorInfo,
                                  ),
                                ),
                              ),
                            ),
                          // AnimatedSize(
                          //   curve: Curves.easeIn,
                          //   duration: const Duration(milliseconds: 1500),
                          //   child: SizedBox(
                          //     height: interface.selectedUser['address'] != null ? heightForInfo : 0,
                          //     child: contractorInfo
                          //   )
                          // )
                        ),
                      ],
                    );
                  }
                ),
                const Spacer(),
                // Container(
                //   padding: const EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 16.0),
                //   width: innerPaddingWidth + 8,
                //   child: Row(
                //     // direction: Axis.horizontal,
                //     // crossAxisAlignment: WrapCrossAlignment.start,
                //     children: [
                //       TaskDialogButton(
                //         // padding: 8.0,
                //         inactive: interface.selectedUser['address'] == null ? true : false,
                //         buttonName: interface.dialogCurrentState['selectButtonName'] ?? 'null: no name',
                //         buttonColorRequired: Colors.lightBlue.shade600,
                //         callback: () {
                //           setState(() {
                //             task.justLoaded = false;
                //           });
                //           late String status;
                //           if (interface.dialogCurrentState['name'] == 'customer-new') {
                //             status = 'agreed';
                //           } else if (
                //             interface.dialogCurrentState['name'] == 'performer-audit-requested' ||
                //             interface.dialogCurrentState['name'] == 'customer-audit-requested'
                //           ) {
                //             status = 'audit';
                //           }
                //           tasksServices.taskStateChange(task.taskAddress,
                //               EthereumAddress.fromHex(interface.selectedUser['address']!), status, task.nanoId);
                //           interface.selectedUser = {}; // reset
                //           Navigator.pop(context);
                //           interface.emptyTaskMessage();
                //           RouteInformation routeInfo =
                //             const RouteInformation(location: '/customer');
                //           Beamer.of(context).updateRouteInformation(routeInfo);
                //
                //           showDialog(
                //             context: context,
                //             builder: (context) => WalletAction(
                //               nanoId: task.nanoId,
                //               taskName: 'taskStateChange',
                //             )
                //           );
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 65,
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonAnimator:  NoScalingAnimation(),
      floatingActionButton: Padding(
        // padding: keyboardSize == 0 ? const EdgeInsets.only(left: 40.0, right: 28.0) : const EdgeInsets.only(right: 14.0),
        padding: const EdgeInsets.only(right: 13, left: 46),
        child: TaskDialogFAB(
          inactive: interface.selectedUser['address'] == null ? true : false,
          expand: true,
          buttonName: interface.dialogCurrentState['selectButtonName'] ?? 'null: no name',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: MediaQuery.of(context).viewInsets.bottom == 0 ? 600 : 120, // Keyboard shown?
          callback: () {
            setState(() {
              task.justLoaded = false;
            });
            late String status;
            if (interface.dialogCurrentState['name'] == 'customer-new') {
              status = 'agreed';
            } else if (
            interface.dialogCurrentState['name'] == 'performer-audit-requested' ||
                interface.dialogCurrentState['name'] == 'customer-audit-requested'
            ) {
              status = 'audit';
            }
            tasksServices.taskStateChange(task.taskAddress,
                EthereumAddress.fromHex(interface.selectedUser['address']!), status, task.nanoId);
            interface.selectedUser = {}; // reset
            Navigator.pop(context);
            interface.emptyTaskMessage();
            RouteInformation routeInfo =
            const RouteInformation(location: '/customer');
            Beamer.of(context).updateRouteInformation(routeInfo);

            showDialog(
                context: context,
                builder: (context) => WalletAction(
                  nanoId: task.nanoId,
                  taskName: 'taskStateChange',
                )
            );
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
    if(widget.expand) {
      Future.delayed(
          const Duration(milliseconds: 50),
              () {
            expandController.forward();
          });
    }
    else {
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
        child: widget.child
    );
  }
}



