import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:devopsdao/task_dialog/widget/dialog_button_widget.dart';
import 'package:devopsdao/task_dialog/states.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/task.dart';
import '../../blockchain/task_services.dart';
import '../../widgets/wallet_action.dart';
import '../widget/participants_list.dart';

class SelectedPage extends StatefulWidget {
  final double screenHeightSizeNoKeyboard;
  final double innerWidth;
  final Task task;


  const SelectedPage(
      {Key? key,
        required this.screenHeightSizeNoKeyboard,
        required this.innerWidth,
        required this.task,
      })
      : super(key: key);

  @override
  _SelectedPageState createState() => _SelectedPageState();
}

class _SelectedPageState extends State<SelectedPage> {


  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    final double innerWidth = widget.innerWidth;
    final Task task = widget.task;

    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: interface.maxInternalDialogWidth,
            maxHeight: widget.screenHeightSizeNoKeyboard,
            // maxHeight: widget.screenHeightSize
          ),
          child: SizedBox(
            width: innerWidth,
            child: Column(
              children: [
                ListBody(
                  children: <Widget>[
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(interface.borderRadius),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
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
                            ParticipantList(
                              task: task,
                            ),

                          ],
                        ),
                      ),
                    ),
                    if(interface.selectedUser['address'] != null)

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 0.0),
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(interface.borderRadius),
                          child: Container(

                            padding: const EdgeInsets.all(14),
                            child: Column(
                              children: [
                                Container(

                                  alignment: Alignment.topLeft,
                                  child: RichText(

                                      text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .apply(fontSizeFactor: 1.0),
                                          children: <TextSpan>[
                                            const TextSpan(
                                                text: 'Some information about ',
                                                style: TextStyle(
                                                  height: 1,
                                                )),
                                            TextSpan(
                                                text: '${interface.selectedUser['address']}',
                                                style: const TextStyle(
                                                    height: 1,
                                                    fontSize: 9,
                                                    backgroundColor: Colors.black12
                                                )),
                                            const TextSpan(
                                                text: ' will goes here ',
                                                style: TextStyle(
                                                  height: 1,
                                                )),
                                          ])),

                                ),

                              ],
                            ),
                          ),
                        ),
                      ),



                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 16.0),
                  width: innerWidth + 8,
                  child: Row(
                    // direction: Axis.horizontal,
                    // crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      TaskDialogButton(
                        // padding: 8.0,
                        inactive: interface.selectedUser['address'] == null ? true : false,
                        buttonName: interface.dialogCurrentState['selectButtonName'] ?? 'null: no name',
                        buttonColorRequired: Colors.lightBlue.shade600,
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
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}