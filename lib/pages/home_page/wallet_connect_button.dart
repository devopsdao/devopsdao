import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/task_services.dart';
import '../../statistics/model_view/statistics_model.dart';
import '../../wallet/model_view/wallet_model.dart';
import '../../wallet/services/wallet_service.dart';
import '../../wallet/widgets/main/main.dart';
import '../../widgets/icon_image.dart';

class WalletConnectButton extends StatelessWidget {
  const WalletConnectButton({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();
    final walletConnected = context.select((WalletModel vm) => vm.state.walletConnected);
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);
    StatisticsModel statisticsModel = context.read<StatisticsModel>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 14, top: 8, bottom: 8),
        child: Container(
          // width: 150,
          height: 30,
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Colors.purpleAccent, Colors.deepOrangeAccent, Color(0xfffadb00)],
              stops: [0.1, 0.5, 1],
            ),
          ),
          child: InkWell(
              highlightColor: Colors.white,
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (context) => const WalletDialog(),
                );
                print('wallet connect closed');
                statisticsModel.onRequestBalances(WalletService.chainId, tasksServices);
              },
              child: walletConnected && listenWalletAddress != null
                  ? Row(
                children: [
                  const NetworkIconImage(
                    height: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      '..'
                          '${listenWalletAddress.toString().substring(listenWalletAddress.toString().length - 5)}',
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ],
              )
                  : const Text(
                'Connect wallet',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white),
              )
          ),
        ),
      ),
    );
  }
}