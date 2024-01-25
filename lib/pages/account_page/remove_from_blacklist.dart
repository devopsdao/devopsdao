import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/accounts.dart';
import '../../blockchain/task_services.dart';

class RemoveFromBlackList extends StatefulWidget {
  final Account? account;
  const RemoveFromBlackList({
    Key? key,
    this.account,
  }) : super(key: key);

  @override
  _RemoveFromBlackListState createState() => _RemoveFromBlackListState();
}

class _RemoveFromBlackListState extends State<RemoveFromBlackList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();

    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: SizedBox(
        height: 440,
        width: 350,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          style: const TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.bold),
                          text: 'title',
                        ),
                      ])),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: const Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.black45,
                  size: 110,
                ),
              ),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.1), children: <TextSpan>[
                    TextSpan(
                      text: 'warningText',
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(width: 0.5, color: Colors.black54),

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
                        tasksServices.removeAccountFromBlacklist(widget.account!.walletAddress);

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
                          'Confirm',
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
