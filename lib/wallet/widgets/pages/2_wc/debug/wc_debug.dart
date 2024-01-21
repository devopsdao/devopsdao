import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../config/theme.dart';
import '../../../../../config/utils/platform.dart';
import '../../../../model_view/wallet_model.dart';
import '../../../../model_view/wc_model.dart';

List<String> debugLinks = ['metamask:', 'wc:', 'universal'];
String selectedDebugLink = 'metamask:';

class WCDebug extends StatefulWidget {
  const WCDebug({
    super.key,
  });

  @override
  State<WCDebug> createState() => _WCDebugState();
}

class _WCDebugState extends State<WCDebug> {
  final _platformAndBrowser = PlatformAndBrowser();
  @override
  Widget build(BuildContext context) {
    WCModelView wcModelView = context.watch<WCModelView>();
    WalletModel walletModel = context.read<WalletModel>();
    return Column(
      children: [
        Text('Select debug link:'),
        SizedBox(
          width: 160,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedDebugLink,
              icon: const Icon(Icons.arrow_drop_down),
              borderRadius: BorderRadius.circular(8),
              dropdownColor: DodaoTheme.of(context).taskBackgroundColor,
              style: Theme.of(context).textTheme.bodySmall,
              // hint: Text('Choose token ($dropdownValue)'),
              underline: Container(
                height: 2,
                color: Colors.deepOrange,
              ),
              onChanged: (String? value) async {
                setState(() {
                  selectedDebugLink = value!;
                });
              },
              items: debugLinks.map<DropdownMenuItem<String>>(
                    (e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}