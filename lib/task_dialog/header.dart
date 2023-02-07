import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/task.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/services.dart';

// Name of Widget & TaskDialogBeamer > TaskDialogFuture > Skeleton > Header > Pages > (topup, main, deskription, selection, widgets.chat)

class TaskDialogHeader extends StatefulWidget {
  final Task task;
  final String fromPage;

  const TaskDialogHeader({
    Key? key,
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
    final Task task = widget.task;

    return Container(
      padding: const EdgeInsets.all(20),
      width: interface.maxStaticDialogWidth,
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
                        if (page == 'description' || page == 'widgets.chat' || page == 'select')
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