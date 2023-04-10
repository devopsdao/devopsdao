import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';
import '../config/theme.dart';
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
      backgroundColor: DodaoTheme.of(context).background,
      titleTextStyle:Theme.of(context).textTheme.titleMedium,
      toolbarTextStyle: Theme.of(context).textTheme.titleMedium,

      automaticallyImplyLeading: false,
      appBarBuilder: (context) {
        return AppBar(
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
