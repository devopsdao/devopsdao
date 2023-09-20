import 'package:dodao/tags_manager/pages/mint.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';
import '../task_dialog/beamer.dart';
import '../widgets/badgetab.dart';
import '../widgets/tags/search_services.dart';
import '../config/theme.dart';
import 'package:flutter/material.dart';

import 'package:webthree/credentials.dart';

import 'collection_services.dart';
import 'pages/treasury.dart';

class TagManagerPage extends StatefulWidget {
  final EthereumAddress? taskAddress;
  const TagManagerPage({Key? key, this.taskAddress}) : super(key: key);

  @override
  _TagManagerPagetState createState() => _TagManagerPagetState();
}

class _TagManagerPagetState extends State<TagManagerPage> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 2);
  }

  final _searchKeywordController = TextEditingController();
  @override
  void dispose() {
    _searchKeywordController.dispose();
    super.dispose();
  }

  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    // var tasksServices = context.read<TasksServices>();
    var interface = context.read<InterfaceServices>();
    var searchServices = context.read<SearchServices>();
    var collectionServices = context.read<CollectionServices>();

    // start();

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: DodaoTheme.of(context).taskBackgroundColor,
      appBar: AppBar(
        // backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Tags Manager',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // searchServices.resetNFTFilter(searchServices.treasuryPageFilterResults);
              searchServices.tagSelection(
                unselectAll: true,
                tagName: '', typeSelection: 'treasury', tagKey: ''
              );
              searchServices.tagSelection(
                  unselectAll: true,
                  tagName: '', typeSelection: 'mint', tagKey: ''
              );
              collectionServices.clearSelectedInManager();
              Navigator.of(context).pop(null);
            },
          ),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
        alignment: Alignment.center,
        decoration: const BoxDecoration(

        ),
        child: SizedBox(
            width: interface.maxStaticGlobalWidth,
            child: Column(
              children: [
                TabBar(
                  physics: const NeverScrollableScrollPhysics(),
                  labelStyle: Theme.of(context).textTheme.bodyMedium,

                  labelColor: DodaoTheme.of(context).secondaryText,
                  indicatorColor: DodaoTheme.of(context).tabIndicator,
                  indicatorWeight: 3,
                  // isScrollable: true,
                  controller: _controller,
                  onTap: (index) {
                    // searchServices.resetNFTFilter(searchServices.treasuryPageFilterResults);
                    searchServices.tagSelection(unselectAll: true, tagName: '', typeSelection: 'treasury', tagKey: '');
                    collectionServices.clearSelectedInManager();
                  },
                  tabs: const [
                    Tab(
                      text: 'Mint',
                    ),
                    Tab(
                      text: 'The treasury',
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _controller,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      MintWidget(),
                      TreasuryWidget(),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

// class ChipNotifierWrapper extends StatefulWidget {
//   final Widget child;
//   ChipNotifierWrapper({Key? key, required this.child}) : super(key: key);
//
//   static ChipNotifierWrapperState of(BuildContext context) {
//     return (context.dependOnInheritedWidgetOfExactType<ChipNotifier>())!.data;
//   }
//
//   @override
//   ChipNotifierWrapperState createState() => ChipNotifierWrapperState();
// }
//
// class ChipNotifierWrapperState extends State<ChipNotifierWrapper> {
//   int counter = 0;
//
//   void incrementCounter() {
//     setState(() {
//       counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ChipNotifier(
//         data: this,
//         counter:counter,
//         child: widget.child
//     );
//   }
// }
//
// class ChipNotifier extends InheritedWidget {
//   ChipNotifier({
//     Key? key,
//     required this.child,
//     required this.data,
//     required this.counter
//   }) : super(key: key, child: child);
//
//   final Widget child;
//   final int counter;
//   final ChipNotifierWrapperState data;
//
//
//   @override
//   bool updateShouldNotify(ChipNotifier oldWidget) {
//     return counter != oldWidget.counter;
//   }
// }

