import 'package:dodao/blockchain/classes.dart';
import 'package:dodao/widgets/wallet_action.dart';
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
    // print(tasksServices.destinationChain);
    if (widget.object.tokenValues[0] != 0) {
      _buttonState = true;
    } else if (widget.object.tokenValues[0] != 0) {
      if (widget.object.tokenValues[0] > tasksServices.transferFee || tasksServices.destinationChain == 'Moonbase') {
        _buttonState = true;
      } else {
        _buttonState = false;
      }
    }

    return TextButton(
        style: TextButton.styleFrom(primary: Colors.white, disabledBackgroundColor: Colors.white10, backgroundColor: Colors.green),
        onPressed: _buttonState
            ? () {
                setState(() {
                  widget.object.justLoaded = false;
                });
                tasksServices.withdrawToChain(widget.object.taskAddress, widget.object.nanoId);
                Navigator.pop(context);

                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => WalletAction(
                          nanoId: widget.object.nanoId,
                          taskName: 'withdrawToChain',
                        ));
              }
            : null,
        child: const Text('Withdraw'));
  }
}

// class SearchButton extends StatefulWidget {
//   const SearchButton({Key? key}) : super(key: key);
//
//   @override
//   _SearchButtonState createState() => _SearchButtonState();
// }
//
// class _SearchButtonState extends State<SearchButton> {
//   TextEditingController textController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     var tasksServices = context.watch<TasksServices>();
//
//     setState(() {});
//
//     return Row(
//       children: [
//         Padding(
//             padding: const EdgeInsets.only(top: 0.0, right: 10, left: 10),
//             child: AnimSearchBar(
//               width: 400,
//               color: Colors.black,
//               textController: textController,
//               onSuffixTap: () {
//                 setState(() {
//                   textController.clear();
//                 });
//               },
//             )),
//       ],
//     );
//   }
// }
