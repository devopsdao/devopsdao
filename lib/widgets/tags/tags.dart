import 'package:another_flushbar/flushbar.dart';
import 'package:filter_list/filter_list.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';
import 'package:throttling/throttling.dart';

import 'package:flutter/material.dart';



class TagsPage extends StatefulWidget {
  const TagsPage({Key? key}) : super(key: key);

  @override
  _TagsPageState createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        // decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage(backgroundPicture),
          //     fit: BoxFit.scaleDown,
          //     alignment: Alignment.bottomRight
          // ),
        // ),
        color: Colors.white,
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: StatefulBuilder(builder: (context, setState) {
              final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
              final double screenHeightSizeNoKeyboard = constraints.maxHeight - 70;
              final double screenHeightSize = screenHeightSizeNoKeyboard - keyboardSize;
              return FilterListWidget<User>(
                listData: userList,
                selectedListData: selectedUserList,
                onApplyButtonClick: (list) {
                  // do something with list ..
                },
                choiceChipLabel: (item) {
                  /// Used to display text on chip
                  return item!.name;
                },
                validateSelectedItem: (list, val) {
                  ///  identify if item is selected or not
                  return list!.contains(val);
                },
                onItemSearch: (user, query) {
                  /// When search query change in search bar then this method will be called
                  ///
                  /// Check if items contains query
                  return user.name!.toLowerCase().contains(query.toLowerCase());
                },
              ),
            }),
          );
        }),
      ),
    );
  }
}

class SimpleTags {
  final String? tag;
  final String? avatar;
  SimpleTags({this.tag, this.avatar});
}

List<SimpleTags> SimpleTagsList = [
  SimpleTags(tag: "C++", avatar: ""),
  SimpleTags(tag: "Javascript ", avatar: ""),
  SimpleTags(tag: "Valarie ", avatar: ""),
  SimpleTags(tag: "Elyse ", avatar: ""),
  SimpleTags(tag: "Ethel ", avatar: ""),
  SimpleTags(tag: "Emelyan ", avatar: ""),
  SimpleTags(tag: "Catherine ", avatar: ""),
  SimpleTags(tag: "Stepanida  ", avatar: ""),
  SimpleTags(tag: "Carolina ", avatar: ""),
  SimpleTags(tag: "Nail  ", avatar: ""),
  SimpleTags(tag: "Kamil ", avatar: ""),
  SimpleTags(tag: "Mariana ", avatar: ""),
  SimpleTags(tag: "Katerina ", avatar: ""),
];

// class FilterPage extends StatelessWidget {
//   const FilterPage({Key? key, this.selectedUserList})
//       : super(key: key);
//   final List<User>? selectedUserList;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FilterListWidget<User>(
//         listData: userList,
//         selectedListData: selectedUserList,
//         onApplyButtonClick: (list) {
//           // do something with list ..
//         },
//         choiceChipLabel: (item) {
//           /// Used to display text on chip
//           return item!.name;
//         },
//         validateSelectedItem: (list, val) {
//           ///  identify if item is selected or not
//           return list!.contains(val);
//         },
//         onItemSearch: (user, query) {
//           /// When search query change in search bar then this method will be called
//           ///
//           /// Check if items contains query
//           return user.name!.toLowerCase().contains(query.toLowerCase());
//         },
//       ),
//     );
//   }
// }

