import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../blockchain/interface.dart';
import '../blockchain/classes.dart';
import '../config/theme.dart';


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
                    child: Material(
                      elevation: DodaoTheme.of(context).elevation,
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      child: Shimmer.fromColors(
                          baseColor: DodaoTheme.of(context).shimmerBaseColor,
                          highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
                          child: Container(
                            height: 82,
                            width: innerPaddingWidth,
                            // color: Colors.grey[300],
                            decoration: BoxDecoration(
                              borderRadius: DodaoTheme.of(context).borderRadius,
                              border: DodaoTheme.of(context).borderGradient,
                            ),
                            // child: Padding(
                            //   padding: const EdgeInsets.all(10.0),
                            //   child: Text(widget.task.description),
                            // ),
                          )
                      ),
                    )




                  ),
                  // ************ Show prices and topup part ******** //
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Material(
                      elevation: DodaoTheme.of(context).elevation,
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      child: Shimmer.fromColors(
                          baseColor: DodaoTheme.of(context).shimmerBaseColor,
                          highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
                          child: Container(
                            padding: const EdgeInsets.only(top: 14),
                            height: 90,
                            width: innerPaddingWidth,
                            // color: Colors.grey[300]
                            decoration: BoxDecoration(
                              borderRadius: DodaoTheme.of(context).borderRadius,
                              border: DodaoTheme.of(context).borderGradient,
                            ),
                          )
                      ),
                    ),
                  ),

                  // ********* Text Input ************ //
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 14),
                  //   child: Material(
                  //     elevation: DodaoTheme.of(context).elevation,
                  //     borderRadius: DodaoTheme.of(context).borderRadius,
                  //     child: Shimmer.fromColors(
                  //         baseColor: DodaoTheme.of(context).shimmerBaseColor,
                  //         highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
                  //         child: Container(
                  //           padding: const EdgeInsets.only(top: 14),
                  //           height: 70,
                  //           width: innerPaddingWidth,
                  //           // color: Colors.grey[350],
                  //           decoration: BoxDecoration(
                  //             borderRadius: DodaoTheme.of(context).borderRadius,
                  //             border: DodaoTheme.of(context).borderGradient,
                  //           ),
                  //         )
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Material(
                      elevation: DodaoTheme.of(context).elevation,
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      child: Shimmer.fromColors(

                          baseColor: DodaoTheme.of(context).shimmerBaseColor,
                          highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
                          child: Container(
                            padding: const EdgeInsets.only(top: 14),
                            height: 70,
                            width: innerPaddingWidth,
                            // color: Colors.grey[350],
                            decoration: BoxDecoration(

                              borderRadius: DodaoTheme.of(context).borderRadius,
                              border: DodaoTheme.of(context).borderGradient,

                              // color: Colors.grey[350],
                            ),
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
        ],
      );
    });
  }
}
