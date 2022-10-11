import 'package:badges/badges.dart';
import 'package:devopsdao/blockchain/task.dart';
import 'package:devopsdao/custom_widgets/wallet_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';

class ParticipantList extends StatefulWidget {
  final Task object;

  const ParticipantList({Key? key, required this.object}) : super(key: key);

  @override
  _ParticipantListState createState() => _ParticipantListState();
}

class _ParticipantListState extends State<ParticipantList> {
  bool _buttonState = false;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();

    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
          // padding: EdgeInsets.zero,
          // scrollDirection: Axis.vertical,
          // shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          itemCount: widget.object.contributors.length,
          itemBuilder: (context2, index2) {
            return Column(children: [
              // Text(
              //   tasksServices.tasksOwner[index].contributors[index2].toString(),
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
                    widget.object.justLoaded = false;
                  });
                  tasksServices.changeTaskStatus(
                      widget.object.contractAddress,
                      widget.object.contributors[index2],
                      'agreed',
                      widget.object.nanoId);
                  Navigator.pop(context);

                  showDialog(
                      context: context,
                      builder: (context) => WalletAction(
                            nanoId: widget.object.nanoId,
                            taskName: 'changeTaskStatus',
                          ));
                },
                child: Text(
                  widget.object.contributors[index2].toString(),
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
