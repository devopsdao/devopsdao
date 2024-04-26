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

    double customerRating = 0.0;
    // BigInt tmpCustomerRating = BigInt.from(0);
    double tmpCustomerRating = 0;
    for (int i = 0; i < interface.selectedUser.customerRating.length; i++) {
      tmpCustomerRating += interface.selectedUser.customerRating.length;
    }
    if (tmpCustomerRating != 0) {
      customerRating = tmpCustomerRating.toDouble() / interface.selectedUser.customerRating.length;
    }

    double performerRating = 0.0;
    BigInt tmpPerformerRating = BigInt.from(0);
    for (int i = 0; i < interface.selectedUser.performerRating.length; i++) {
      tmpPerformerRating += interface.selectedUser.performerRating[i];
    }
    if (tmpPerformerRating != BigInt.from(0)) {
      performerRating = tmpPerformerRating.toDouble() / interface.selectedUser.performerRating.length;
    }


    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 40,
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
              borderRadius: BorderRadius.circular(20),
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
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/images/logo.png"),
                  // fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomRight,
                ),
                borderRadius: DodaoTheme.of(context).borderRadius,
              ),
            ),
            Container(
              width: 3,
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
                            child: BadgeSmallColored(
                              count: interface.selectedUser.agreedTasks.length -
                                  interface.selectedUser.completedTasks.length,
                              color: Colors.amber,),
                          ),
                          Text(
                            'Now working',
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
                            child: BadgeSmallColored(count: interface.selectedUser.completedTasks.length, color: Colors.greenAccent.shade700,),
                          ),
                          Text(
                            'Completed',
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
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(participantPaddingSize),
                              child: BadgeSmallColored(count: interface.selectedUser.participantTasks.length, color: Colors.yellow,),
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

                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(participantPaddingSize),
                              child: BadgeSmallRatingColored(count: customerRating, color: Colors.deepPurpleAccent,),
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
                              child: BadgeSmallRatingColored(count: performerRating, color: Colors.deepPurple,),
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
                  ),
                  const Spacer(),
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 3,),
        Text(
          '${interface.selectedUser.walletAddress}',
          style: DodaoTheme.of(context).bodyText3,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        // RichText(
        //     maxLines: 1,
        //     softWrap: true,
        //
        //     text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: <TextSpan>[
        //       TextSpan(text: '${interface.selectedUser.walletAddress}', style: Theme.of(context).textTheme.bodySmall),
        //     ])
        // )
      ],
    );
  }
}
