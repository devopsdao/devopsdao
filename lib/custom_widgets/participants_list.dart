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

  const ParticipantList({Key? key, required this.obj, required this.listType}) : super(key: key);

  @override
  _ParticipantListState createState() => _ParticipantListState();
}

class _ParticipantListState extends State<ParticipantList> {
  bool _buttonState = false;

  late List contributorsList;
  late String status;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    if (widget.listType == 'submitter') {
      contributorsList = widget.obj.contributors;
      status = 'agreed';
    } else if(widget.listType == 'audit') {
      contributorsList = widget.obj.auditContributors;
      status = 'audit';
    }

    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
          // padding: EdgeInsets.zero,
          // scrollDirection: Axis.vertical,
          // shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          itemCount: contributorsList.length,
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
                    widget.obj.justLoaded = false;
                  });
                  tasksServices.changeTaskStatus(
                      widget.obj.contractAddress,
                      contributorsList[index2],
                      status,
                      widget.obj.nanoId);
                  Navigator.pop(context);

                  showDialog(
                      context: context,
                      builder: (context) => WalletAction(
                            nanoId: widget.obj.nanoId,
                            taskName: 'changeTaskStatus',
                          ));
                },
                child: Text(
                  contributorsList[index2].toString(),
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
