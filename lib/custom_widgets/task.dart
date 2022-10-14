import 'dart:ffi';

import 'package:devopsdao/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blockchain/task_services.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';

import '../custom_widgets/wallet_action.dart';

class TaskDialog extends StatefulWidget {
  // final String nanoId;
  // final String taskName;
  final int index;
  const TaskDialog(
      {Key? key,
      // required this.nanoId,
      // required this.taskName,
      required this.index})
      : super(key: key);

  @override
  _TaskDialog createState() => _TaskDialog();
}

class _TaskDialog extends State<TaskDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();

    final index = widget.index;

    return AlertDialog(
      title: Text(tasksServices.filterResults[index].title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            // Divider(
            //   height: 20,
            //   thickness: 1,
            //   indent: 40,
            //   endIndent: 40,
            //   color: Colors.black,
            // ),
            RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context)
                        .style
                        .apply(fontSizeFactor: 1.0),
                    children: <TextSpan>[
                  const TextSpan(
                      text: 'Description: \n',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: tasksServices.filterResults[index].description)
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
                      text:
                          '${tasksServices.filterResults[index].contractValue} ETH\n',
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 1.0)),
                  TextSpan(
                      text:
                          '${tasksServices.filterResults[index].contractValueToken} aUSDC',
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
                      text: tasksServices.filterResults[index].contractOwner
                          .toString(),
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
                      text: tasksServices.filterResults[index].contractAddress
                          .toString(),
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
                        .format(tasksServices.filterResults[index].createdTime),
                  )
                ])),
            // Text("Description: ${exchangeFilterWidget.filterResults[index].description}",
            //   style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
            // Text('Contract owner: ${exchangeFilterWidget.filterResults[index].contractOwner.toString()}',
            //   style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
            // Text('Contract address: ${exchangeFilterWidget.filterResults[index].contractAddress.toString()}',
            //   style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
            // Divider(
            //   height: 20,
            //   thickness: 0,
            //   indent: 40,
            //   endIndent: 40,
            //   color: Colors.black,
            // ),
          ],
        ),
      ),
      actions: [
        if (tasksServices.filterResults[index].jobState == 'new')
          TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white, backgroundColor: Colors.redAccent),
              onPressed: () {
                setState(() {
                  tasksServices.filterResults[index].justLoaded = false;
                });
                tasksServices.changeTaskStatus(
                    tasksServices.filterResults[index].contractAddress,
                    tasksServices.zeroAddress,
                    'cancel',
                    tasksServices.filterResults[index].nanoId);
                Navigator.pop(context);

                showDialog(
                    context: context,
                    builder: (context) => WalletAction(
                          nanoId: tasksServices.filterResults[index].nanoId,
                          taskName: 'taskCancel',
                        ));
              },
              child: const Text('Cancel')),
        if (tasksServices.filterResults[index].contractOwner !=
                tasksServices.ownAddress &&
            tasksServices.ownAddress != null &&
            tasksServices.validChainID)
          TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white, backgroundColor: Colors.green),
              onPressed: () {
                setState(() {
                  tasksServices.filterResults[index].justLoaded = false;
                });
                tasksServices.taskParticipation(
                    tasksServices.filterResults[index].contractAddress,
                    tasksServices.filterResults[index].nanoId);
                Navigator.pop(context);

                showDialog(
                    context: context,
                    builder: (context) => WalletAction(
                          nanoId: tasksServices.filterResults[index].nanoId,
                          taskName: 'taskParticipation',
                        ));
              },
              child: const Text('Participate')),
        TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.pop(context)),
        if (tasksServices
            .filterResults[index].jobState == 'new')
          TextButton(
              style: TextButton.styleFrom(
                  primary:
                  Colors
                      .white,
                  backgroundColor:
                  Colors
                      .redAccent),
              onPressed:
                  () {
                setState(
                        () {
                      tasksServices.filterResults[index].justLoaded = false;
                    });
                tasksServices.changeTaskStatus(
                    tasksServices.filterResults[index].contractAddress,
                    tasksServices.zeroAddress,
                    'cancel',
                    tasksServices.filterResults[index].nanoId);
                Navigator.pop(context);

                showDialog(
                    context:
                    context,
                    builder: (context) =>
                        WalletAction(
                          nanoId: tasksServices.filterResults[index].nanoId,
                          taskName: 'taskCancel',
                        ));
              },
              child: const Text(
                  'Cancel')),
      ],
    );
  }
}
