import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:throttling/throttling.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../wallet/model_view/wallet_model.dart';
import '../../wallet/services/wallet_service.dart';
import '../../config/utils/my_tools.dart';
import '../../widgets/select_menu.dart';
import '../../widgets/tags/tags_old.dart';
import '../../widgets/tags/wrapped_chip.dart';
import '../buttons.dart';

import 'dart:ui' as ui;

import '../fab_buttons.dart';
import '../widget/dialog_button_widget.dart';
import '1_main/rate_widget.dart';

class MainTaskPage extends StatefulWidget {
  final double innerPaddingWidth;
  final double screenHeightSize;
  final Task task;
  final double borderRadius;
  final String fromPage;

  const MainTaskPage({
    Key? key,
    required this.innerPaddingWidth,
    required this.screenHeightSize,
    required this.task,
    required this.borderRadius,
    required this.fromPage,
  }) : super(key: key);

  @override
  _MainTaskPageState createState() => _MainTaskPageState();
}

class _MainTaskPageState extends State<MainTaskPage> {
  TextEditingController? pullRequestController;
  TextEditingController? messageForStateController;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        var tasksServices = context.read<TasksServices>();
        var interface = context.read<InterfaceServices>();
        if (interface.dialogCurrentState['name'] == 'performer-review' && widget.task.repository.isNotEmpty) {
          tasksServices.checkWitnetResultAvailabilityTimer(widget.task.taskAddress, widget.task.nanoId);
          tasksServices.checkWitnetResultAvailability(widget.task.taskAddress, widget.task.nanoId);
        }
      }
    });

    pullRequestController = TextEditingController();
    messageForStateController = TextEditingController();
  }

  @override
  void dispose() {
    pullRequestController!.dispose();
    messageForStateController!.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    WalletModel walletModel = context.read<WalletModel>();
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);

    // final double maxStaticInternalDialogWidth = InterfaceSettings.maxStaticInternalDialogWidth;
    // final double innerPaddingWidth = widget.innerPaddingWidth;
    final Task task = widget.task;
    final String fromPage = widget.fromPage;

    //here we save the values, so that they are not lost when we go to other pages, they will reset on close or topup button:
    messageForStateController!.text = interface.taskMessage;

    final BoxDecoration materialMainBoxDecoration = BoxDecoration(
      borderRadius: DodaoTheme.of(context).borderRadius,
      border: DodaoTheme.of(context).borderGradient,
    );

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: DodaoTheme.of(context).taskBackgroundColor,
      body: Container(
        height: widget.screenHeightSize,
        alignment: Alignment.topCenter,
        // padding: const EdgeInsets.only(top: 5.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            // maxWidth: maxStaticInternalDialogWidth,
            maxHeight: widget.screenHeightSize,
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 3, bottom: 14),
            child: Column(
              children: [
                // const SizedBox(height: 50),
                Material(
                  elevation: DodaoTheme.of(context).elevation,
                  borderRadius: DodaoTheme.of(context).borderRadius,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        // maxWidth: maxStaticInternalDialogWidth,
                        ),
                    child: GestureDetector(
                      onTap: () {
                        interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['description']!,
                            duration: const Duration(milliseconds: 300), curve: Curves.ease);
                        // tasksServices.myNotifyListeners();
                      },
                      child: Container(
                        // width: innerPaddingWidth,
                        decoration: materialMainBoxDecoration,
                        child: LayoutBuilder(builder: (context, constraints) {
                          final text = TextSpan(
                            text: task.description,
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                          final textHeight = TextPainter(text: text, maxLines: 5, textDirection: ui.TextDirection.ltr);
                          final oneLineHeight = TextPainter(text: text, maxLines: 1, textDirection: ui.TextDirection.ltr);
                          textHeight.layout(maxWidth: constraints.maxWidth, minWidth: constraints.minWidth);
                          oneLineHeight.layout(maxWidth: constraints.maxWidth, minWidth: constraints.minWidth);
                          final numLines = textHeight.computeLineMetrics().length;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                child: LimitedBox(
                                  maxHeight: textHeight.didExceedMaxLines
                                      ? textHeight.height + 26
                                      : (oneLineHeight.height * (numLines < 3 ? 3 : numLines)) + 12,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                            padding: const EdgeInsets.all(6.0),
                                            // padding: const EdgeInsets.all(3),
                                            child: RichText(maxLines: 5, text: text)),
                                      ),
                                      if (interface.dialogCurrentState['pages'].containsKey('widgets.chat'))
                                        Container(
                                          margin: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            gradient: DodaoTheme.of(context).smallButtonGradient,
                                            borderRadius: DodaoTheme.of(context).borderRadiusSmallIcon,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.chat_outlined, size: 18, color: Colors.white),
                                            tooltip: 'Go to chat page',
                                            onPressed: () {
                                              interface.dialogPagesController.animateToPage(
                                                  interface.dialogCurrentState['pages']['widgets.chat'] ?? 99,
                                                  duration: const Duration(milliseconds: 400),
                                                  curve: Curves.ease);
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              if (textHeight.didExceedMaxLines)
                                Container(
                                    alignment: Alignment.center,
                                    height: 14,
                                    width: constraints.maxWidth,
                                    decoration: BoxDecoration(
                                      gradient: DodaoTheme.of(context).smallButtonGradient,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: DodaoTheme.of(context).borderRadius.bottomRight,
                                        bottomLeft: DodaoTheme.of(context).borderRadius.bottomLeft,
                                      ),
                                      // borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                    ),
                                    child: RichText(
                                        text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Read more ',
                                          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7, color: Colors.white),
                                        ),
                                        const WidgetSpan(
                                          child: Icon(Icons.forward, size: 13, color: Colors.white),
                                        ),
                                      ],
                                    ))),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                if ((interface.dialogCurrentState['name'] == 'performer-completed' ||
                    (interface.dialogCurrentState['name'] == 'customer-review' || tasksServices.hardhatDebug == true)))
                  RateTask(task: task),

                // ********* auditor choose part ************ //
                if (interface.dialogCurrentState['name'] == 'customer-audit-requested' ||
                    interface.dialogCurrentState['name'] == 'performer-audit-requested' ||
                    interface.dialogCurrentState['name'] == 'customer-audit-performing' ||
                    interface.dialogCurrentState['name'] == 'performer-audit-performing' ||
                    tasksServices.hardhatDebug == true)
                  // if (task.auditInitiator == listenWalletAddress &&
                  //     interface.dialogCurrentState['pages'].containsKey('select'))
                  Container(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Material(
                      elevation: DodaoTheme.of(context).elevation,
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: materialMainBoxDecoration,
                        child: ListBody(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(2.0),
                                  child: const Icon(Icons.warning_amber_rounded,
                                      size: 45, color: Colors.orange), //Icon(Icons.forward, size: 13, color: Colors.white),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      const Text(
                                        'Warning, this contract on Audit state!',
                                      ),
                                      if (task.contractOwner == listenWalletAddress && interface.dialogCurrentState['pages'].containsKey('select'))
                                        Text(
                                            'There '
                                            '${task.auditors.length == 1 ? 'is' : 'are'} '
                                            '${task.auditors.length.toString()} auditor'
                                            '${task.auditors.length == 1 ? '' : 's'}'
                                            ' waiting for your decision',
                                            style: const TextStyle(
                                                // height: 1.1,
                                                )),
                                      if (task.auditor == EthereumAddress.fromHex('0x0000000000000000000000000000000000000000') &&
                                          task.contractOwner != listenWalletAddress)
                                        const Text('the auditor is expected to be selected', style: TextStyle(height: 1.1)),
                                      if (task.auditor != EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'))
                                        const Text('Your request is being resolved by: ', style: TextStyle(height: 1.1)),
                                      if (task.auditor != EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'))
                                        Text('${task.auditor}',
                                            style: const TextStyle(
                                              height: 2.4,
                                              fontSize: 10,
                                              // backgroundColor: Colors.black12
                                            )),
                                    ])),
                                if (task.contractOwner == listenWalletAddress && interface.dialogCurrentState['pages'].containsKey('select'))
                                  TaskDialogButton(
                                    padding: 6.0,
                                    inactive: false,
                                    buttonName: 'Select',
                                    buttonColorRequired: Colors.orange,
                                    callback: () {
                                      interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['select'] ?? 99,
                                          duration: const Duration(milliseconds: 400), curve: Curves.ease);
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // ********* Participant choose part ************ //
                if (interface.dialogCurrentState['name'] == 'customer-new' || tasksServices.hardhatDebug == true)
                  // if (task.taskState == "new" &&
                  //     task.participants.isNotEmpty &&
                  //     (fromPage == 'customer' || tasksServices.hardhatDebug == true))
                  Container(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Material(
                      elevation: DodaoTheme.of(context).elevation,
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: materialMainBoxDecoration,
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              child: const Icon(Icons.new_releases,
                                  size: 40, color: Colors.lightGreen), //Icon(Icons.forward, size: 13, color: Colors.white),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: RichText(
                                    text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: <TextSpan>[
                                  TextSpan(
                                      text: 'There '
                                          '${task.participants.length == 1 ? 'is' : 'are'} '
                                          '${task.participants.length.toString()} participant'
                                          '${task.participants.length == 1 ? '' : 's'}'
                                          ' waiting for your decision',
                                      style: const TextStyle(
                                        height: 1,
                                      )),
                                ])),
                              ),
                            ),
                            // TaskDialogButton(
                            //   padding: 6.0,
                            //   inactive: false,
                            //   buttonName: 'Select',
                            //   buttonColorRequired: Colors.orange,
                            //   callback: () {
                            //     interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['select'] ?? 99,
                            //         duration: const Duration(milliseconds: 400), curve: Curves.ease);
                            //   },
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  gradient: DodaoTheme.of(context).smallButtonGradient,
                                  borderRadius: DodaoTheme.of(context).borderRadiusSmallIcon,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.person_search_rounded, size: 18, color: Colors.white),
                                  tooltip: 'Go to select page',
                                  onPressed: () {
                                    interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['select'] ?? 99,
                                        duration: const Duration(milliseconds: 400), curve: Curves.ease);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // ********* Audit Completed part ************ //
                if (interface.dialogCurrentState['name'] == 'auditor-finished' || tasksServices.hardhatDebug == true)
                  // if (task.taskState == "new" &&
                  //     task.participants.isNotEmpty &&
                  //     (fromPage == 'customer' || tasksServices.hardhatDebug == true))
                  Container(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Material(
                      elevation: DodaoTheme.of(context).elevation,
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: materialMainBoxDecoration,
                        child: ListBody(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(2.0),
                                  child: const Icon(Icons.new_releases,
                                      size: 45, color: Colors.lightGreen), //Icon(Icons.forward, size: 13, color: Colors.white),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: RichText(
                                      text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: const <TextSpan>[
                                    TextSpan(
                                        text: 'Thank you for your contribution. This Task is now completed.',
                                        style: TextStyle(
                                          height: 1,
                                        )),
                                  ])),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // ************ TAGS *********** //
                Container(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Material(
                    elevation: DodaoTheme.of(context).elevation,
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: materialMainBoxDecoration,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: RichText(
                                      text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: const <TextSpan>[
                                    TextSpan(text: 'Tokens and Tags: '),
                                  ])),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: LayoutBuilder(builder: (context, constraints) {
                                    final double width = constraints.maxWidth - 66;
                                    final List<TokenItem> tags = task.tags.map((name) => TokenItem(collection: true, name: name)).toList();
                                    for (int i = 0; i < task.tokenNames.length; i++) {
                                      for (var e in task.tokenNames[i]) {
                                        if (task.tokenNames[i].first == 'ETH') {
                                          final name = walletModel.getNetworkChainCurrency(walletModel.state.chainId ?? WalletService.defaultNetwork);
                                          tags.add(TokenItem(collection: true, nft: false, balance: task.tokenBalances[i], name: name));
                                        } else {
                                          if (task.tokenBalances[i] == 0) {
                                            tags.add(TokenItem(collection: true, nft: true, inactive: true, name: e.toString()));
                                          } else {
                                            tags.add(TokenItem(collection: true, nft: true, inactive: false, name: e.toString()));
                                          }
                                        }
                                      }
                                    }

                                    if (tags.isNotEmpty) {
                                      return SizedBox(
                                        width: width,
                                        child: Wrap(
                                            alignment: WrapAlignment.start,
                                            direction: Axis.horizontal,
                                            children: tags.map((e) {
                                              return WrappedChip(
                                                key: ValueKey(e),
                                                item: MapEntry(
                                                    e.name,
                                                    NftCollection(
                                                      selected: false,
                                                      name: e.name,
                                                      bunch: {
                                                        BigInt.from(0): TokenItem(
                                                            name: e.name, nft: e.nft, inactive: e.inactive, balance: e.balance, collection: true)
                                                      },
                                                    )),
                                                page: 'tasks',
                                                selected: e.selected,
                                                wrapperRole: WrapperRole.selectNew,
                                              );
                                            }).toList()),
                                      );
                                    } else {
                                      return Row(
                                        children: <Widget>[
                                          RichText(
                                              text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: const <TextSpan>[
                                            TextSpan(
                                                text: 'Nothing here',
                                                style: TextStyle(
                                                  height: 1,
                                                )),
                                          ])),
                                        ],
                                      );
                                    }
                                  }),
                                ),
                              ],
                            ),
                          ),
                          if (interface.dialogCurrentState['name'] == 'customer-new' || tasksServices.hardhatDebug == true)
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  gradient: DodaoTheme.of(context).smallButtonGradient,
                                  borderRadius: DodaoTheme.of(context).borderRadiusSmallIcon,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.monetization_on, size: 18, color: Colors.white),
                                  tooltip: 'Go to topup page',
                                  onPressed: () {
                                    interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['topup'] ?? 99,
                                        duration: const Duration(milliseconds: 400), curve: Curves.ease);
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ******** Show rating info ******* //
                if (task.performerRating != 0 || task.customerRating != 0)
                  Container(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Material(
                      elevation: DodaoTheme.of(context).elevation,
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: materialMainBoxDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: RichText(
                                  text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: const <TextSpan>[
                                TextSpan(text: 'Task rating: '),
                              ])),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 4.0),
                                        child: Text(
                                          'Customer rating',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ),
                                      RatingStars(
                                        value: task.customerRating.toDouble(),
                                        starCount: 5,
                                        starSize: 15,
                                        // valueLabelColor: Colors.orangeAccent,
                                        valueLabelTextStyle: const TextStyle(
                                            color: Colors.white, fontWeight: FontWeight.w200, fontStyle: FontStyle.normal, fontSize: 10.0),
                                        valueLabelRadius: 12,
                                        starOffColor: Colors.grey,
                                        maxValue: 5,
                                        starSpacing: 2,
                                        maxValueVisibility: false,
                                        valueLabelVisibility: true,
                                        animationDuration: Duration(milliseconds: 2000),

                                        valueLabelPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 6),
                                        valueLabelMargin: const EdgeInsets.only(right: 6),
                                        starColor: Colors.orangeAccent,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 4.0),
                                        child: Text(
                                          'Performer rating',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ),
                                      RatingStars(
                                        value: task.performerRating.toDouble(),
                                        starCount: 5,
                                        starSize: 15,
                                        // valueLabelColor: Colors.orangeAccent,
                                        valueLabelTextStyle: const TextStyle(
                                            color: Colors.white, fontWeight: FontWeight.w200, fontStyle: FontStyle.normal, fontSize: 10.0),
                                        valueLabelRadius: 12,
                                        starOffColor: Colors.grey,
                                        maxValue: 5,
                                        starSpacing: 2,
                                        maxValueVisibility: false,
                                        valueLabelVisibility: true,
                                        animationDuration: Duration(milliseconds: 2000),

                                        valueLabelPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 6),
                                        valueLabelMargin: const EdgeInsets.only(right: 6),
                                        starColor: Colors.orangeAccent,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // ********* Text Input ************ //
                if (interface.dialogCurrentState['name'] == 'tasks-new-logged' ||
                    interface.dialogCurrentState['name'] == 'performer-agreed' ||
                    interface.dialogCurrentState['name'] == 'performer-progress' ||
                    interface.dialogCurrentState['name'] == 'customer-review' ||
                    tasksServices.hardhatDebug == true)
                  Container(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Material(
                      elevation: DodaoTheme.of(context).elevation,
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      child: Container(
                        // constraints: const BoxConstraints(maxHeight: 500),
                        padding: DodaoTheme.of(context).inputEdge,
                        decoration: materialMainBoxDecoration,
                        child: TextFormField(
                          controller: messageForStateController,
                          // onChanged: (_) => EasyDebounce.debounce(
                          //   'messageForStateController',
                          //   Duration(milliseconds: 2000),
                          //   () => setState(() {}),
                          // ),
                          autofocus: false,
                          obscureText: false,
                          onTapOutside: (test) {
                            FocusScope.of(context).unfocus();
                            // interface.taskMessage = messageForStateController!.text;
                          },
                          onTap: () {
                            Future.delayed(const Duration(milliseconds: 700), () {
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 700),
                                curve: Curves.fastOutSlowIn,
                              );
                            });
                          },
                          keyboardType: TextInputType.multiline,
                          onChanged: (text) {
                            interface.taskMessage = messageForStateController!.text;
                            Debouncing(duration: const Duration(milliseconds: 200)).debounce(() {
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 700),
                                curve: Curves.fastOutSlowIn,
                              );
                              // tasksServices.myNotifyListeners();
                            });
                            // debounceNotifyListener.debounce(() {
                            //   tasksServices.myNotifyListeners();
                            // });
                          },
                          decoration: InputDecoration(
                            // suffixIcon: interface.dialogCurrentState['pages']['chat'] != null ? IconButton(
                            //   onPressed: () {
                            //     interface.dialogPagesController.animateToPage(
                            //         interface.dialogCurrentState['pages']['chat'] ?? 99,
                            //         duration: const Duration(milliseconds: 600),
                            //         curve: Curves.ease);
                            //   },
                            //   icon: const Icon(Icons.chat),
                            //   highlightColor: Colors.grey,
                            //   hoverColor: Colors.transparent,
                            //   color: Colors.blueAccent,
                            //   // splashColor: Colors.black,
                            // ) : null,
                            labelText: interface.dialogCurrentState['labelMessage'],
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            hintText: '[Enter your message here..]',
                            hintStyle: Theme.of(context).textTheme.bodyMedium?.apply(heightFactor: 1.6),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          minLines: 2,
                          maxLines: 5,
                        ),
                      ),
                    ),
                  ),

                // ********* GitHub pull/request Performer ************ //
                if ((interface.dialogCurrentState['name'] == 'performer-progress' ||
                        interface.dialogCurrentState['name'] == 'performer-review' ||
                        tasksServices.hardhatDebug == true) &&
                    task.repository.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Material(
                        elevation: DodaoTheme.of(context).elevation,
                        borderRadius: DodaoTheme.of(context).borderRadius,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              // maxWidth: maxStaticInternalDialogWidth,
                              ),
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: materialMainBoxDecoration,
                            child: LayoutBuilder(builder: (context, constraints) {
                              return Column(
                                children: <Widget>[
                                  if (interface.dialogCurrentState['name'] == 'performer-progress' ||
                                      interface.dialogCurrentState['name'] == 'performer-review' ||
                                      tasksServices.hardhatDebug == true)
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Create a pull request with the following name: ',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ),
                                  GestureDetector(
                                    onTap: () async {
                                      // Clipboard.setData(ClipboardData(text: "dodao.dev/#/tasks/${task.taskAddress} task: ${task.title}")).then((_) {
                                      Clipboard.setData(ClipboardData(text: "dodao.dev/#/tasks/${task.taskAddress}")).then((_) {
                                        Flushbar(
                                                icon: Icon(
                                                  Icons.copy,
                                                  size: 20,
                                                  color: DodaoTheme.of(context).flushTextColor,
                                                ),
                                                message: 'Pull request name: dodao.dev/#/tasks/${task.taskAddress} copied to your clipboard!',
                                                duration: const Duration(seconds: 2),
                                                backgroundColor: DodaoTheme.of(context).flushForCopyBackgroundColor,
                                                shouldIconPulse: false)
                                            .show(context);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.topLeft,
                                      child: Text.rich(
                                        TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: [
                                          WidgetSpan(
                                              child: Padding(
                                            padding: const EdgeInsets.only(right: 5.0),
                                            child: Icon(
                                              Icons.copy,
                                              size: 16,
                                              color: DodaoTheme.of(context).secondaryText,
                                            ),
                                          )),
                                          TextSpan(text: "dodao.dev/#/tasks/${task.taskAddress}", style: const TextStyle(fontWeight: FontWeight.bold)
                                              // style: const TextStyle(fontWeight: FontWeight.w700)
                                              ),
                                        ]),

                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        // RichText(
                                        //     text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: [
                                        //   const WidgetSpan(
                                        //       child: Padding(
                                        //     padding: EdgeInsets.only(right: 5.0),
                                        //     child: Icon(
                                        //       Icons.copy,
                                        //       size: 16,
                                        //       color: Colors.black26,
                                        //     ),
                                        //   )),
                                        //   TextSpan(
                                        //       text: "dodao.dev/#/tasks/${task.taskAddress}",
                                        //       style: const TextStyle(
                                        //         overflow: TextOverflow.ellipsis,
                                        //         )
                                        //       // style: const TextStyle(fontWeight: FontWeight.w700)
                                        //   ),
                                        // ])
                                      ),
                                    ),
                                  ),
                                  if (interface.dialogCurrentState['name'] == 'performer-progress' ||
                                      interface.dialogCurrentState['name'] == 'performer-review' ||
                                      tasksServices.hardhatDebug == true)
                                    Column(
                                      children: [
                                        Container(
                                          // padding: const EdgeInsets.only(top: 8),
                                          alignment: Alignment.topLeft,
                                          child: const Text('Repository to create a pull request in:'),
                                        ),
                                        Builder(builder: (context) {
                                          final Uri toLaunch = Uri.parse('https://github.com/${widget.task.repository}');
                                          // final Uri toLaunch = Uri(scheme: 'https', host: 'github.com', path: '/devopsdao/webthree');
                                          return Container(
                                            padding: const EdgeInsets.all(8.0),
                                            alignment: Alignment.topLeft,
                                            child: GestureDetector(
                                              onTap: () async {
                                                if (!await launchUrl(
                                                  toLaunch,
                                                  mode: LaunchMode.externalApplication,
                                                )) {
                                                  throw 'Could not launch $toLaunch';
                                                }
                                              },
                                              child: RichText(
                                                  text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: [
                                                WidgetSpan(
                                                    child: Padding(
                                                  padding: const EdgeInsets.only(right: 5.0),
                                                  child: Icon(
                                                    Icons.link,
                                                    size: 16,
                                                    color: DodaoTheme.of(context).secondaryText,
                                                  ),
                                                )),
                                                TextSpan(text: toLaunch.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                              ])),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  if (interface.dialogCurrentState['name'] == 'performer-review' || tasksServices.hardhatDebug == true)
                                    Builder(builder: (context) {
                                      // late bool response = false;
                                      // late List response2 = [];
                                      late String status = '';
                                      late Color statusColor = Colors.yellow.shade800;
                                      if (tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest'] == null ||
                                          tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest']!['witnetGetLastResult'][2] == '') {
                                        status = '';
                                      } else if (tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest']!['witnetGetLastResult'][2] ==
                                          'checking') {
                                        status = 'checking';
                                        statusColor = Colors.yellow.shade800;
                                      } else if (tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest']!['witnetGetLastResult'][2] ==
                                          'Unknown error (0x30)') {
                                        status = 'request failed'; //request failed
                                      } else if (tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest']!['witnetGetLastResult'][2] ==
                                              'Witnet: Aggregation: tried to access a value from an array with an index (0) out of bounds.' //'Unknown error (0x70)'
                                          ) {
                                        status = 'no matching PR'; //request failed
                                        statusColor = Colors.yellow.shade800;
                                      } else if (tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest']!['witnetGetLastResult'][2] ==
                                          'Witnet: Aggregation: tried to access a value from a map with a key ("merged_at") that was not found.') {
                                        status = 'PR open, not merged';
                                        statusColor = Colors.yellow.shade800;
                                      } else if (tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest']!['witnetGetLastResult'][2] ==
                                          'closed') {
                                        status = 'PR merged';
                                        statusColor = Colors.green;
                                      }
                                      // else if (tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest']!['witnetGetLastResult'][2] == '(unmerged)') {
                                      //   status = 'PR open, not merged';
                                      //   statusColor = Colors.yellow.shade800;
                                      // }
                                      else {
                                        status = 'error';
                                        statusColor = Colors.red;
                                      }

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            // padding: const EdgeInsets.only(top: 8),
                                            alignment: Alignment.topLeft,
                                            child: const Text('Pull request status:'),
                                          ),

                                          // Row(
                                          //   children: [
                                          //     Padding(
                                          //       padding: const EdgeInsets.all(4.0),
                                          //       child: GestureDetector(
                                          //         onTap: () async {
                                          //           tasksServices.checkWitnetResultAvailability(task.taskAddress);
                                          //         },
                                          //         child: Container(
                                          //             width: 76,
                                          //             height: 36,
                                          //             decoration: BoxDecoration(
                                          //               gradient: DodaoTheme.of(context).smallButtonGradient,
                                          //               borderRadius: DodaoTheme.of(context).borderRadiusSmallIcon,
                                          //             ),
                                          //             child: const Center(
                                          //               child: Text(
                                          //                 'checkResult',
                                          //                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                          //               ),
                                          //             )),
                                          //       ),
                                          //     ),
                                          //     Padding(
                                          //       padding: const EdgeInsets.all(4.0),
                                          //       child: GestureDetector(
                                          //         onTap: () async {
                                          //           await tasksServices.getLastWitnetResult(task.taskAddress);
                                          //         },
                                          //         child: Container(
                                          //             width: 86,
                                          //             height: 36,
                                          //             decoration: BoxDecoration(
                                          //               gradient: DodaoTheme.of(context).smallButtonGradient,
                                          //               borderRadius: DodaoTheme.of(context).borderRadiusSmallIcon,
                                          //             ),
                                          //             child: const Center(
                                          //               child: Text(
                                          //                 'getLastWitnetResult',
                                          //                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                          //               ),
                                          //             )),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),

                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RichText(
                                                text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: [
                                              WidgetSpan(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(right: 5.0),
                                                child: Icon(
                                                  Icons.api,
                                                  size: 16,
                                                  color: DodaoTheme.of(context).secondaryText,
                                                ),
                                              )),
                                              TextSpan(
                                                  text: tasksServices.transactionStatuses[task.nanoId] == null ||
                                                          tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest'] == null
                                                      ? 'check not initialized'
                                                      : tasksServices.transactionStatuses[task.nanoId]!['postWitnetRequest']?['witnetPostResult'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: (() {
                                                      if (tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest']?['witnetPostResult'] ==
                                                          'initialized request') {
                                                        return Colors.yellow.shade900;
                                                      } else if (tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest']
                                                              ?['witnetPostResult'] ==
                                                          'request mined') {
                                                        return Colors.yellow.shade900;
                                                      } else if (tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest']
                                                              ?['witnetPostResult'] ==
                                                          'request failed') {
                                                        return Colors.redAccent;
                                                      } else if (tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest']
                                                              ?['witnetPostResult'] ==
                                                          'result available') {
                                                        return Colors.green;
                                                      } else {
                                                        return DodaoTheme.of(context).primaryText;
                                                      }
                                                    }()),
                                                  )),
                                              if (tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest']?['witnetPostResult'] ==
                                                  'initialized request')
                                                WidgetSpan(
                                                  child: Container(
                                                    padding: const EdgeInsets.only(left: 3.0, right: 4.0),
                                                    // alignment: Alignment.bottomCenter,
                                                    // height: 23,
                                                    child: LoadingAnimationWidget.fourRotatingDots(
                                                      size: 15,
                                                      color: DodaoTheme.of(context).secondaryText,
                                                    ),
                                                  ),
                                                ),
                                            ])),
                                          ),

                                          if (tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest']?['witnetPostResult'] ==
                                                  'request mined' ||
                                              tasksServices.transactionStatuses[task.nanoId]?['postWitnetRequest']?['witnetPostResult'] ==
                                                  'result available')
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                                              child: RichText(
                                                  text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: [
                                                WidgetSpan(
                                                    child: Padding(
                                                  padding: const EdgeInsets.only(right: 5.0),
                                                  child: Icon(
                                                    Icons.api,
                                                    size: 16,
                                                    color: DodaoTheme.of(context).secondaryText,
                                                  ),
                                                )),
                                                TextSpan(text: status, style: TextStyle(fontWeight: FontWeight.bold, color: statusColor)),
                                                if (status == 'checking')
                                                  WidgetSpan(
                                                    child: Container(
                                                      padding: const EdgeInsets.only(left: 3.0, right: 4.0),
                                                      // alignment: Alignment,
                                                      // height: 20,
                                                      child: LoadingAnimationWidget.fourRotatingDots(
                                                        size: 15,
                                                        color: DodaoTheme.of(context).secondaryText,
                                                      ),
                                                    ),
                                                  ),
                                              ])),
                                            ),

                                          // Container(
                                          //   padding: const EdgeInsets.all(8.0),
                                          //   alignment: Alignment.topLeft,
                                          //   child: RichText(
                                          //       text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: const [
                                          //     WidgetSpan(
                                          //         child: Padding(
                                          //       padding: EdgeInsets.only(right: 5.0),
                                          //       child: Icon(
                                          //         Icons.api,
                                          //         size: 16,
                                          //         color: Colors.black26,
                                          //       ),
                                          //     )),
                                          //     // TextSpan(text: response2[2], style: TextStyle(fontWeight: FontWeight.bold))
                                          //     // interface.statusText
                                          //   ])),
                                          // ),
                                          if (interface.dialogCurrentState['name'] == 'performer-review' || tasksServices.hardhatDebug == true)
                                            Container(
                                              padding: const EdgeInsets.only(top: 8),
                                              alignment: Alignment.topLeft,
                                              child: const Text(
                                                '* Please wait until your pull request is merged in to '
                                                'the repository or till customer manually accepts Task completion:',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ),

                                          // Container(
                                          //   padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                                          //   alignment: Alignment.topLeft,
                                          //   child: RichText(
                                          //       text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                          //           children: const [
                                          //             WidgetSpan(
                                          //                 child: Padding(
                                          //                   padding: EdgeInsets.only(right: 5.0),
                                          //                   child: Icon(
                                          //                     Icons.api,
                                          //                     size: 16,
                                          //                     color: Colors.black26,
                                          //                   ),
                                          //                 )
                                          //             ),
                                          //
                                          //             TextSpan(
                                          //                 text: 'Open',
                                          //                 style: TextStyle( fontWeight: FontWeight.bold)
                                          //             ),
                                          //           ])),
                                          // ),
                                          // Container(
                                          //   padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                                          //   alignment: Alignment.topLeft,
                                          //   child: RichText(
                                          //       text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                          //           children: const [
                                          //             WidgetSpan(
                                          //                 child: Padding(
                                          //                   padding: EdgeInsets.only(right: 5.0),
                                          //                   child: Icon(
                                          //                     Icons.api,
                                          //                     size: 16,
                                          //                     color: Colors.black26,
                                          //                   ),
                                          //                 )
                                          //             ),
                                          //
                                          //             TextSpan(
                                          //                 text: 'Closed (merged)',
                                          //                 style: TextStyle( fontWeight: FontWeight.bold)
                                          //             ),
                                          //           ])),
                                          // ),
                                          // Container(
                                          //   padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                                          //   alignment: Alignment.topLeft,
                                          //   child: RichText(
                                          //       text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                          //           children: const [
                                          //             WidgetSpan(
                                          //                 child: Padding(
                                          //                   padding: EdgeInsets.only(right: 5.0),
                                          //                   child: Icon(
                                          //                     Icons.api,
                                          //                     size: 16,
                                          //                     color: Colors.black26,
                                          //                   ),
                                          //                 )
                                          //             ),
                                          //
                                          //             TextSpan(
                                          //                 text: 'Closed (rejected)',
                                          //                 style: TextStyle( fontWeight: FontWeight.bold)
                                          //             ),
                                          //           ])),
                                          // )
                                        ],
                                      );
                                    }),
                                ],
                              );
                            }),
                          ),
                        )),
                  ),

                // // ********* GitHub pull/request Status ************ //
                //
                //   Container(
                //     padding: const EdgeInsets.only(top: 14.0),
                //     child: Material(
                //         elevation: DodaoTheme.of(context).elevation,
                //         borderRadius: DodaoTheme.of(context).borderRadius,
                //         child: ConstrainedBox(
                //           constraints: const BoxConstraints(
                //               // maxWidth: maxStaticInternalDialogWidth,
                //               ),
                //           child: Center()
                //         )),
                //   ),

                // ********* GitHub pull/request Link Information ************ //
                if (((interface.dialogCurrentState['name'] == 'customer-new' ||
                            interface.dialogCurrentState['name'] == 'customer-progress' ||
                            interface.dialogCurrentState['name'] == 'customer-agreed' ||
                            // interface.dialogCurrentState['name'] == 'performer-new' ||
                            interface.dialogCurrentState['name'] == 'performer-agreed') &&
                        widget.task.repository.isNotEmpty) ||
                    tasksServices.hardhatDebug == true)
                  Container(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Material(
                        elevation: DodaoTheme.of(context).elevation,
                        borderRadius: DodaoTheme.of(context).borderRadius,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              // maxWidth: maxStaticInternalDialogWidth,
                              ),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: materialMainBoxDecoration,
                            child: LayoutBuilder(builder: (context, constraints) {
                              return Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.only(top: 8),
                                    alignment: Alignment.topLeft,
                                    child: const Text('Repository to create a pull request in:'),
                                  ),

                                  // Container(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   alignment: Alignment.topLeft,
                                  //   child: RichText(
                                  //       text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: [
                                  //         const WidgetSpan(
                                  //             child: Padding(
                                  //               padding: EdgeInsets.only(right: 5.0),
                                  //               child: Icon(
                                  //                 Icons.api,
                                  //                 size: 16,
                                  //                 color: Colors.black26,
                                  //               ),
                                  //             )),
                                  //         TextSpan(text: widget.task.repository, style: const TextStyle(fontWeight: FontWeight.bold))
                                  //       ])),
                                  // ),

                                  GestureDetector(
                                    onTap: () async {
                                      Clipboard.setData(ClipboardData(text: 'https://github.com/${widget.task.repository}')).then((_) {
                                        Flushbar(
                                                icon: Icon(
                                                  Icons.copy,
                                                  size: 20,
                                                  color: DodaoTheme.of(context).secondaryText,
                                                ),
                                                message: 'https://github.com/${widget.task.repository} copied to your clipboard!',
                                                duration: const Duration(seconds: 2),
                                                backgroundColor: DodaoTheme.of(context).flushForCopyBackgroundColor,
                                                shouldIconPulse: false)
                                            .show(context);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.topLeft,
                                      child: RichText(
                                          text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: [
                                        WidgetSpan(
                                            child: Padding(
                                          padding: const EdgeInsets.only(right: 5.0),
                                          child: Icon(
                                            Icons.copy,
                                            size: 16,
                                            color: DodaoTheme.of(context).secondaryText,
                                          ),
                                        )),
                                        TextSpan(
                                            text: 'https://github.com/${widget.task.repository}',
                                            style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ])),
                                    ),
                                  ),

                                  // Container(
                                  //   padding: const EdgeInsets.only(top: 8),
                                  //   alignment: Alignment.topLeft,
                                  //   child: const Text(
                                  //     '* this ',
                                  //     style: TextStyle(fontSize: 10),
                                  //   ),
                                  // ),
                                ],
                              );
                            }),
                          ),
                        )),
                  ),
                const SizedBox(
                  height: 65,
                )
                // ************** PERFORMER ROLE NETWORK CHOOSE *************** //

                // if ((task.tokenBalances[0] != 0 || task.tokenBalances[0] != 0) &&
                //     (interface.dialogCurrentState['name'] == 'performer-completed' || tasksServices.hardhatDebug == true))
                //   // if (task.taskState == 'completed' &&
                //   //     (fromPage == 'performer' ||
                //   //         tasksServices.hardhatDebug == true) &&
                //   //     (task.contractValue != 0 || task.contractValueToken != 0))
                //   Container(
                //     padding: const EdgeInsets.only(top: 14.0),
                //     child: Material(
                //       elevation: DodaoTheme.of(context).elevation,
                //       borderRadius: DodaoTheme.of(context).borderRadius,
                //       child: Container(
                //         // constraints: const BoxConstraints(maxHeight: 500),
                //         padding: const EdgeInsets.all(8.0),
                //         width: innerPaddingWidth,
                //         decoration: materialMainBoxDecoration,
                //         child: SelectNetworkMenu(object: task),
                //       ),
                //     ),
                //   ),

                // ChooseWalletButton(active: true, buttonName: 'wallet_connect', borderRadius: widget.borderRadius,),

                // if (tasksServices.interchainSelected.isNotEmpty)
                //   Container(
                //     padding: const EdgeInsets.only(right: 25.0, top: 14.0),
                //     child: Row(
                //       children: [
                //         const Spacer(),
                //         Container(
                //           width: 220,
                //           padding: const EdgeInsets.only(),
                //           child: Material(
                //             elevation: 10,
                //             borderRadius: DodaoTheme.of(context).borderRadius,
                //             child: Container(
                //                 // constraints: const BoxConstraints(maxHeight: 500),
                //                 padding: const EdgeInsets.all(5.0),
                //                 width: innerPaddingWidth,
                //                 decoration: materialMainBoxDecoration,
                //                 child: Column(
                //                   children: [
                //                     const Text('Interchain protocol:'),
                //                     Container(
                //                       padding: const EdgeInsets.all(2.0),
                //                       // width: 128,
                //                       child: interface.interchainImages[tasksServices.interchainSelected],
                //                     ),
                //                   ],
                //                 )),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // const Spacer(),

                // DialogButtonSetOnFirstPage(task: task, fromPage: fromPage, width: innerPaddingWidth, )
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonAnimator: NoScalingAnimation(),
      floatingActionButton: Padding(
          // padding: keyboardSize == 0 ? const EdgeInsets.only(left: 40.0, right: 28.0) : const EdgeInsets.only(right: 14.0),
          padding: const EdgeInsets.only(right: 4, left: 37),
          child: SetsOfFabButtons(
            task: task,
            fromPage: fromPage,
          )),
    );
  }
}
