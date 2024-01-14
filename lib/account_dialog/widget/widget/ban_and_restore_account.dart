import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../blockchain/accounts.dart';
import '../../../blockchain/interface.dart';
import '../../../blockchain/task_services.dart';
import '../../../config/theme.dart';
import '../../../widgets/wallet_action_dialog.dart';


class BanRestoreAccount extends StatefulWidget {
  final String role;
  final Account account;
  const BanRestoreAccount({
    Key? key,
    required this.role,
    required this.account,
  }) : super(key: key);

  @override
  _BanRestoreAccountState createState() => _BanRestoreAccountState();
}

class _BanRestoreAccountState extends State<BanRestoreAccount> {
  late String warningText;
  late String title;

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
    var tasksServices = context.read<TasksServices>();
    var interface = context.read<InterfaceServices>();
    final String walletAddress = widget.account.walletAddress.toString();
    final String accountAddress = '${walletAddress.substring(0, 4)}..'
        '${walletAddress.substring(walletAddress.length - 4)}';
    title = 'Are you sure you want to proceed';

    if (widget.role == 'active') {
      warningText = 'Account $accountAddress will be banned';
    } else if (widget.role == 'banned') {
      warningText = 'Account $accountAddress will be removed from ban list';
    }

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
                          text: title,
                        ),
                      ])),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  widget.role == 'active' ? Icons.delete_outline_outlined : Icons.add_circle,
                  color: Colors.black45,
                  size: 110,
                ),
              ),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.1), children: <TextSpan>[
                    TextSpan(
                      text: warningText,
                    ),
                  ])),
              const Spacer(),
              TextFormField(
                controller: messageController,
                autofocus: false,
                obscureText: false,
                onTapOutside: (test) {
                  FocusScope.of(context).unfocus();
                  interface.taskMessage = messageController!.text;
                },

                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.black45,
                      width: 1.0,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.black45,
                      width: 1.0,
                    ),
                  ),
                  labelText: 'Few words about your decision',
                  labelStyle: const TextStyle(fontSize: 17.0, color: Colors.black54),
                  hintText: '[Enter your message here..]',
                  hintStyle: const TextStyle(fontSize: 14.0, color: Colors.black54),
                  // focusedBorder: const UnderlineInputBorder(
                  //   borderSide: BorderSide.none,
                  // ),
                ),
                style: DodaoTheme.of(context).bodyText1.override(
                  fontFamily: 'Inter',
                  color: Colors.black87,
                  lineHeight: null,
                ),
                minLines: 2,
                maxLines: 3,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        interface.emptyTaskMessage();
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
                        interface.emptyTaskMessage();

                        if (widget.role == 'active') {
                          tasksServices.addAccountToBlacklist(widget.account.walletAddress);
                          Navigator.pop(context);
                          interface.emptyTaskMessage();
                          RouteInformation routeInfo = const RouteInformation(location: '/accounts');
                          Beamer.of(context).updateRouteInformation(routeInfo);
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => const WalletActionDialog(
                                nanoId: 'addAccountToBlacklist',
                                actionName: 'addAccountToBlacklist',
                              ));
                        } else if (widget.role == 'banned') {
                          tasksServices.removeAccountFromBlacklist(widget.account.walletAddress);
                          Navigator.pop(context);
                          interface.emptyTaskMessage();
                          RouteInformation routeInfo = const RouteInformation(location: '/accounts');
                          Beamer.of(context).updateRouteInformation(routeInfo);
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => const WalletActionDialog(
                                nanoId: 'removeAccountFromBlacklist',
                                actionName: 'removeAccountFromBlacklist',
                              ));
                        }
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
