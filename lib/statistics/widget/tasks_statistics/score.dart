import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:provider/provider.dart';

import '../../../blockchain/task_services.dart';
import '../../../wallet/model_view/wallet_model.dart';

class ScoreStats extends StatelessWidget {
  final bool extended;

  const ScoreStats({Key? key, required this.extended}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);
    var tasksServices = context.read<TasksServices>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Your score',
                style: Theme.of(context).textTheme.bodySmall),
            SizedBox(
              height: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  if (listenWalletAddress == null)
                    Text(
                      'Not Connected',
                      style: Theme.of(context).textTheme.bodySmall,
                    )

                  else if (tasksServices.scoredTaskCount == 0)
                    Text(
                      'No completed evaluated tasks',
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  else
                    Column(
                      children: [
                        RatingStars(
                          value: tasksServices.myScore,

                          starCount: 5,
                          starSize: 20,
                          valueLabelColor: const Color(0xff9b9b9b),
                          valueLabelTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          valueLabelRadius: 10,
                          starOffColor: Colors.grey,
                          maxValue: 5,
                          starSpacing: 2,
                          maxValueVisibility: true,
                          valueLabelVisibility: false,
                          animationDuration: Duration(milliseconds: 1000),
                          valueLabelPadding:
                          const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                          valueLabelMargin: const EdgeInsets.only(right: 8),
                          starColor: Colors.deepPurpleAccent,
                        ),
                        SelectableText(
                          '${tasksServices.myScore} of ${tasksServices.scoredTaskCount}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SelectableText(
                          'Tasks',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}