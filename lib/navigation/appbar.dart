import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';
import '../config/theme.dart';
import '../wallet/main.dart';
import '../widgets/loading.dart';
import '../widgets/tags/search_services.dart';

class OurAppBar extends StatelessWidget  implements PreferredSizeWidget  {
  final String title;
  final int tabIndex;
  // final BuildContext passedContext;
  const OurAppBar({
    Key? key,
    required this.title,
    required this.tabIndex,
    // required this.passedContext,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();
    var searchServices = context.read<SearchServices>();

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
              IconButton(
                onPressed: () {
                  AppBarWithSearchSwitch.of(context)?.startSearch();
                },
                icon: const Icon(Icons.search),
              ),
              if (tasksServices.platform == 'web' || tasksServices.platform == 'linux')
                const LoadButtonIndicator(),
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
          tasksServices.runFilter(taskList: tasksServices.tasksPerformerParticipate,
              tagsMap: searchServices.performerTagsList, enteredKeyword: searchKeyword);
        } else if (tabIndex == 1) {
          tasksServices.runFilter(taskList: tasksServices.tasksPerformerProgress,
              tagsMap: searchServices.performerTagsList, enteredKeyword: searchKeyword);
        } else if (tabIndex == 2) {
          tasksServices.runFilter(taskList: tasksServices.tasksPerformerComplete,
              tagsMap: searchServices.performerTagsList, enteredKeyword: searchKeyword);
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
        Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 14, top: 8, bottom: 8),
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
                    showDialog(
                      context: context,
                      builder: (context) => const WalletPageTop(),
                    );
                  },
                  child: tasksServices.walletConnected && tasksServices.publicAddress != null
                      ? Text(
                    '${tasksServices.publicAddress.toString().substring(0, 4)}'
                        '...'
                        '${tasksServices.publicAddress.toString().substring(tasksServices.publicAddress.toString().length - 4)}',
                    // textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  )
                      : const Text(
                    'Connect wallet',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  )),
            ),
          ),
        ),
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
