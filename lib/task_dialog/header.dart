import 'package:another_flushbar/flushbar.dart';
import 'package:badges/badges.dart';
import 'package:devopsdao/task_dialog/pages.dart';
import 'package:devopsdao/task_dialog/pages/1_main.dart';
import 'package:devopsdao/task_dialog/pages/3_selection.dart';
import 'package:devopsdao/task_dialog/task_transition_effect.dart';
import 'package:devopsdao/task_dialog/widget/participants_list.dart';
import 'package:devopsdao/task_dialog/widget/request_audit_alert.dart';
import 'package:devopsdao/widgets/payment.dart';
import 'package:devopsdao/widgets/select_menu.dart';
import 'package:devopsdao/task_dialog/buttons.dart';
import 'package:devopsdao/task_dialog/states.dart';
import 'package:devopsdao/widgets/wallet_action.dart';
import 'package:devopsdao/task_dialog/widget/dialog_button_widget.dart';
import 'package:devopsdao/task_dialog/widget/rate_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:horizontal_blocked_scroll_physics/horizontal_blocked_scroll_physics.dart';
import 'package:provider/provider.dart';
import 'package:webthree/credentials.dart';

import '../blockchain/interface.dart';
import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../chat/main.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';

import 'shimmer.dart';

import 'package:beamer/beamer.dart';

import 'package:flutter/services.dart';

import '../widgets/data_loading_dialog.dart';

import 'dart:ui' as ui;

// Name of Widget & TaskDialogBeamer > TaskDialogFuture > Skeleton > Header > Pages > (topup, main, deskription, selection, chat)

class TaskDialogHeader extends StatefulWidget {
  final double maxStaticDialogWidth;
  final Task task;
  final String fromPage;

  const TaskDialogHeader({
    Key? key,
    required this.maxStaticDialogWidth,
    required this.task,
    required this.fromPage
  }) : super(key: key);

  @override
  _TaskDialogHeaderState createState() => _TaskDialogHeaderState();
}

class _TaskDialogHeaderState extends State<TaskDialogHeader> {
  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    final double maxStaticDialogWidth = widget.maxStaticDialogWidth;
    final Task task = widget.task;

    return Container(
      padding: const EdgeInsets.all(20),
      width: maxStaticDialogWidth,
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: InkWell(
              onTap: () {
                interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['main'],
                  duration: const Duration(milliseconds: 400), curve: Curves.ease);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(0.0),
                height: 30,
                width: 30,
                child: Consumer<InterfaceServices>(
                  builder: (context, model, child) {
                    late Map<String, int> mapPages = model.dialogCurrentState['pages'];
                    late String page = mapPages.entries.firstWhere((element) => element.value == model.dialogPageNum, orElse: () {
                      return const MapEntry('main', 0);
                    }).key;
                    return Row(
                      children: <Widget>[
                        if (page == 'topup')
                          const Expanded(
                            child: Icon(
                              Icons.arrow_forward,
                              size: 30,
                            ),
                          ),
                        if (page.toString() == 'main')
                          const Expanded(
                            child: Center(),
                          ),
                        if (page == 'description' || page == 'chat' || page == 'select')
                          const Expanded(
                            child: Icon(
                              Icons.arrow_back,
                              size: 30,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          const Spacer(),
          Expanded(
              flex: 10,
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RichText(
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            const WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 5.0),
                                  child: Icon(
                                    Icons.copy,
                                    size: 20,
                                    color: Colors.black26,
                                  ),
                                )),
                            TextSpan(
                              text: task.title,
                              style: const TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                onTap: () async {
                  Clipboard.setData(
                      ClipboardData(text: 'https://dodao.dev/index.html#/${widget.fromPage}/${task.taskAddress.toString()}'))
                      .then((_) {
                    Flushbar(
                        icon: const Icon(
                          Icons.copy,
                          size: 20,
                          color: Colors.white,
                        ),
                        message: 'Task URL copied to your clipboard!',
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.blueAccent,
                        shouldIconPulse: false)
                        .show(context);
                  });
                },
              )),
          const Spacer(),
          InkWell(
            onTap: () {
              interface.dialogPageNum = interface.dialogCurrentState['pages']['main']; // reset page to *main*
              interface.selectedUser = {}; // reset
              Navigator.pop(context);
              interface.emptyTaskMessage();
              RouteInformation routeInfo = RouteInformation(location: '/${widget.fromPage}');
              Beamer.of(context).updateRouteInformation(routeInfo);

              interface.statusText = const TextSpan(
                  text: 'Not created',
                  style: TextStyle( fontWeight: FontWeight.bold)
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(0.0),
              height: 30,
              width: 30,
              child: Row(
                children: const <Widget>[
                  Expanded(
                    child: Icon(
                      Icons.close,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}