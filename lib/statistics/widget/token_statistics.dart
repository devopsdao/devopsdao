
import 'package:dodao/statistics/widget/token_statistics/in_your_wallet_tab.dart';
import 'package:dodao/statistics/widget/token_statistics/pending_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../blockchain/task_services.dart';
import '../../../wallet/model_view/wallet_model.dart';
import '../../../wallet/services/wallet_service.dart';
import '../model_view/pending_model_view.dart';


class TokensStats extends StatefulWidget {
  const TokensStats({Key? key}) : super(key: key);

  @override
  State<TokensStats> createState() => TokensStatsState();
}

class TokensStatsState extends State<TokensStats>  with SingleTickerProviderStateMixin{

  final colors = [const Color(0xFFF62BAD), const Color(0xFFF75D21)];
  late Color indicatorColor = colors[0];
  late TabController tabBarController;
  final double tabPadding = 12;

  @override
  void initState() {
    super.initState();
    TokenPendingModel tokenPendingModel = context.read<TokenPendingModel>();
    tokenPendingModel.subscribeToStatistics();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var tasksServices = context.read<TasksServices>();
      tokenPendingModel.onRequestBalances(WalletService.chainId,tasksServices );
    });
    tabBarController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          indicatorColor = colors[tabBarController.index];
        });
      });
    indicatorColor = colors[0];
  }

  //// unsubscribe statistics broadcast:
  late TokenPendingModel _disposeSub;
  @override
  void didChangeDependencies() {
    _disposeSub = context.read<TokenPendingModel>();
    super.didChangeDependencies();
  }
  @override
  Future<void> dispose() async {
    _disposeSub.unsubscribeStatistics();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();
    TokenPendingModel tokenPendingModel = context.watch<TokenPendingModel>();
    WalletModel walletModel = context.watch<WalletModel>();
    // final listenWalletConnected = context.select((WalletModel vm) => vm.state.walletConnected);
    // final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);

    // if (walletModel.state.walletConnected) {
    //   tags = [];
    // }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          if(walletModel.state.walletConnected && walletModel.state.walletAddress != null)
          SizedBox(
            height: 30,
            child: TabBar(
              controller: tabBarController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: indicatorColor,
              ),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    // Use the default focused overlay color
                    return states.contains(MaterialState.focused) ? null : Colors.transparent;
                  }
              ),
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              // indicatorColor: DodaoTheme.of(context).tabIndicator,
              indicatorWeight: 1,
              // isScrollable: true,
              onTap: (index) {
                // AppBarWithSearchSwitch.of(appbarServices.searchBarContext)?.stopSearch();
                if (index == 0) {
                  tokenPendingModel.onRequestBalances(WalletService.chainId,tasksServices );
                }
              },
              tabs: [
                Tab(
                  // icon: const FaIcon(
                  //   FontAwesomeIcons.smileBeam,
                  // ),
                  child: Padding(
                    padding: EdgeInsets.only(left: tabPadding, right: tabPadding),
                    child: const Text('Your wallet'),
                  ),
                ),
                Tab(
                  // icon: const Icon(
                  //   Icons.card_travel_outlined,
                  // ),
                  child: Padding(
                    padding: EdgeInsets.only(left: tabPadding, right: tabPadding),
                    child: const Text('Pending'),
                  ),
                ),
              ],
            ),
          ),
          if(walletModel.state.walletConnected && walletModel.state.walletAddress != null)
          SizedBox(
            height: 160,
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabBarController,
              children: const [
                InYourWalletTab(),
                PendingTab(),
              ],
            ),
          ),
            
            if(!walletModel.state.walletConnected)
              const SizedBox(
                height: 160,
                child: Center(
                  child: Text('Please connect your wallet')
                ),
              )
        ],
      ),
    );
  }
}
