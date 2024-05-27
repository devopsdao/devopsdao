import 'package:flutter/material.dart';
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
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your score:',
                  style: Theme.of(context).textTheme.bodyMedium),
              if (listenWalletAddress == null)
                Text(
                  'Not Connected',
                  style: Theme.of(context).textTheme.titleSmall,
                )
              else if (tasksServices.scoredTaskCount == 0)
                Text(
                  'No completed evaluated tasks',
                  style: Theme.of(context).textTheme.titleSmall,
                )
              else
                SelectableText(
                  '${tasksServices.myScore} of ${tasksServices.scoredTaskCount} tasks',
                  style: Theme.of(context).textTheme.titleSmall,
                )
            ],
          ),
        );
      },
    );
  }
}