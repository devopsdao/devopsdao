import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../blockchain/interface.dart';
import '../blockchain/classes.dart';


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
