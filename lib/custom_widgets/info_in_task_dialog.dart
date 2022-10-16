import 'package:badges/badges.dart';
import 'package:devopsdao/custom_widgets/participants_list.dart';
import 'package:devopsdao/custom_widgets/selectMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';

import 'package:devopsdao/blockchain/task_services.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';

class TaskInformationDialog extends StatefulWidget {
  // final int taskCount;
  final String role;
  final Task object;
  const TaskInformationDialog(
      {Key? key,
      // required this.taskCount,
      required this.role,
      required this.object})
      : super(key: key);

  @override
  _TaskInformationDialogState createState() => _TaskInformationDialogState();
}

class _TaskInformationDialogState extends State<TaskInformationDialog> {
  late Task task;
  bool enableRatingButton = false;
  double ratingScore = 0;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    task = widget.object;

    return ListBody(
      children: <Widget>[
        RichText(
            text: TextSpan(
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 1.0),
                children: <TextSpan>[
              const TextSpan(
                  text: 'Description: \n',
                  style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
              TextSpan(text: task.description)
            ])),
        RichText(
            text: TextSpan(
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 1.0),
                children: <TextSpan>[
              const TextSpan(
                  text: 'Contract value: \n',
                  style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: '${task.contractValue} DEV \n',
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.0)),
              TextSpan(
                  text: '${task.contractValueToken} aUSDC',
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.0))
            ])),
        RichText(
            text: TextSpan(
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 1.0),
                children: <TextSpan>[
              const TextSpan(
                  text: 'Contract owner: \n',
                  style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: task.contractOwner.toString(),
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 0.7))
            ])),
        RichText(
            text: TextSpan(
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 1.0),
                children: <TextSpan>[
              const TextSpan(
                  text: 'Contract address: \n',
                  style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: task.contractAddress.toString(),
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 0.7))
            ])),
        RichText(
            text: TextSpan(
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 1.0),
                children: <TextSpan>[
              const TextSpan(
                  text: 'Created: ',
                  style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: DateFormat('MM/dd/yyyy, hh:mm a')
                      .format(task.createdTime),
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.0))
            ])),


        // ********************** CUSTOMER ROLE ************************* //

        if (task.jobState == 'completed' && widget.role == 'customer')
          RichText(
              text: TextSpan(
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.0),
                  children: const <TextSpan>[
                TextSpan(
                    text: 'Rate the task:',
                    style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
              ])),

        if (task.jobState == 'completed' && widget.role == 'customer')
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            RatingBar.builder(
              initialRating: 4,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemSize: 30.0,
              onRatingUpdate: (rating) {
                setState(() {
                  enableRatingButton = true;
                });
                ratingScore = rating;
                tasksServices.myNotifyListeners();
              },
            ),
          ]),
        if (task.jobState == "new" && widget.role == 'customer')
          RichText(
              text: TextSpan(
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.0),
                  children: const <TextSpan>[
                    TextSpan(
                        text: 'Choose contractor: ',
                        style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
                  ])),
        if (task.jobState == "new" && widget.role == 'customer')
          ParticipantList(
            listType: 'submitter',
            obj: task,
          ),


        // ************************ PERFORMER ROLE ************************** //

        if (task.jobState == 'completed' &&
            widget.role == 'performer' &&
            (task.contractValue != 0 || task.contractValueToken != 0))
          SelectNetworkMenu(object: task),


        // ****************** PERFORMER AND CUSTOMER ROLE ******************* //
        // *************************** AUDIT ******************************** //

        if (task.jobState == "audit" && task.auditState == "requested" &&
            (widget.role == 'customer' || widget.role == 'performer'))
          RichText(
              text: TextSpan(
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.0),
                  children: const <TextSpan>[
                TextSpan(
                    text: 'Warning, this contract on Audit state \n'
                        'Please choose auditor: ',
                    style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
              ])),
        if (task.jobState == "audit" && task.auditState == "performing" &&
            (widget.role == 'customer' || widget.role == 'performer'))
          RichText(
              text: TextSpan(
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.0),
                  children: <TextSpan>[
                const TextSpan(
                    text: 'Your request is being resolved \n'
                        'Your auditor: \n',
                    style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
                TextSpan(
                    text: task.auditParticipation.toString(),
                    style: DefaultTextStyle.of(context)
                        .style
                        .apply(fontSizeFactor: 0.7))
              ])),
        if (task.jobState == "audit" && task.auditState == "requested" &&
            (widget.role == 'customer' || widget.role == 'performer'))
          ParticipantList(
            listType: 'audit',
            obj: task,
          ),


        // ************************* AUDITOR ROLE *************************** //

      ],
    );
  }
}
