import 'package:dodao/blockchain/classes.dart';
import 'package:dodao/config/theme.dart';
import 'package:dodao/widgets/wallet_action_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/accounts.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/notify_listener.dart';
import '../../blockchain/task_services.dart';
import '../../widgets/badge-small-colored.dart';

class ParticipantList extends StatefulWidget {
  final Task task;

  const ParticipantList({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  _ParticipantListState createState() => _ParticipantListState();
}

class _ParticipantListState extends State<ParticipantList> {
  late List participants = [];
  late String status;
  late double selectedIndex = 1990;
  late Future<Map<String, Account>> futureParticipationList;

  final selectionScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getParticipationList();
  }

  @override
  void dispose() {
    selectionScrollController.dispose();
    super.dispose();
  }

  Future<void> getParticipationList() async {
    final provider = Provider.of<TasksServices>(context, listen: false);
    final participationList = provider.getAccountsData(widget.task.participants.cast<EthereumAddress>());
    setState((){
      futureParticipationList = participationList;
    });
  }

  @override
  Widget build(BuildContext context) {
    var myNotifyListener = context.watch<MyNotifyListener>();
    var tasksServices = context.read<TasksServices>();
    var interface = context.read<InterfaceServices>();
    // void getParticipantData() async {
    //   Map<String, Account> list = await tasksServices.getAccountsData(widget.task.participants as List<EthereumAddress>);
    //   participants = list.values.toList();
    //   // participants = list.values.toList();
    // }
    if (interface.dialogCurrentState['name'] == 'customer-new') {
      if (widget.task.participants != null) {
        // getParticipantData();
      } else {
        participants = [];
      }
    } else if (interface.dialogCurrentState['name'] == 'customer-audit-requested' ||
        interface.dialogCurrentState['name'] == 'performer-audit-requested') {
      participants = widget.task.auditors;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(4),
      // scrollDirection: Axis.vertical,
      controller: selectionScrollController,
      // physics: AlwaysScrollableScrollPhysics(),
      child: FutureBuilder(
        future: futureParticipationList,
        builder: (BuildContext context, AsyncSnapshot<Map<String, Account>> snapshot)  {
          if (snapshot. connectionState == ConnectionState.done) {
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
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: SizedBox(
                        height: interface.tileHeight,
                        child: ListTile(
                          title: Row(
                            children: [
                              RichText(
                                  text: TextSpan(style: DodaoTheme.of(context).bodyText3, children: <TextSpan>[
                                    TextSpan(
                                      text:
                                      '${list?[index2].walletAddress.toString().substring(0, 5)}...'
                                      '${list?[index2].walletAddress.toString().substring(tasksServices.publicAddress.toString().length - 5)}',
                                    ),
                                  ]
                                  )
                              ),
                              const Spacer(),
                              RichText(
                                  text: TextSpan(style: DodaoTheme.of(context).bodyText3, children: <TextSpan>[
                                    TextSpan(
                                      text: list![index2].nickName.isNotEmpty ?
                                      list[index2].nickName :
                                          'Nameless'
                                    ),
                                  ]
                                  )
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: BadgeSmallColored(count: list![index2].customerTasks.length, color: Colors.lightBlue,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: BadgeSmallColored(count: list[index2].participantTasks.length, color: Colors.amber.shade800,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: BadgeSmallColored(count: list[index2].auditParticipantTasks.length, color: Colors.redAccent.shade400,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: BadgeSmallColored(count: list[index2].auditParticipantTasks.length, color: Colors.red.shade800,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: BadgeSmallColored(count: list[index2].customerRating.length, color: Colors.deepPurpleAccent,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: BadgeSmallColored(count: list[index2].performerRating.length, color: Colors.deepPurple,),
                              ),
                            ],
                          ),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                          visualDensity: const VisualDensity(vertical: -3),
                          dense: true,
                          selected: index2 == selectedIndex,
                          selectedTileColor: DodaoTheme.of(context).nftInfoBackgroundColor,
                          onTap: () {
                            selectionScrollController.animateTo(
                              (interface.tileHeight * index2) - (interface.tileHeight * 3),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutCirc,
                            );
                            setState(() {
                              selectedIndex = index2.toDouble();
                              interface.selectedUser = list[index2];
                            });
                            myNotifyListener.myNotifyListeners();
                          },
                        ),
                      ),
                    );
                  });
            } else {
              return const Text('Nothing to load..');
            }
          }
          return const Text('...');
        }
      ),
    );
  }
}
