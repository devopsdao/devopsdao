import 'package:animations/animations.dart';
import 'package:dodao/blockchain/classes.dart';
import 'package:dodao/config/theme.dart';
import 'package:dodao/widgets/wallet_action_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/accounts.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/notify_listener.dart';
import '../../blockchain/task_services.dart';
import '../../task_dialog/main.dart';
import '../../widgets/badge-small-colored.dart';

class LastActivitiesList extends StatefulWidget {
  final Account account;

  const LastActivitiesList({
    Key? key,
    required this.account,
  }) : super(key: key);

  @override
  LastActivitiesListState createState() => LastActivitiesListState();
}

class LastActivitiesListState extends State<LastActivitiesList> {
  late List tasks = [];
  late String status;
  late double selectedIndex = 1990;
  final selectionScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getLastActivities();
  }

  @override
  void dispose() {
    selectionScrollController.dispose();
    super.dispose();
  }

  late Future<Map<EthereumAddress, Task>> taskList;

  Future<void> getLastActivities() async {
    final List<EthereumAddress> newList = [
      ...widget.account.customerTasks,
      ...widget.account.participantTasks,
      ...widget.account.auditParticipantTasks
    ];
      final tasksServices = Provider.of<TasksServices>(context, listen: false);
      final responseList = tasksServices.getTasksData(newList);
    setState((){
      taskList = responseList;
    });
  }

  @override
  Widget build(BuildContext context) {
    var interface = context.read<InterfaceServices>();


    return SingleChildScrollView(
      padding: const EdgeInsets.all(4),
      controller: selectionScrollController,
      child: FutureBuilder(
        future: taskList,
        builder: (BuildContext context, AsyncSnapshot<Map<EthereumAddress, Task>> snapshot)  {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              snapshot.error.toString();
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              final list = snapshot.data?.values.toList();
              return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  // scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list?.length,
                  itemBuilder: (context2, index2) {
                    late String role = 'not set';
                    if (list?[index2].contractOwner == widget.account.walletAddress) {
                      role == 'owner';
                    } else if (list?[index2].auditor == widget.account.walletAddress) {
                      role = 'auditor';
                    } else {
                      for (final e in list![index2].participants) {
                        if (e == widget.account.walletAddress) {
                          role = 'participant';
                        }
                      }
                    }

                    return OpenContainer(
                      transitionType: ContainerTransitionType.fadeThrough,
                      openColor: DodaoTheme.of(context).taskBackgroundColor,
                      // openElevation: DodaoTheme.of(context).elevation,
                      openBuilder: (BuildContext context, VoidCallback _) {
                        final String taskAddress = list![index2].taskAddress.toString();
                        RouteInformation routeInfo = RouteInformation(location: '/last-activities/$taskAddress');
                        Beamer.of(context).updateRouteInformation(routeInfo);
                        return TaskDialogFuture(
                            fromPage: 'last-activities', taskAddress: list[index2].taskAddress);
                      },
                      transitionDuration: const Duration(milliseconds: 400),
                      closedColor: DodaoTheme.of(context).taskBackgroundColor,
                      closedElevation: 0,
                      // closedShape: const RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.all(Radius.circular(18)),
                      // ),
                      closedBuilder: (BuildContext context, VoidCallback openContainer) {


                        return SizedBox(
                          height: interface.tileHeight,
                          child: ListTile(
                            title: Row(
                              children: [
                                if (role == 'not set')
                                  const BadgeWideColored(color: Colors.green, name: 'Performer', width: 42,),
                                if (role == 'owner')
                                  const BadgeWideColored(color: Colors.lightBlue, name: 'Creator', width: 38,),
                                if (role == 'auditor')
                                  const BadgeWideColored(color: Colors.redAccent, name: 'Auditor', width: 38,),
                                if (role == 'participant')
                                  const BadgeWideColored(color: Colors.amber, name: 'Participant', width: 46,),
                                const Spacer(),
                                RichText(
                                    text: TextSpan(style: DodaoTheme.of(context).bodyText3, children: <TextSpan>[
                                      TextSpan(
                                          text: '${list?[index2].title.toString()}'
                                      ),
                                    ]
                                    )
                                ),
                                const Spacer(),
                                RichText(
                                    text: TextSpan(style: DodaoTheme.of(context).bodyText3, children: <TextSpan>[
                                      TextSpan(
                                          text: list![index2].description.isNotEmpty ?
                                          list[index2].description :
                                          'No description'
                                      ),
                                    ]
                                    )
                                ),
                              ],
                            ),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                            visualDensity: const VisualDensity(vertical: -3),
                            dense: true,
                            selected: index2 == selectedIndex,
                            selectedTileColor: DodaoTheme.of(context).nftInfoBackgroundColor,
                            // onTap: (){
                            // },
                          ),
                        );
                      },
                    );

                  });
            } else {
              return const Text('Nothing to load..');
            }
          }
          return Center(child: LoadingAnimationWidget.prograssiveDots(
            color: DodaoTheme.of(context).iconProcess,
            size: 24,
          ));
        }
      ),
    );
  }
}
