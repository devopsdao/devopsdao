import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/task.dart';
import '../../blockchain/task_services.dart';
import '../../flutter_flow/theme.dart';
import '../../widgets/wallet_action.dart';

class TagMintDialog extends StatefulWidget {
  final String tagName;
  const TagMintDialog({
    Key? key,
    required this.tagName,
  }) : super(key: key);

  @override
  _TagMintDialogState createState() => _TagMintDialogState();
}

class _TagMintDialogState extends State<TagMintDialog> {
  late String warningText;
  late String title;
  late String link;

  TextEditingController? messageController;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    messageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    title = 'Do you want to mint \"${widget.tagName}\" tag?';

    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: SizedBox(
        height: 440,
        width: 350,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        // style: DefaultTextStyle
                        //     .of(context)
                        //     .style
                        //     .apply(fontSizeFactor: 1.1),
                        children: <TextSpan>[
                          TextSpan(
                            style: const TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.bold),
                            text: title,
                          ),
                        ])),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: const Icon(
                  Icons.tag_rounded,
                  color: Colors.black45,
                  size: 110,
                ),
              ),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(style: DodaoTheme.of(context).bodyText2, children: const <TextSpan>[
                    TextSpan(
                      text: 'If you want choose another tag name to Mint go to tag management page',
                    ),
                  ])),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        height: 54.0,
                        alignment: Alignment.center,
                        //MediaQuery.of(context).size.width * .08,
                        // width: halfWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(width: 0.5, color: Colors.black54 //                   <--- border width here
                              ),
                        ),
                        child: const Text(
                          'Close',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.0),
                      onTap: () {
                        Navigator.pop(context);

                        // tasksServices.taskStateChange(
                        //     task.taskAddress, task.performer, 'audit', task.nanoId,
                        //     message: messageController!.text.isEmpty ? null : messageController!.text);
                        // showDialog(
                        //     context: context,
                        //     builder: (context) => WalletAction(
                        //       nanoId: task.nanoId,
                        //       taskName: 'taskStateChange',
                        //     ));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(0.0),
                        height: 54.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [Color(0xfffadb00), Colors.deepOrangeAccent, Colors.deepOrange],
                            stops: [0, 0.6, 1],
                          ),
                        ),
                        child: const Text(
                          'Mint',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
