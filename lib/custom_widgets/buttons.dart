
import 'package:badges/badges.dart';
import 'package:devopsdao/blockchain/task.dart';
import 'package:devopsdao/custom_widgets/wallet_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';


class WithdrawButton extends StatefulWidget {
  final Task object;
  const WithdrawButton({Key? key, required this.object}) : super(key: key);

  @override
  _WithdrawButtonState createState() => _WithdrawButtonState();
}

class _WithdrawButtonState extends State<WithdrawButton> {

  bool _buttonState = false;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    print(tasksServices.destinationChain);
    if(widget.object.contractValue != 0) {
      _buttonState = true;
    } else if (widget.object.contractValueToken != 0) {
      if (widget.object.contractValueToken > tasksServices.transferFee || tasksServices.destinationChain == 'Moonbase') {

        _buttonState = true;
      } else {
        _buttonState = false;
      }
    }

  return TextButton(
    child: Text('Withdraw'),
    style: TextButton.styleFrom(
        primary: Colors.white,
        disabledBackgroundColor: Colors.white10,
        backgroundColor: Colors.green),
    onPressed: _buttonState ? () {
      setState(() {
        widget.object.justLoaded = false;
      });
      tasksServices.withdrawToChain(
        widget.object.contractAddress,
        widget.object.nanoId);
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => WalletAction(
          nanoId:
          widget.object.nanoId,
          taskName: 'withdrawToChain',
        )
      );
    } : null);
  }
}
