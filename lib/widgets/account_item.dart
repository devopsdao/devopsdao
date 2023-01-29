import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class AccountItem extends StatefulWidget {
  // final int taskCount;
  const AccountItem(
      {Key? key,})
      : super(key: key);

  @override
  _AccountItemState createState() => _AccountItemState();
}

class _AccountItemState extends State<AccountItem> {
  final bool isAdministrator = false;


  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 8, 8, 8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Text(
                          '0x0000000000000000000000000000000000000000',
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
                          'Wallet nickname: ',
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
                          'Date for wallet?',
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
