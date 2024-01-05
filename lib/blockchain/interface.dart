import 'package:flutter/material.dart';
import 'package:webthree/credentials.dart';
import 'accounts.dart';

class InterfaceServices extends ChangeNotifier {

  late double tokensEntered = 0.0;
  late String tokenSelected = '';


  // ************* Transport Images ****** //
  late Map<String, Widget> interchainImages = {
    'hyperlane': Image.asset(
      'assets/images/hyperlane.png',
      height: 36,
      filterQuality: FilterQuality.medium,
    ),
    'axelar': Image.asset(
      'assets/images/Axelar-Logo-Update.png',
      height: 34,
      filterQuality: FilterQuality.medium,
    ),
    'layerzero': Image.asset(
      'assets/images/LayerZero.png',
      height: 44,
      filterQuality: FilterQuality.medium,
      isAntiAlias: true,
    ),
    'wormhole': Image.asset(
      'assets/images/worm.png',
      height: 34,
      filterQuality: FilterQuality.medium,
    )
  };

  // *********** Rating set (rate_widget <-> fab_buttons) ********** //
  late double rating = 0.0;
  Future updateRatingValue(number) async {
    rating = number;
    notifyListeners();
  }

  //  *************** Wallet ***************//
  late int currentWalletPage = 0;

  //  ************ accounts_dialog **************//
  late PageController accountsDialogPagesController = PageController(initialPage: 0);
  late int accountsDialogPageNum = 0;
  Future updateAccountsDialogPageNum(number) async {
    accountsDialogPageNum = number;
    notifyListeners();
  }



  Widget chipIcon(String roleOrCoin, Color color, double height, chainId) {
    var networkLogoImage;
    if (roleOrCoin == 'auditor') {
    return networkLogoImage = Icon(
        Icons.star_border_purple500, size: height, color: color
      );
    } else if (roleOrCoin == 'governor') {
    return networkLogoImage = Icon(
        Icons.star_border_purple500, size: height, color: color
      );
    } else if (roleOrCoin == 'DEV') {
      return networkLogoImage = Image.asset(
        'assets/images/net_icon_moonbeam.png',
        height: height,
        filterQuality: FilterQuality.medium,
      );
    } else if (roleOrCoin == 'FTM') {
      return networkLogoImage = Image.asset(
        'assets/images/net_icon_fantom.png',
        height: height,
        filterQuality: FilterQuality.medium,
      );
    } else if (roleOrCoin == 'MATIC') {
      return networkLogoImage = Image.asset(
        'assets/images/net_icon_mumbai_polygon.png',
        height: height,
        filterQuality: FilterQuality.medium,
      );
    } else if (roleOrCoin == 'DODAO') {
      return networkLogoImage = Image.asset(
        'assets/images/logo.png',
        height: height,
        filterQuality: FilterQuality.medium,
      );
    } else if (roleOrCoin == 'ETH' && chainId == 280) {
      return networkLogoImage = Image.asset(
        'assets/images/zksync.png',
        height: height,
        filterQuality: FilterQuality.medium,
      );
    } else {
      return networkLogoImage = Image.asset(
        'assets/images/net_icon_eth.png',
        height: height,
        filterQuality: FilterQuality.medium,
      );
    }
  }

  //  ************ task_dialog **************//
  // PageView Controller for accounts_page.dart
  late PageController dialogPagesController = PageController(initialPage: 1);
  late int dialogPageNum = 0; //initial starts from 1 page
  Future updateDialogPageNum(number) async {
    dialogPageNum = number;
    notifyListeners();
  }

  late Map<String, dynamic> dialogCurrentState;

  // selected Performer or Auditor in participants_list.dart:
  late Account selectedUser = Account(
      nickName: 'not selected',
      about: 'empty',
      walletAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
      customerTasks:[],
      participantTasks: [],
      auditParticipantTasks: [],
      customerRating: [],
      performerRating: []
  );
  // participants_list.dart & 3_selection.dart & auditor
  final double tileHeight = 36;
  final double participantInfoHeight = 165;

  // Input text on accounts_page.dart
  late String taskMessage = '';
  late String taskTopupMessage = '';
  Future emptyTaskMessage() async {
    taskMessage = '';
    taskTopupMessage = '';
  }

  // Hint message for task_dialog
  // late String messageHint;

  // dialog context (for closing it from outside)
  late BuildContext mainDialogContext;
  late BuildContext createJobPageContext;

  late String walletButtonPressed = ''; // hide metamask page if WC pressed

  // wallet/accounts_page.dart controller for tabs
  // late TabController walletTabController = TabController(length: 2, vsync: );

  // ***********  create_job_widget ************ ////
  late PageController pageViewNewTaskController = PageController(initialPage: 0);

  // **** manager treasury pageCount (to avoid screen freezing on animation)
  late int treasuryPageCount = 1;
  Future treasuryPageCountUpdate(number) async {
    treasuryPageCount = number;
    notifyListeners();
  }

  // ****** MAIN SCREEN SETTINGS ******** //
  // border radius:
  final double borderRadius = 8.0;
  // -------------------- Sizes for Dialog window ------------------------- //
  final double maxStaticDialogWidth = 600;
  final double maxStaticInternalDialogWidth = 480;
  final double maxStaticGlobalWidth = 1000;
}