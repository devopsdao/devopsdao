import 'package:provider/provider.dart';

import '../account_dialog/account_transition_effect.dart';
import '../blockchain/interface.dart';
import '../task_dialog/beamer.dart';
import '../widgets/tags/wrapped_chip.dart';
import '../widgets/tags/tag_call_button.dart';
import '/blockchain/task_services.dart';
import '/flutter_flow/theme.dart';
import 'package:flutter/material.dart';

import 'package:webthree/credentials.dart';

class AccountsPage extends StatefulWidget {
  final EthereumAddress? taskAddress;
  const AccountsPage({Key? key, this.taskAddress}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final _searchKeywordController = TextEditingController();
  // final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (widget.taskAddress != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(context: context, builder: (context) => TaskDialogBeamer(taskAddress: widget.taskAddress!, fromPage: 'accounts'));
      });
    }
  }

  @override
  void dispose() {
    _searchKeywordController.dispose();
    super.dispose();
  }

  List<String> deleteItems = [];

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    bool isFloatButtonVisible = false;
    if (_searchKeywordController.text.isEmpty) {
      tasksServices.resetFilter(tasksServices.tasksNew);
    }
    if (tasksServices.publicAddress != null && tasksServices.validChainID) {
      isFloatButtonVisible = true;
    }

    void deleteItem(String id) async {
      setState(() {
        deleteItems.add(id);
      });
      Future.delayed(const Duration(milliseconds: 350)).whenComplete(() {
        setState(() {
          deleteItems.removeWhere((i) => i == id);
        });
      });
    }

    // if (widget.index != null) {
    //   showDialog(
    //       context: context,
    //       builder: (context) => TaskDialogBeamer(index: widget.index!));
    // }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Accounts',
                  style: DodaoTheme.of(context).title2.override(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 22,
                      ),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          // LoadButtonIndicator(),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFF1E2429),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black, Colors.black],
            stops: [0, 0.5, 1],
            begin: AlignmentDirectional(1, -1),
            end: AlignmentDirectional(-1, 1),
          ),
          // image: DecorationImage(
          //   image: AssetImage("assets/images/background.png"),
          //   // fit: BoxFit.cover,
          //   repeat: ImageRepeat.repeat,
          // ),
        ),
        child: SizedBox(
          width: interface.maxStaticGlobalWidth,
          child: DefaultTabController(
            length: 1,
            initialIndex: 0,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: constraints.minWidth - 70,
                        padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                        decoration: const BoxDecoration(
                            // color: Colors.white70,
                            // borderRadius: BorderRadius.circular(8),
                            ),
                        child: TextField(
                          controller: _searchKeywordController,
                          onChanged: (searchKeyword) {
                            tasksServices.runFilter(searchKeyword, tasksServices.tasksNew);
                          },
                          decoration: const InputDecoration(
                            hintText: '[Find task by Title...]',
                            hintStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                            labelStyle: TextStyle(fontSize: 17.0, color: Colors.white),
                            labelText: 'Search',
                            suffixIcon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                          ),
                          style: DodaoTheme.of(context).bodyText1.override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                lineHeight: 2,
                              ),
                        ),
                      ),
                      const TagCallButton(
                        page: 'tasks',
                      ),
                    ],
                  ),
                  Consumer<InterfaceServices>(builder: (context, model, child) {
                    return Wrap(
                        alignment: WrapAlignment.start,
                        direction: Axis.horizontal,
                        children: model.tasksTagsList.map((e) {
                          return WrappedChip(
                              interactive: true,
                              key: ValueKey(e),
                              theme: 'black',
                              item: e,
                              // callback: () {
                              //   model.removeTag(i.tag);
                              // },
                              delete: true,
                              page: 'accounts');
                        }).toList());
                  }),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                          child: RefreshIndicator(
                            onRefresh: () async {
                              tasksServices.isLoadingBackground = true;
                              List<EthereumAddress> taskList = await tasksServices.getTaskListFull();
                              tasksServices.fetchTasksBatch(taskList);
                            },
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: tasksServices.accountsTemp.values.toList().length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                                    child: ClickOnAccount(
                                      fromPage: 'accounts',
                                      index: index,
                                    ));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
