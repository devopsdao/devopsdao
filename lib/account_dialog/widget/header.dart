import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/accounts.dart';
import '../../blockchain/interface.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/services.dart';

import '../../config/theme.dart';

// Name of Widget & TaskDialogBeamer > TaskDialogFuture > Skeleton > Header > Pages > (topup, main, deskription, selection, widgets.chat)

class DialogHeader extends StatefulWidget {
  final Account account;
  final String accountRole;

  const DialogHeader({
    Key? key,
    required this.account,
    required this.accountRole
  }) : super(key: key);

  @override
  _DialogHeaderState createState() => _DialogHeaderState();
}

class _DialogHeaderState extends State<DialogHeader> {
  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();

    return Container(
      padding: const EdgeInsets.all(20),
      width: interface.maxStaticDialogWidth,
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: InkWell(
              onTap: () {
                interface.accountsDialogPagesController.animateToPage(0,
                  duration: const Duration(milliseconds: 400), curve: Curves.ease);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(0.0),
                height: 30,
                width: 30,
                child: LayoutBuilder(
                    builder: (BuildContext, context) {
                  return Row(
                    children: <Widget>[
                      // if (interface.accountsDialogPageNum ==)
                      //   const Expanded(
                      //     child: Icon(
                      //       Icons.arrow_forward,
                      //       size: 30,
                      //     ),
                      //   ),
                      if (interface.accountsDialogPageNum == 0)
                        const Expanded(
                          child: Center(),
                        ),
                      if (interface.accountsDialogPageNum > 0)
                        const Expanded(
                          child: Icon(
                            Icons.arrow_back,
                            size: 30,
                          ),
                        ),
                    ],
                  );
                })
                
                //
                //
                // Consumer<InterfaceServices>(
                //   builder: (context, model, child) {
                //     late Map<String, int> mapPages = model.dialogCurrentState['pages'];
                //     late String page = mapPages.entries.firstWhere((element) => element.value == model.dialogPageNum, orElse: () {
                //       return const MapEntry('main', 0);
                //     }).key;
                //     return Row(
                //       children: <Widget>[
                //         if (page == 'topup')
                //           const Expanded(
                //             child: Icon(
                //               Icons.arrow_forward,
                //               size: 30,
                //             ),
                //           ),
                //         if (page.toString() == 'main')
                //           const Expanded(
                //             child: Center(),
                //           ),
                //         if (page == 'description' || page == 'widgets.chat' || page == 'select')
                //           const Expanded(
                //             child: Icon(
                //               Icons.arrow_back,
                //               size: 30,
                //             ),
                //           ),
                //       ],
                //     );
                //   },
                // ),
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
                              text: widget.account.nickName.isNotEmpty ? widget.account.nickName : 'Nameless',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                onTap: () async {
                  Clipboard.setData(
                      ClipboardData(text: widget.account.walletAddress.toString()))
                      .then((_) {
                    Flushbar(
                        icon: Icon(
                          Icons.copy,
                          size: 20,
                          color: DodaoTheme.of(context).flushTextColor,
                        ),
                        message: 'Account wallet address copied to your clipboard!',
                        duration: const Duration(seconds: 2),
                        backgroundColor: DodaoTheme.of(context).flushForCopyBackgroundColor,
                        shouldIconPulse: false)
                        .show(context);
                  });
                },
              )),
          const Spacer(),
          InkWell(
            onTap: () {
              interface.accountsDialogPageNum = 0; // reset page to *0*
              // interface.selectedUser = {}; // reset
              Navigator.pop(context);
              // interface.emptyTaskMessage();
              /// need to be fixed:
              RouteInformation routeInfo = RouteInformation(location: '/${widget.accountRole}');
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
              child: const Row(
                children: <Widget>[
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