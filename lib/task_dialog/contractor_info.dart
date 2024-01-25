import 'package:another_flushbar/flushbar.dart';
import 'package:dodao/blockchain/task_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/accounts.dart';
import '../blockchain/empty_classes.dart';
import '../blockchain/interface.dart';
import '../blockchain/classes.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/services.dart';

import '../blockchain/notify_listener.dart';
import '../config/theme.dart';
import '../widgets/badge-small-colored.dart';

class ContractorInfo extends StatefulWidget {
  // final Account account;
  // final String fromPage;

  const ContractorInfo({Key? key,
    // required this.account,
    // required this.fromPage
  }) : super(key: key);

  @override
  ContractorInfoState createState() => ContractorInfoState();
}

class ContractorInfoState extends State<ContractorInfo> {

  final double participantPaddingSize = 2.0;

  @override
  Widget build(BuildContext context) {
    var myNotifyListener = context.watch<MyNotifyListener>();
    var interface = context.read<InterfaceServices>();
    final emptyClasses = EmptyClasses();


    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 20,
            ),
            RichText(
                maxLines: 10,
                softWrap: true,
                text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: <TextSpan>[
                  TextSpan(
                      text: interface.selectedUser.nickName.isNotEmpty ? interface.selectedUser.nickName : 'Nameless'),
                ])),
            InkWell(
              onTap: () {
                setState(() {
                  interface.selectedUser = emptyClasses.emptyAccount; // reset
                  myNotifyListener.myNotifyListeners();
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(0.0),
                height: 18,
                width: 20,
                child: const Row(
                  children: <Widget>[
                    Expanded(
                      child: Icon(
                        Icons.close,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              // padding: const EdgeInsets.only(right: 14),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomRight,
                ),
                borderRadius: DodaoTheme.of(context).borderRadius,
              ),
            ),
            Container(
              width: 14,
            ),
            Flexible(
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(participantPaddingSize),
                            child: BadgeSmallColored(count: interface.selectedUser.customerTasks.length, color: Colors.lightBlue,),
                          ),
                          Text(
                            'Created',
                            style: DodaoTheme.of(context).bodyText3,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),

                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(participantPaddingSize),
                            child: BadgeSmallColored(count: interface.selectedUser.participantTasks.length, color: Colors.amber,),
                          ),
                          Text(
                            'Participated',
                            style: DodaoTheme.of(context).bodyText3,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(participantPaddingSize),
                            child: BadgeSmallColored(count: interface.selectedUser.auditParticipantTasks.length, color: Colors.redAccent,),
                          ),
                          Text(
                            'Audit requested',
                            style: DodaoTheme.of(context).bodyText3,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(participantPaddingSize),
                            child: BadgeSmallColored(count: interface.selectedUser.customerRating.length, color: Colors.deepPurpleAccent,),
                          ),
                          Text(
                            'Customer rating',
                            style: DodaoTheme.of(context).bodyText3,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),

                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(participantPaddingSize),
                            child: BadgeSmallColored(count:interface.selectedUser.performerRating.length, color: Colors.deepPurple,),
                          ),
                          Text(
                            'Performer rating',
                            style: DodaoTheme.of(context).bodyText3,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),

                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            )
          ],
        ),
        RichText(
            maxLines: 10,
            softWrap: true,
            text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: <TextSpan>[
              TextSpan(text: '${interface.selectedUser.walletAddress}', style: Theme.of(context).textTheme.bodySmall),
            ])
        )
      ],
    );
  }
}
