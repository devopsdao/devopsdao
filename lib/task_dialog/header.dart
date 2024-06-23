import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../blockchain/empty_classes.dart';
import '../blockchain/interface.dart';
import '../blockchain/classes.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/services.dart';

import '../blockchain/task_services.dart';
import '../config/theme.dart';
import 'model_view/task_model_view.dart';

// Name of Widget & TaskDialogBeamer > TaskDialogFuture > Skeleton > Header > Pages > (topup, main, deskription, selection, widgets.chat)

class TaskDialogHeader extends StatefulWidget {
  final Task task;
  final String fromPage;

  const TaskDialogHeader({Key? key, required this.task, required this.fromPage}) : super(key: key);

  @override
  _TaskDialogHeaderState createState() => _TaskDialogHeaderState();
}

class _TaskDialogHeaderState extends State<TaskDialogHeader> {

  LinearGradient _containerColor = const LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Colors.purpleAccent,
      Colors.deepOrange,
    ],
  );

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    final emptyClasses = EmptyClasses();
    var taskModelView = context.read<TaskModelView>();
    final Task task = widget.task;

    return Container(
      padding: const EdgeInsets.all(14),
      width: InterfaceSettings.maxStaticDialogWidth,
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: InkWell(
              onTap: () {
                interface.dialogPagesController
                    .animateToPage(interface.dialogCurrentState['pages']['main'],
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
                              Icons.arrow_back,
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
            flex: 14  ,
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
                        text: task.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                 Padding(
                   padding: EdgeInsets.only(left: 6),
                   child: AnimatedContainer(
                     padding: EdgeInsets.all(7),
                     duration: const Duration(milliseconds: 400),
                     curve: Curves.easeInOut,
                     decoration: BoxDecoration(
                       gradient: _containerColor,
                       borderRadius: BorderRadius.circular(18.0),
                     ),
                     child: Row(
                       children: [
                         Padding(
                           padding:  EdgeInsets.only(right: 6),
                           child: Text('${task.taskAddress.toString().substring(task.taskAddress.toString().length - 6)}',

                               style: Theme.of(context).textTheme.bodySmall!.apply(color: Colors.white,)),
                         ),

                         Icon(
                           FontAwesomeIcons.arrowUpFromBracket,
                           size: 16,
                           color: Colors.white,
                         ),
                       ],
                     ),
                   ),
                 )
                ],
              ),
              onTap: () async {
                setState(() {
                  _containerColor = const LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Colors.blueAccent,
                      Colors.purple,
                      Colors.deepOrange,
                    ],
                  );
                });

                Future.delayed(const Duration(milliseconds: 800), () {
                  setState(() {
                    _containerColor = const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.purpleAccent,
                        Colors.deepOrange,
                      ],
                    );
                  });
                });
                // Clipboard.setData(ClipboardData(text: 'https://dodao.dev/#/${widget.fromPage}/${task.taskAddress}')).then((_) {
                Clipboard.setData(ClipboardData(text: 'https://dodao.dev/#/tasks/${task.taskAddress}')).then((_) {
                  Flushbar(
                    icon: Icon(
                      FontAwesomeIcons.arrowUpFromBracket,
                      size: 20,
                      color: DodaoTheme.of(context).flushTextColor,
                    ),
                    message: 'Task "${task.title} '
                        '...${task.taskAddress.toString().substring(task.taskAddress.toString().length - 8)}" '
                        'URL copied to your clipboard!',
                    duration: const Duration(seconds: 2),
                    // backgroundColor: DodaoTheme.of(context).flushForCopyBackgroundColor,
                      backgroundGradient: const LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Colors.blueAccent,
                          Colors.purple,
                          Colors.deepOrange,
                        ],
                      ),
                    shouldIconPulse: false)
                  .show(context);
                });
              },
            )),
          const Spacer(),
          InkWell(
            onTap: () {
              interface.dialogPageNum = interface.dialogCurrentState['pages']['main']; // reset page to *main*
              interface.selectedUser = emptyClasses.emptyAccount; // reset
              taskModelView.onUpdateRatingValue(0.0); // reset rating score
              Navigator.pop(context);
              interface.emptyTaskMessage();
              RouteInformation routeInfo = RouteInformation(location: '/${widget.fromPage}');
              Beamer.of(context).updateRouteInformation(routeInfo);

              final tasksServices = Provider.of<TasksServices>(context, listen: false);
              if (tasksServices.checkWitnetResultAvailabilityTimerTimer != null) {
                tasksServices.checkWitnetResultAvailabilityTimerTimer!.cancel();
                print ('timer checkWitnetResultAvailabilityTimerTimer canceled');
              }
              if (tasksServices.getLastWitnetResultTimerTimer != null) {
                tasksServices.getLastWitnetResultTimerTimer!.cancel();
                print ('timer getLastWitnetResultTimerTimer canceled');
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(0.0),
              height: 30,
              width: 30,
              child: const Row(
                children: <Widget>[
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
