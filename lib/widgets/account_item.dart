import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../blockchain/accounts.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../task_item/delete_item_alert.dart';

class AccountItem extends StatefulWidget {
  // final int taskCount;
  final String fromPage;
  final Account object;
  const AccountItem(
      {Key? key,
        required this.fromPage,
        required this.object})
      : super(key: key);

  @override
  _AccountItemState createState() => _AccountItemState();
}

class _AccountItemState extends State<AccountItem> {
  final bool isAdministrator = false;
  late Account account;


  @override
  Widget build(BuildContext context) {
    account = widget.object;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (true)
            SizedBox(
              width: 50,
              height: 80,
              child: InkWell(
                child: const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(
                    Icons.close_sharp,
                    color: Colors.deepOrange,
                    size: 36,
                  ),
                ),
                onTap: () {
                  setState(() {
                    showDialog(context: context, builder: (context) =>
                        DeleteItemAlert(account: account));
                  });
                },
              ),
            ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 8, 8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Text(
                          account.walletAddress.toString(),
                          style: FlutterFlowTheme.of(context).subtitle1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          account.nickName,
                          style: FlutterFlowTheme.of(context).bodyText2,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Text(
                          account.about,
                          // DateFormat('MM/dd/yyyy, hh:mm a')
                          //     .format(task.createTime),
                          style: FlutterFlowTheme.of(context).bodyText2,
                          softWrap: false,
                          overflow: TextOverflow.fade,
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
