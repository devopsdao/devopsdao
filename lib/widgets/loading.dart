import 'package:badges/badges.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dodao/widgets/paw_indicator_with_tasks_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';

import '../config/theme.dart';

import 'package:webthree/webthree.dart';

class LoadIndicator extends StatefulWidget {
  const LoadIndicator({Key? key}) : super(key: key);

  @override
  _LoadIndicator createState() => _LoadIndicator();
}

class _LoadIndicator extends State<LoadIndicator> {
  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var taskLoadedState = tasksServices.tasksLoaded;

    // setState(() {
    //   taskLoadedState =
    // });
    return Center(
      child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
          child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  RichText(
                      text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0), children: <TextSpan>[
                    TextSpan(
                        text: 'Collecting Tasks from blockchain: '
                            '$taskLoadedState of '
                            '${tasksServices.totalTaskLen}',
                        style: const TextStyle(
                          height: 2,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        )),
                    // TextSpan(
                    //   text: '10 of 21',
                    //   style: TextStyle(
                    //     height: 2,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.white,
                    //     fontSize: 17,
                    //   )
                    // ),
                  ])),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                    child: LoadingAnimationWidget.threeRotatingDots(
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                ],
              ))),
    );
  }
}

class LoadButtonIndicator extends StatefulWidget {
  const LoadButtonIndicator({Key? key}) : super(key: key);

  @override
  _LoadButtonIndicator createState() => _LoadButtonIndicator();
}

class _LoadButtonIndicator extends State<LoadButtonIndicator> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();

    return Row(
      children: [
        InkResponse(
          radius: DodaoTheme.of(context).inkRadius,
          containedInkWell: true  ,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: tasksServices.isLoadingBackground
                ? LoadingAnimationWidget.threeRotatingDots(
              color: DodaoTheme.of(context).primaryText,
              size: 24,
            )
                : Icon(
              Icons.refresh_outlined,
              color: DodaoTheme.of(context).primaryText,
              // size: 24,
            ),
          ),
          onTap: () {
            if (tasksServices.publicAddress != null) {
              tasksServices.isLoadingBackground = true;
              tasksServices.refreshTasksForAccount(tasksServices.publicAddress!);
            }
          },
        ),
        // FlutterFlowIconButton(
        //   borderColor: Colors.transparent,
        //   borderRadius: 30,
        //   // borderWidth: 1,
        //   buttonSize: 40,
        //   icon: tasksServices.isLoadingBackground
        //       ? LoadingAnimationWidget.threeRotatingDots(
        //           color: DodaoTheme.of(context).primaryText,
        //           size: 24,
        //         )
        //       : Icon(
        //           Icons.refresh_outlined,
        //           color: DodaoTheme.of(context).primaryText,
        //           // size: 24,
        //         ),
        //   onPressed: () async {
        //     // interface.runPaw();
        //     if (tasksServices.publicAddress != null) {
        //       tasksServices.isLoadingBackground = true;
        //       tasksServices.refreshTasksForAccount(tasksServices.publicAddress!);
        //     }
        //   },
        // ),
      ],
    );
  }
}
