import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/accounts.dart';
import '../blockchain/interface.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/services.dart';

// Name of Widget & TaskDialogBeamer > TaskDialogFuture > Skeleton > Header > Pages > (topup, main, deskription, selection, widgets.chat)

class DialogHeader extends StatefulWidget {
  final double maxStaticDialogWidth;
  final Account account;
  final String fromPage;

  const DialogHeader({
    Key? key,
    required this.maxStaticDialogWidth,
    required this.account,
    required this.fromPage
  }) : super(key: key);

  @override
  _DialogHeaderState createState() => _DialogHeaderState();
}

class _DialogHeaderState extends State<DialogHeader> {
  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    final double maxStaticDialogWidth = widget.maxStaticDialogWidth;
    final Account account = widget.account;

    return Container(
      padding: const EdgeInsets.all(20),
      width: maxStaticDialogWidth,
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: InkWell(
              onTap: () {
                interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['main'],
                  duration: const Duration(milliseconds: 400), curve: Curves.ease);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(0.0),
                height: 30,
                width: 30,
                child: Container()
              ),
            ),
          ),
          const Spacer(),
          Expanded(
              flex: 10,
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RichText(
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            const WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 5.0),
                                  child: Icon(
                                    Icons.copy,
                                    size: 20,
                                    color: Colors.black26,
                                  ),
                                )),
                            TextSpan(
                              text: account.nickName,
                              style: const TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                onTap: () async {
                  Clipboard.setData(
                      ClipboardData(text: 'https://dodao.dev/index.html#/${widget.fromPage}/${account.walletAddress.toString()}'))
                      .then((_) {
                    Flushbar(
                        icon: const Icon(
                          Icons.copy,
                          size: 20,
                          color: Colors.white,
                        ),
                        message: 'Task URL copied to your clipboard!',
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.blueAccent,
                        shouldIconPulse: false)
                        .show(context);
                  });
                },
              )),
          const Spacer(),
          InkWell(
            onTap: () {
              // interface.dialogPageNum = interface.dialogCurrentState['pages']['main']; // reset page to *main*
              // interface.selectedUser = {}; // reset
              Navigator.pop(context);
              // interface.emptyTaskMessage();
              RouteInformation routeInfo = RouteInformation(location: '/${widget.fromPage}');
              Beamer.of(context).updateRouteInformation(routeInfo);

              // interface.statusText = const TextSpan(
              //     text: 'Not created',
              //     style: TextStyle( fontWeight: FontWeight.bold)
              // );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(0.0),
              height: 30,
              width: 30,
              child: Row(
                children: const <Widget>[
                  Expanded(
                    child: Icon(
                      Icons.close,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}