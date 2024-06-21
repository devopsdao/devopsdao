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
    double performerScore = tasksServices.myPerformerScore;
    double customerScore = tasksServices.myCustomerScore;
    double totalScore = (performerScore + customerScore) / 2;
    int totalScoredTasks = tasksServices.totalScoredCustomerTasks + tasksServices.totalScoredPerformerTasks;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Your score',
                  style: Theme.of(context).textTheme.bodySmall),
              SizedBox(
                height: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    if (listenWalletAddress == null)
                      Text(
                        'Not Connected',
                        style: Theme.of(context).textTheme.bodySmall,
                      )

                    else if (totalScore == 0)
                      Text(
                        'No completed evaluated tasks',
                        style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center
                      )
                    else
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6.0),
                                child: SelectableText(
                                  'Total: $totalScoredTasks tasks',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              RatingStars(
                                value: totalScore,
                                starCount: 5,
                                starSize: 15,
                                // valueLabelColor: Colors.orangeAccent,
                                valueLabelTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 10.0),
                                valueLabelRadius: 12,
                                starOffColor: Colors.grey,
                                maxValue: 5,
                                starSpacing: 2,
                                maxValueVisibility: false,
                                valueLabelVisibility: true,
                                animationDuration: Duration(milliseconds: extended ? 0 : 2000),

                                valueLabelPadding:
                                const EdgeInsets.symmetric(vertical: 1, horizontal: 6),
                                valueLabelMargin: const EdgeInsets.only(right: 6),
                                starColor: Colors.orangeAccent,
                              ),
                              // SelectableText(
                              //   '${tasksServices.myScore} of ${tasksServices.scoredTaskCount}',
                              //   style: Theme.of(context).textTheme.bodyMedium,
                              // ),

                            ],
                          ),
                          if(extended)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6.0),
                                  child: SelectableText(
                                    'Performed: ${tasksServices.totalScoredPerformerTasks} tasks',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                RatingStars(
                                  value: performerScore,
                                  starCount: 5,
                                  starSize: 15,
                                  // valueLabelColor: Colors.orangeAccent,
                                  valueLabelTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 10.0),
                                  valueLabelRadius: 12,
                                  starOffColor: Colors.grey,
                                  maxValue: 5,
                                  starSpacing: 2,
                                  maxValueVisibility: false,
                                  valueLabelVisibility: true,
                                  animationDuration: Duration(milliseconds: extended ? 0 : 2000),

                                  valueLabelPadding:
                                  const EdgeInsets.symmetric(vertical: 1, horizontal: 6),
                                  valueLabelMargin: const EdgeInsets.only(right: 6),
                                  starColor: Colors.orangeAccent,
                                ),
                                // SelectableText(
                                //   '${tasksServices.myScore} of ${tasksServices.scoredTaskCount}',
                                //   style: Theme.of(context).textTheme.bodyMedium,
                                // ),

                              ],
                            ),
                          if(extended)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6.0),
                                  child: SelectableText(
                                    'Created: ${tasksServices.totalScoredCustomerTasks} tasks',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                RatingStars(
                                  value: customerScore,
                                  starCount: 5,
                                  starSize: 15,
                                  // valueLabelColor: Colors.orangeAccent,
                                  valueLabelTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 10.0),
                                  valueLabelRadius: 12,
                                  starOffColor: Colors.grey,
                                  maxValue: 5,
                                  starSpacing: 2,
                                  maxValueVisibility: false,
                                  valueLabelVisibility: true,
                                  animationDuration: Duration(milliseconds: extended ? 0 : 2000),

                                  valueLabelPadding:
                                  const EdgeInsets.symmetric(vertical: 1, horizontal: 6),
                                  valueLabelMargin: const EdgeInsets.only(right: 6),
                                  starColor: Colors.orangeAccent,
                                ),
                                // SelectableText(
                                //   '${tasksServices.myScore} of ${tasksServices.scoredTaskCount}',
                                //   style: Theme.of(context).textTheme.bodyMedium,
                                // ),

                              ],
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}