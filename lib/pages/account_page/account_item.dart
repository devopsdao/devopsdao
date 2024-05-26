import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../account_dialog/widget/widget/ban_and_restore_account.dart';
import '../../blockchain/accounts.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../widgets/delete_item_alert.dart';
import 'package:badges/badges.dart' as Badges;

import '../../wallet/model_view/wallet_model.dart';
import '../../widgets/badge-small-colored.dart';

class AccountItem extends StatefulWidget {
  final String tabName;
  final Account account;
  final int index;

  const AccountItem({Key? key, required this.tabName, required this.account, required this.index}) : super(key: key);

  @override
  _AccountItemState createState() => _AccountItemState();
}

class _AccountItemState extends State<AccountItem> {
  final bool isAdministrator = false;

  @override
  Widget build(BuildContext context) {
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);
    final listenRoleNfts = context.select((TasksServices vm) => vm.roleNfts);

    double calculateAverageRating(List<BigInt> ratings) {
      if (ratings.isEmpty) return 0;
      int sum = ratings.fold(0, (sum, rating) => sum + rating.toInt());
      return sum / ratings.length;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: DodaoTheme.of(context).borderRadius,
        border: DodaoTheme.of(context).borderGradient,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (listenWalletAddress != widget.account.walletAddress && (listenRoleNfts['governor'] > 0))
            SizedBox(
              width: 50,
              height: 80,
              child: InkWell(
                child: Column(children: [
                  Expanded(child: (Text(widget.index.toString()))),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: widget.tabName == 'active'
                        ? const Icon(Icons.close_sharp, color: Colors.deepOrange, size: 36)
                        : const Icon(Icons.add, color: Colors.green, size: 36),
                  ))
                ]),
                onTap: () {
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (context) => BanRestoreAccount(
                        account: widget.account,
                        role: widget.tabName,
                      ),
                    );
                  });
                },
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 14, 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.user, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.account.nickName.isNotEmpty ? widget.account.nickName : 'Nameless',
                          style: DodaoTheme.of(context).bodyText2,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.folderPlus, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Created: ',
                        style: DodaoTheme.of(context).bodyText3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      BadgeSmallColored(count: widget.account.customerTasks.length, color: Colors.lightBlue),
                    ],
                  ),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.handshake, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Participated: ',
                        style: DodaoTheme.of(context).bodyText3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      BadgeSmallColored(count: widget.account.participantTasks.length, color: Colors.amber),
                    ],
                  ),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.handshake, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Performer Agreed: ',
                        style: DodaoTheme.of(context).bodyText3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      BadgeSmallColored(count: widget.account.performerAgreedTasks.length, color: Colors.amber),
                    ],
                  ),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.handshake, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Customer Agreed: ',
                        style: DodaoTheme.of(context).bodyText3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      BadgeSmallColored(count: widget.account.customerAgreedTasks.length, color: Colors.amber),
                    ],
                  ),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.searchDollar, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Audit requested: ',
                        style: DodaoTheme.of(context).bodyText3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      BadgeSmallColored(count: widget.account.auditParticipantTasks.length, color: Colors.redAccent),
                    ],
                  ),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.searchDollar, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Performer audited: ',
                        style: DodaoTheme.of(context).bodyText3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      BadgeSmallColored(count: widget.account.performerAuditedTasks.length, color: Colors.redAccent),
                    ],
                  ),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.searchDollar, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Customer audited: ',
                        style: DodaoTheme.of(context).bodyText3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      BadgeSmallColored(count: widget.account.customerAuditedTasks.length, color: Colors.redAccent),
                    ],
                  ),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.check, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Peformer Completed: ',
                        style: DodaoTheme.of(context).bodyText3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      BadgeSmallColored(count: widget.account.performerCompletedTasks.length, color: Colors.green),
                    ],
                  ),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.check, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Customer Completed: ',
                        style: DodaoTheme.of(context).bodyText3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      BadgeSmallColored(count: widget.account.customerCompletedTasks.length, color: Colors.green),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.solidStar, size: 16, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        'Customer rating: ${calculateAverageRating(widget.account.customerRating).toStringAsFixed(2)}',
                        style: DodaoTheme.of(context).bodyText3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.solidStar, size: 16, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        'Performer rating: ${calculateAverageRating(widget.account.performerRating).toStringAsFixed(2)}',
                        style: DodaoTheme.of(context).bodyText3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.wallet, size: 16),
                      const SizedBox(width: 8),
                      GestureDetector(
                          onTap: () async {
                            Clipboard.setData(ClipboardData(text: widget.account.walletAddress.toString())).then((_) {
                              Flushbar(
                                      icon: Icon(
                                        Icons.copy,
                                        size: 20,
                                        color: DodaoTheme.of(context).flushTextColor,
                                      ),
                                      message: '${widget.account.walletAddress.toString()} copied to your clipboard!',
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: DodaoTheme.of(context).flushForCopyBackgroundColor,
                                      shouldIconPulse: false)
                                  .show(context);
                            });
                          },
                          child: Expanded(
                            child: Text(
                              widget.account.walletAddress.toString(),
                              style: DodaoTheme.of(context).bodyText3,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          )),
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
