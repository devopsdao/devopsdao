import 'package:devopsdao/blockchain/task.dart';
import 'package:devopsdao/widgets/wallet_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/task_services.dart';

class ParticipantList extends StatefulWidget {
  final Task task;

  const ParticipantList({Key? key, required this.task,})
      : super(key: key);

  @override
  _ParticipantListState createState() => _ParticipantListState();
}

class _ParticipantListState extends State<ParticipantList> {
  late List participants;
  late String status;
  late int selectedIndex = 99;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();



    if (interface.dialogCurrentState['name'] == 'customer-new') {
      if (widget.task.participants != null) {
        participants = widget.task.participants;
      } else {
        participants = [];
      }
    } else if (
        interface.dialogCurrentState['name'] == 'customer-audit-requested' ||
        interface.dialogCurrentState['name'] == 'performer-audit-requested') {
      participants = widget.task.auditors;
    }
    print(selectedIndex);

    return ListView.builder(
        shrinkWrap: true,
        // padding: EdgeInsets.zero,
        // scrollDirection: Axis.vertical,
        // physics: NeverScrollableScrollPhysics(),
        itemCount: participants.length,
        itemBuilder: (context2, index2) {
          return ListTile(
            title: Center(
              child: RichText(
                  text: TextSpan(
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 0.9),
                      children: <TextSpan>[
                        TextSpan(
                            text: participants[index2].toString(),
                            style: const TextStyle(
                              height: 1,)),
                      ])),
            ),
            // style: TextButton.styleFrom(
            //   textStyle: const TextStyle(fontSize: 13),
            // ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            visualDensity: const VisualDensity(vertical: -3),
            dense: true,
            selected: index2 == selectedIndex,
            // selectedColor: Colors.green,
            selectedTileColor: Colors.black26,
            // trailing: const Icon(
            //   Icons.info_sharp,
            //   color: Colors.black45,
            //   size: 20,
            // ),
            onTap: () {
              setState(() {
                selectedIndex = index2;
                interface.selectedUser = {
                  'address' : participants[index2].toString()
                };
              });
              tasksServices.myNotifyListeners();
              // tasksServices.taskStateChange(widget.task.taskAddress,
              //     participants[index2], status, widget.task.nanoId);
              // Navigator.pop(context);
              // RouteInformation routeInfo =
              //     const RouteInformation(location: '/customer');
              // Beamer.of(context).updateRouteInformation(routeInfo);
              //
              // showDialog(
              //     context: context,
              //     builder: (context) => WalletAction(
              //           nanoId: widget.task.nanoId,
              //           taskName: 'taskStateChange',
              //         ));
            },
            // child: Text(
            //   participants[index2].toString(),
            //   style: DefaultTextStyle.of(context)
            //       .style
            //       .apply(fontSizeFactor: 0.7),
            // ),
          );
        });
  }
}