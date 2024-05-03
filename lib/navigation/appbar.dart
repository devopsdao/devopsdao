import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webthree/credentials.dart';

import '../blockchain/classes.dart';
import '../blockchain/task_services.dart';
import '../config/theme.dart';
import '../wallet/widgets/main/main.dart';
import '../widgets/loading.dart';
import '../widgets/tags/search_services.dart';
import '../widgets/tags_on_page_open_container.dart';

class OurAppBar extends StatelessWidget  implements PreferredSizeWidget  {
  final String title;
  final int tabIndex;
  final String page;
  // final BuildContext passedContext;
  const OurAppBar({
    Key? key,
    required this.title,
    required this.tabIndex,
    required this.page
    // required this.passedContext,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    TasksServices tasksServices = context.read<TasksServices>();
    SearchServices searchServices = context.read<SearchServices>();
    late Map<EthereumAddress, Task> participate;
    late Map<EthereumAddress, Task> progress;
    late Map<EthereumAddress, Task> complete;
    late Map<String, NftCollection> tagsList;
    if(page == 'performer') {
      participate = tasksServices.tasksPerformerParticipate;
      progress = tasksServices.tasksPerformerProgress;
      complete = tasksServices.tasksPerformerComplete;
      tagsList =  searchServices.performerTagsList;
    } else if (page == 'customer') {
      participate = tasksServices.tasksCustomerSelection;
      progress = tasksServices.tasksCustomerProgress;
      complete = tasksServices.tasksCustomerComplete;
      tagsList =  searchServices.customerTagsList;
    }

    return AppBarWithSearchSwitch(
      backgroundColor: Colors.transparent,
      titleTextStyle:Theme.of(context).textTheme.titleMedium,
      toolbarTextStyle: Theme.of(context).textTheme.titleMedium,

      automaticallyImplyLeading: false,
      appBarBuilder: (context) {
        return AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            actions: [
              if (page != 'accounts' && page != 'auditor')
              OpenMyAddTags(
                page: page,
                tabIndex: tabIndex,
              ),
              InkResponse(
                radius: DodaoTheme.of(context).inkRadius,
                containedInkWell: true  ,
                child: const Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Icon(Icons.search),
                ),
                onTap: () {
                  AppBarWithSearchSwitch.of(context)?.startSearch();
                },
              ),
              if (tasksServices.platform == 'web' || tasksServices.platform == 'linux')
                LoadButtonIndicator(refresh: page,),
            ]
        );
      },
      keepAppBarColors: false,
      // iconTheme: IconThemeData(color: Colors.black, ),
      searchInputDecoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Search',

        hintStyle: Theme.of(context).textTheme.titleMedium,


        // labelStyle: Theme.of(context).textTheme.titleMedium,
        // helperStyle: Theme.of(context).textTheme.titleMedium,
        // floatingLabelStyle: Theme.of(context).textTheme.titleMedium,
        // fillColor: Colors.black,
        // focusColor: Colors.black,
        //   hoverColor: Colors.black,
        // prefixStyle: Theme.of(context).textTheme.titleLarge,

        // suffixIcon: Icon(
        //   Icons.tag,
        //   color: Colors.grey[300],
        // ),

      ),

      onChanged: (searchKeyword) {
        if (tabIndex == 0) {
          tasksServices.runFilter(taskList: participate,
              tagsMap: tagsList, enteredKeyword: searchKeyword);
        } else if (tabIndex == 1) {
          tasksServices.runFilter(taskList: progress,
              tagsMap: tagsList, enteredKeyword: searchKeyword);
        } else if (tabIndex == 2) {
          tasksServices.runFilter(taskList: complete,
              tagsMap: tagsList, enteredKeyword: searchKeyword);
        }
      },
      customTextEditingController: searchServices.searchKeywordController,
      customIsSearchModeNotifier: searchServices.searchBarStart,
      // actions: [
      //   // IconButton(
      //   //   onPressed: () {
      //   //     showSearch(
      //   //       context: context,
      //   //       delegate: MainSearchDelegate(),
      //   //     );
      //   //   },
      //   //   icon: const Icon(Icons.search)
      //   // ),
      //   // LoadButtonIndicator(),
      // ],
      centerTitle: false,
      elevation: 2,
    );
  }
}


class HomeAppBar extends StatelessWidget  implements PreferredSizeWidget  {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();

    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      // automaticallyImplyLeading: false,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('Dodao', style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
      actions: [
        // Center(
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 6.0, right: 14, top: 8, bottom: 8),
        //     child: Container(
        //       // width: 150,
        //       height: 30,
        //       padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        //
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(16),
        //         gradient: const LinearGradient(
        //           colors: [Colors.purpleAccent, Colors.deepOrangeAccent, Color(0xfffadb00)],
        //           stops: [0.1, 0.5, 1],
        //         ),
        //       ),
        //       child: InkWell(
        //           highlightColor: Colors.white,
        //           onTap: () async {
        //             showDialog(
        //               context: context,
        //               builder: (context) => const WalletPageTop(),
        //             );
        //           },
        //           child: tasksServices.walletConnected && listenWalletAddress != null
        //               ? Text(
        //             '${listenWalletAddress.toString().substring(0, 4)}'
        //                 '...'
        //                 '${listenWalletAddress.toString().substring(listenWalletAddress.toString().length - 4)}',
        //             // textAlign: TextAlign.center,
        //             style: const TextStyle(fontSize: 14, color: Colors.white),
        //           )
        //               : const Text(
        //             'Connect wallet',
        //             textAlign: TextAlign.center,
        //             style: TextStyle(fontSize: 14, color: Colors.white),
        //           )),
        //     ),
        //   ),
        // ),
        if (!tasksServices.isDeviceConnected)
          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 14),
            child: Icon(
              Icons.cloud_off,
              color: DodaoTheme.of(context).primaryText,
              size: 26,
            ),
          ),
      ],
    );
  }
}
