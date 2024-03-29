import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../account_dialog/widget/widget/ban_and_restore_account.dart';
import '../../blockchain/accounts.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../widgets/delete_item_alert.dart';
import 'package:badges/badges.dart' as Badges;

import '../../wallet/model_view/wallet_model.dart';
import '../../widgets/badge-small-colored.dart';

class AccountItem extends StatefulWidget {
  // final int taskCount;
  final String tabName;
  final Account account;
  const AccountItem(
      {Key? key,
        required this.tabName,
        required this.account})
      : super(key: key);

  @override
  _AccountItemState createState() => _AccountItemState();
}

class _AccountItemState extends State<AccountItem> {
  final bool isAdministrator = false;

  @override
  Widget build(BuildContext context) {
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);

    return Container(
      decoration: BoxDecoration(
        borderRadius: DodaoTheme.of(context).borderRadius,
        border: DodaoTheme.of(context).borderGradient,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (listenWalletAddress != widget.account.walletAddress) // forbid to ban you
            SizedBox(
              width: 50,
              height: 80,
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),

                  child: widget.tabName == 'active' ? const Icon(
                    Icons.close_sharp,
                    color: Colors.deepOrange,
                    size: 36,
                  ) : const Icon(
                    Icons.add,
                    color: Colors.green,
                    size: 36,
                  ),
                ),
                onTap: () {
                  setState(() {
                    // showDialog(context: context, builder: (context) =>
                    //     DeleteItemAlert(account: widget.account));

                    showDialog(context: context, builder: (context) =>
                        BanRestoreAccount(account: widget.account, role: widget.tabName,));
                  });
                },
              ),
            ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 14, 8),
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.account.nickName.isNotEmpty ? widget.account.nickName : 'Nameless',
                          style: DodaoTheme.of(context).bodyText2,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),

                  /////// numbers and bags:
                  Center(
                    child: Row(
                      // // mainAxisSize: MainAxisSize.max,
                      // mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Created: ',
                              style: DodaoTheme.of(context).bodyText3,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            BadgeSmallColored(count: widget.account.customerTasks.length, color: Colors.lightBlue,),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Text(
                              'Participated: ',
                              style: DodaoTheme.of(context).bodyText3,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            BadgeSmallColored(count: widget.account.participantTasks.length, color: Colors.amber,),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Text(
                              'Audit requested: ',
                              style: DodaoTheme.of(context).bodyText3,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            BadgeSmallColored(count: widget.account.auditParticipantTasks.length, color: Colors.redAccent,),
                          ],
                        ),
                      ],
                    ),
                  ),

                  ///// Account wallet address:
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text(
                          widget.account.walletAddress.toString(),
                          style: DodaoTheme.of(context).bodyText3,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
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
