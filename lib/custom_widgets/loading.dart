import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';

import '../flutter_flow/flutter_flow_theme.dart';

class LoadIndicator extends StatefulWidget {
  const LoadIndicator({Key? key}) : super(key: key);

  @override
  _LoadIndicator createState() => _LoadIndicator();
}

class _LoadIndicator extends State<LoadIndicator> {
  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var taskLoadedState;

    setState(() {
      taskLoadedState = tasksServices.tasksLoaded;
    });
    return Container(
        child: Center(
      child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
          child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  RichText(
                      text: TextSpan(
                          style: DefaultTextStyle.of(context)
                              .style
                              .apply(fontSizeFactor: 1.0),
                          children: <TextSpan>[
                        TextSpan(
                            text:
                                'Collecting Tasks from blockchain: $taskLoadedState of ${tasksServices.totalTaskLen}',
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
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                    child: CircularProgressIndicator(),
                  ),
                ],
              ))),
    ));
  }
}

class LoadButtonIndicator extends StatefulWidget {
  const LoadButtonIndicator({Key? key}) : super(key: key);

  @override
  _LoadButtonIndicator createState() => _LoadButtonIndicator();
}

class _LoadButtonIndicator extends State<LoadButtonIndicator> {
  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var taskLoadedState;

    setState(() {
      taskLoadedState = tasksServices.tasksLoaded;
    });

    return Row(
      children: [
        // Text(taskLoadedState.toString()),
        if (tasksServices.isLoadingBackground)
          Badge(
            // position: BadgePosition.topEnd(top: 10, end: 10),
            badgeContent: Container(
              width: 18,
              height: 18,
              alignment: Alignment.center,
              child: Text(
                taskLoadedState.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            badgeColor: FlutterFlowTheme.of(context).maximumBlueGreen,
            animationDuration: const Duration(milliseconds: 300),
            animationType: BadgeAnimationType.scale,
            shape: BadgeShape.circle,
            borderRadius: BorderRadius.circular(5),
          ),
        FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: tasksServices.isLoadingBackground
              ? LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 30,
                )
              : const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 30,
                ),
          onPressed: () async {
            tasksServices.isLoadingBackground = true;
            tasksServices.fetchTasks();
          },
        ),
      ],
    );
  }
}
