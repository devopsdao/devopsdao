import 'package:badges/badges.dart';
import 'package:devopsdao/blockchain/task.dart';
import 'package:devopsdao/custom_widgets/wallet_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';

class ParticipantList extends StatefulWidget {
  final String listType;
  final Task obj;

  const ParticipantList({Key? key, required this.obj, required this.listType})
      : super(key: key);

  @override
  _ParticipantListState createState() => _ParticipantListState();
}

class _ParticipantListState extends State<ParticipantList> {
  bool _buttonState = false;

  late List participants;
  late String status;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    if (widget.listType == 'customer') {
      if (widget.obj.participants != null)
        participants = widget.obj.participants;
      else {
        participants = [];
      }
      status = 'agreed';
    } else if (widget.listType == 'audit') {
      participants = widget.obj.auditors;
      status = 'audit';
    }

    return Container(
      height: 100.0, // Change as per your requirement
      width: 240.0, // Change as per your requirement
      child: ListView.builder(
          // padding: EdgeInsets.zero,
          // scrollDirection: Axis.vertical,
          // shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          itemCount: participants.length,
          itemBuilder: (context2, index2) {
            return Column(children: [
              // Text(
              //   tasksServices.tasksOwner[index].participants[index2].toString(),
              //   style: FlutterFlowTheme.of(
              //       context2)
              //       .bodyText2,
              // ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 13),
                ),
                onPressed: () {
                  setState(() {
                    widget.obj.justLoaded = false;
                  });
                  tasksServices.taskStateChange(widget.obj.taskAddress,
                      participants[index2], status, widget.obj.nanoId);
                  Navigator.pop(context);

                  showDialog(
                      context: context,
                      builder: (context) => WalletAction(
                            nanoId: widget.obj.nanoId,
                            taskName: 'taskStateChange',
                          ));
                },
                child: Text(
                  participants[index2].toString(),
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 0.7),
                ),
              ),
            ]);
          }),
    );
  }
}
