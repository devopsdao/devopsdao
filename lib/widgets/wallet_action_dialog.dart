import 'dart:math';

import 'package:dodao/config/flutter_flow_util.dart';
import 'package:dodao/config/theme.dart';
import 'package:dodao/widgets/tags/search_services.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;

import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';
import '../navigation/beamer_delegate.dart';
import '../nft_manager/collection_services.dart';
import '../wallet/model_view/wc_model.dart';
import '../wallet/services/wc_service.dart';

class WalletActionDialog extends StatefulWidget {
  final String nanoId;
  final String actionName;
  final String page;
  const WalletActionDialog({Key? key, required this.nanoId, required this.actionName, this.page = ''}) : super(key: key);

  @override
  _WalletActionDialog createState() => _WalletActionDialog();
}

class _WalletActionDialog extends State<WalletActionDialog> {
  String transactionStagesApprove = 'initial';
  String transactionStagesWaiting = 'initial';
  String transactionStagesPending = 'initial';
  String transactionStagesConfirmed = 'initial';
  String transactionStagesMinted = 'initial';

  late String riveAssetPath;

  @override
  void initState() {
    if (Random().nextInt(2) == 1) {
      riveAssetPath = 'assets/rive_animations/clew_with_cat.riv';
    } else {
      riveAssetPath = 'assets/rive_animations/clew2.riv';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TasksServices tasksServices = context.watch<TasksServices>();
    WCModelView wcModelView = context.watch<WCModelView>();
    var searchServices = context.read<SearchServices>();
    var collectionServices = context.read<CollectionServices>();

    final String status = tasksServices.transactionStatuses[widget.nanoId]?[widget.actionName]?['status'];

    if (widget.actionName == 'createTaskContract' && tasksServices.isRequestApproved) {
      final String? tokenApproved = tasksServices.transactionStatuses[widget.nanoId]?[widget.actionName]?['tokenApproved'];

      if (status == 'pending') {
        if (tokenApproved == 'initial') {
          transactionStagesApprove = 'loading';
          transactionStagesConfirmed = 'initial';
          transactionStagesMinted = 'initial';
        } else {
          transactionStagesApprove = 'approve';
          transactionStagesConfirmed = 'initial';
          transactionStagesMinted = 'initial';
        }
      } else if (status == 'minted' && tokenApproved == 'approved') {
        transactionStagesApprove = 'done';
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed' && tokenApproved == 'complete') {
        transactionStagesApprove = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted' && tokenApproved == 'complete') {
        transactionStagesApprove = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';
      }

      tasksServices.isRequestApproved = false;
    } else if (widget.actionName == 'createTaskContract') {
      if (status == 'pending') {
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';

        Future.delayed(const Duration(milliseconds: 400)).whenComplete(() {
          if (mounted) {
            // Navigator.pop(context);
            beamerDelegate.beamToNamed('/customer');
          }
        });
      }
    } else if (widget.actionName == 'createNFT') {
      if (status == 'pending') {
        // transactionStagesApprove = 'done';
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed') {
        // transactionStagesApprove = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted') {
        // transactionStagesApprove = 'done';
        // transactionStagesWaiting = 'done';
        // transactionStagesPending = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';
        Future.delayed(const Duration(milliseconds: 400)).whenComplete(() {
          // if (mounted) {Navigator.pop(context);}
        });
      }
    } else if (widget.actionName == 'mintNonFungible') {
      if (status == 'pending') {
        // transactionStagesApprove = 'done';
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed') {
        // transactionStagesApprove = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted') {
        transactionStagesApprove = 'done';
        // transactionStagesWaiting = 'done';
        // transactionStagesPending = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';

        Future.delayed(const Duration(milliseconds: 200)).whenComplete(() async {
          // if (mounted) {Navigator.pop(context);}
          await tasksServices.collectMyTokens();
          searchServices.refreshLists('selection');
        });
      }
    } else if (widget.actionName == 'postWitnetRequest') {
      if (status == 'pending') {
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';
        Future.delayed(const Duration(milliseconds: 400)).whenComplete(() {
          // if (mounted) {Navigator.pop(context);}
        });
      }
    } else if (widget.actionName == 'taskStateChange') {
      if (status == 'pending') {
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';
        Future.delayed(const Duration(milliseconds: 400)).whenComplete(() {
          // if (mounted) {Navigator.pop(context);}

        });
      }
    } else if (widget.actionName == 'saveLastWitnetResult') {
      if (status == 'pending') {
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';
        Future.delayed(const Duration(milliseconds: 400)).whenComplete(() {
          // if (mounted) {Navigator.pop(context);}
        });
      }
    } else if (widget.actionName == 'setApprovalForAll') {
      if (status == 'pending') {
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';
        Future.delayed(const Duration(milliseconds: 400)).whenComplete(() {
          // if (mounted) {Navigator.pop(context);}
        });
      }
    } else if (widget.actionName == 'taskParticipate') {
      if (status == 'pending') {
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';
        Future.delayed(const Duration(milliseconds: 400)).whenComplete(() {
          // if (mounted) {Navigator.pop(context);}
        });
      } else if (status == 'rejected') {
        // transactionStagesConfirmed = 'done';
        // transactionStagesMinted = 'done';
      }
    } else {
      if (status == 'pending') {
        // transactionStagesPending = 'loading';
        transactionStagesConfirmed = 'loading';
        transactionStagesMinted = 'initial';
      } else if (status == 'confirmed') {
        // transactionStagesPending = 'done';
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'loading';
      } else if (status == 'minted') {
        transactionStagesConfirmed = 'done';
        transactionStagesMinted = 'done';
        Future.delayed(const Duration(milliseconds: 400)).whenComplete(() {
          // if (mounted) {Navigator.pop(context);}
        });
      }
    }
    var width = MediaQuery.of(context).size.width;

    return Dialog(
      // title: Text('Connect your wallet'),
      shape: RoundedRectangleBorder(
        borderRadius: DodaoTheme.of(context).borderRadius,
      ),
      insetAnimationDuration: const Duration(milliseconds: 1100),
      child: Container(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        width: width < 400 ? width : 350,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 170,
                width: 170,
                child: rive.RiveAnimation.asset(
                  riveAssetPath,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  // onInit: _onRiveInit,
                  // artboard: 'new',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      if (status == 'rejected') rejected(context) else if (status == 'failed') failed(context) else passed(tasksServices, context),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        Navigator.pop(context);

                        if (widget.page == 'create_collection') {
                          await tasksServices.collectMyTokens();
                          // searchServices.tagSelection(unselectAll: true, tagName: '', typeSelection: 'treasury', tagKey: '');
                          collectionServices.update();
                          searchServices.searchKeywordController.clear();
                          // searchServices.refreshLists('mint');
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        height: 54.0,
                        alignment: Alignment.center,
                        //MediaQuery.of(context).size.width * .08,
                        // width: halfWidth,
                        decoration: BoxDecoration(
                          borderRadius: DodaoTheme.of(context).borderRadius,
                          border: Border.all(width: 0.5, color: Colors.black54 //                   <--- border width here
                              ),
                        ),
                        child: Text(
                          'Close',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: DodaoTheme.of(context).primaryText,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  if (transactionStagesApprove == 'loading' || transactionStagesConfirmed == 'loading')
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20.0),
                        onTap: () {
                          // Navigator.pop(context);
                          launchURL(wcModelView.state.walletConnectUri);
                          setState(() {});
                          // Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(0.0),
                          height: 54.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: DodaoTheme.of(context).borderRadius,
                            gradient: const LinearGradient(
                              colors: [Color(0xfffadb00), Colors.deepOrangeAccent, Colors.deepOrange],
                              stops: [0, 0.6, 1],
                            ),
                          ),
                          child: const Text(
                            'Go to wallet',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Column passed(TasksServices tasksServices, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.actionName == 'createTaskContract' && tasksServices.taskTokenSymbol != 'ETH')
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Row(
                  children: [
                    if (transactionStagesApprove == 'initial')
                      Icon(
                        Icons.task_alt,
                        size: 30.0,
                        color: DodaoTheme.of(context).iconInitial,
                      )
                    else if (transactionStagesApprove == 'loading' || transactionStagesApprove == 'approve')
                      LoadingAnimationWidget.threeRotatingDots(
                        color: DodaoTheme.of(context).iconProcess,
                        size: 30,
                      )
                    else if (transactionStagesApprove == 'done')
                      Icon(
                        Icons.task_alt,
                        size: 30.0,
                        color: DodaoTheme.of(context).iconDone,
                      )
                  ],
                ),
                if (transactionStagesApprove == 'initial')
                  Text(
                    'Please approve token spend',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.left,
                  ),
                if (transactionStagesApprove == 'loading')
                  Text(
                    'Please approve token spend',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.left,
                  ),
                if (transactionStagesApprove == 'approve')
                  Text(
                    'Token spend approved',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.left,
                  ),
                if (transactionStagesApprove == 'done')
                  Text(
                    'Token spend approved',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.left,
                  ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Stack(
                children: [
                  if (transactionStagesConfirmed == 'initial')
                    // Icon(Icons.task_alt, size: 30.0, color: Colors.green,)
                    Icon(
                      Icons.task_alt,
                      size: 30.0,
                      color: DodaoTheme.of(context).iconInitial,
                    )
                  else if (transactionStagesConfirmed == 'loading')
                    LoadingAnimationWidget.threeRotatingDots(
                      color: DodaoTheme.of(context).iconProcess,
                      size: 30,
                    )
                  else if (transactionStagesConfirmed == 'done')
                    Icon(
                      Icons.task_alt,
                      size: 30.0,
                      color: DodaoTheme.of(context).iconDone,
                    )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              if (transactionStagesConfirmed == 'initial' || transactionStagesConfirmed == 'loading')
                Center(
                  child: Text(
                    'Please approve transaction',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              if (transactionStagesConfirmed == 'done')
                Center(
                  child: Text(
                    'Transaction approved',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Stack(
                children: [
                  if (transactionStagesMinted == 'initial')
                    Icon(
                      Icons.task_alt,
                      size: 30.0,
                      color: DodaoTheme.of(context).iconInitial,
                    )
                  else if (transactionStagesMinted == 'loading')
                    LoadingAnimationWidget.threeRotatingDots(
                      color: DodaoTheme.of(context).iconProcess,
                      size: 30,
                    )
                  else if (transactionStagesMinted == 'done')
                    Icon(
                      Icons.task_alt,
                      size: 30.0,
                      color: DodaoTheme.of(context).iconDone,
                    )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Minted in the blockchain',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding failed(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            Icons.dangerous_outlined,
            size: 30.0,
            color: DodaoTheme.of(context).iconWrong,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Transaction has failed, \nplease retry',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Padding rejected(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            Icons.dangerous_outlined,
            size: 30.0,
            color: DodaoTheme.of(context).iconWrong,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Transaction has been rejected',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
