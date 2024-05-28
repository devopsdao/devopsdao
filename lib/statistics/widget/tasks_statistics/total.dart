import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../blockchain/classes.dart';
import '../../../blockchain/task_services.dart';
import '../../../wallet/model_view/wallet_model.dart';

class TotalStats extends StatelessWidget {
  final bool extended;

  const TotalStats({Key? key, required this.extended}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);
    var tasksServices = context.read<TasksServices>();
    Future<TaskStats> total = tasksServices.getTaskStats();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total   :',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        );
      },
    );
  }
}