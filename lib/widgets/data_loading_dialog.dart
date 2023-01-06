// ignore_for_file: unnecessary_const

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/task.dart';
import '../blockchain/task_services.dart';

class AppDataLoadingDialog extends StatefulWidget {
  const AppDataLoadingDialog({Key? key}) : super(key: key);

  @override
  _AppDataLoadingDialog createState() => _AppDataLoadingDialog();
}

class _AppDataLoadingDialog extends State<AppDataLoadingDialog> {
  late Task task;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    // if (tasksServices.tasksCustomerSelection[widget.taskAddress] != null) {
    //   task = tasksServices.tasksCustomerSelection[widget.taskAddress]!;
    // } else if (tasksServices.tasksCustomerProgress[widget.taskAddress] !=
    //     null) {
    //   task = tasksServices.tasksCustomerProgress[widget.taskAddress]!;
    // } else if (tasksServices.tasksCustomerComplete[widget.taskAddress] !=
    //     null) {
    //   task = tasksServices.tasksCustomerComplete[widget.taskAddress]!;
    // }

    return const AppDataLoadingDialogWidget();
  }
}

class AppDataLoadingDialogWidget extends StatefulWidget {
  // final int taskCount;
  const AppDataLoadingDialogWidget({Key? key}) : super(key: key);

  @override
  _AppDataLoadingDialogWidgetState createState() => _AppDataLoadingDialogWidgetState();
}

class _AppDataLoadingDialogWidgetState extends State<AppDataLoadingDialogWidget> {
  late Task task;

  late String warningText;
  late String title;
  late String link;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    title = 'Please wait, The Task will appear shortly';

    warningText = '';
    link = '';

    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: SizedBox(
        height: 220,
        width: 350,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      // style: DefaultTextStyle
                      //     .of(context)
                      //     .style
                      //     .apply(fontSizeFactor: 1.1),
                      children: <TextSpan>[
                        TextSpan(
                          style: const TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.bold),
                          text: title,
                        ),
                      ])),
              Container(
                padding: const EdgeInsets.all(30.0),
                child: LoadingAnimationWidget.threeRotatingDots(
                  color: Colors.black12,
                  size: 54,
                ),
              ),
              // RichText(
              //     textAlign: TextAlign.center,
              //     text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.1), children: <TextSpan>[
              //       TextSpan(
              //         text: warningText,
              //       ),
              //     ])),
            ],
          ),
        ),
      ),
    );
  }
}
