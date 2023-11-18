import 'package:dodao/wallet/pages.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:dodao/blockchain/task_services.dart';

class WalletDialog extends StatefulWidget {
  const WalletDialog({
    Key? key,
  }) : super(key: key);

  @override
  _WalletDialogState createState() => _WalletDialogState();
}

class _WalletDialogState extends State<WalletDialog> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TasksServices tasksServices = context.read<TasksServices>();

    return LayoutBuilder(builder: (context, constraints) {
      return Center();
    });
  }
}
