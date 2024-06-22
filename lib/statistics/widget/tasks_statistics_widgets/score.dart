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
    // double performerScore = tasksServices.myPerformerScore;
    // double customerScore = tasksServices.myCustomerScore;
    // double totalScore = (performerScore + customerScore) / 2;
    //
    // for (var task in tasksServices.tasksCustomerComplete) {
    //
    // }
    double performerScore = 0.0;
    double customerScore = 0.0;
    int totalScoredPerformerTasks = 0;
    int totalScoredCustomerTasks = 0;
    double myCustomerScore = 0.0;
    double myPerformerScore = 0.0;
    double totalScore = 0.0;
    int totalScoredTasks = 0;

    tasksServices.tasksCustomerComplete.forEach((address, task) {
      if (task.taskState == "completed") {
        if (task.contractOwner == tasksServices.publicAddress) {
          if (task.customerRating != 0) {
            customerScore += task.customerRating;
            totalScoredCustomerTasks++;
          }
        }
      }
    });

    tasksServices.tasksPerformerComplete.forEach((address, task) {
      if (task.taskState == "completed") {
        if (task.performer == tasksServices.publicAddress) {
          if (task.performerRating != 0) {
            performerScore += task.performerRating;
            totalScoredPerformerTasks++;
          }
        }
      }
    });

    if (totalScoredCustomerTasks > 0) {
      myCustomerScore = customerScore / totalScoredCustomerTasks;
    }

    if (totalScoredPerformerTasks > 0) {
      myPerformerScore = performerScore / totalScoredPerformerTasks;
    }

    totalScoredTasks = totalScoredCustomerTasks + totalScoredPerformerTasks;
    totalScore  = (myPerformerScore + myCustomerScore) / 2;

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
                                child: Center(
                                  child: SelectableText(
                                    'Total completed\n'
                                    'and rated $totalScoredTasks tasks',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
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
                                    'Performed\nwith rate ${totalScoredPerformerTasks} tasks',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                      textAlign: TextAlign.center
                                  ),
                                ),
                                RatingStars(
                                  value: myPerformerScore,
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
                                    'Created\nwith rate ${totalScoredCustomerTasks} tasks',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                      textAlign: TextAlign.center
                                  ),
                                ),
                                RatingStars(
                                  value: myCustomerScore,
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