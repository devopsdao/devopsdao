import 'package:another_flushbar/flushbar.dart';
import 'package:badges/badges.dart';
import 'package:devopsdao/task_dialog/pages.dart';
import 'package:devopsdao/task_dialog/pages/3_selection.dart';
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
import 'package:shimmer/shimmer.dart';
import 'package:webthree/credentials.dart';

import '../blockchain/interface.dart';
import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../widgets/chat/main.dart';

import '../flutter_flow/theme.dart';
import '../flutter_flow/flutter_flow_util.dart';

import 'package:beamer/beamer.dart';

import 'package:flutter/services.dart';

import '../widgets/data_loading_dialog.dart';

import 'dart:ui' as ui;

import 'main.dart';


class ShimmeredTaskPages extends StatefulWidget {
  final Task task;

  const ShimmeredTaskPages({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  _ShimmeredTaskPagesState createState() => _ShimmeredTaskPagesState();
}

class _ShimmeredTaskPagesState extends State<ShimmeredTaskPages> {
  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();

    final double maxStaticInternalDialogWidth = interface.maxStaticInternalDialogWidth;

    return LayoutBuilder(builder: (ctx, dialogConstraints) {
      double innerPaddingWidth = dialogConstraints.maxWidth - 50;

      return Column(
        children: <Widget>[
          if (interface.dialogCurrentState['pages'].containsKey('main'))
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxStaticInternalDialogWidth,
              ),
              child: Column(
                children: [
                  // const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(height: 62, width: innerPaddingWidth, color: Colors.grey[300])),
                  ),
                  // ************ Show prices and topup part ******** //
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(padding: const EdgeInsets.only(top: 14), height: 50, width: innerPaddingWidth, color: Colors.grey[300])),
                  ),

                  // ********* Text Input ************ //
                  Shimmer.fromColors(
                      baseColor: Colors.grey[350]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(padding: const EdgeInsets.only(top: 14), height: 70, width: innerPaddingWidth, color: Colors.grey[350]))
                ],
              ),
            ),
        ],
      );
    });
  }
}
