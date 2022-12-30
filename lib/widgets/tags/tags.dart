import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/task_services.dart';
import 'wrapped_chip.dart';

class TagsPage extends StatefulWidget {
  const TagsPage({Key? key, required this.page}) : super(key: key);
  final String page;

  @override
  _TagsPageState createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  // late List<SimpleTags> selectedTagsListLocal = [];
  // TagsValueController tags = TagsValueController([]);
  late List<SimpleTags> selectedListData;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var interface = context.read<InterfaceServices>();
    // var tasksServices = context.read<TasksServices>();
    if (widget.page == 'audit') {
      selectedListData = interface.auditorTagsList;
    } else if (widget.page == 'tasks') {
      selectedListData = interface.tasksTagsList;
    } else if (widget.page == 'customer') {
      selectedListData = interface.customerTagsList;
    } else if (widget.page == 'performer') {
      selectedListData = interface.performerTagsList;
    } else {
      selectedListData = [];
    }


    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: constraints.maxHeight,
                child: FilterListWidget<SimpleTags>(
                  hideSelectedTextCount: true,
                  themeData: FilterListThemeData(
                    context,
                    wrapSpacing: 2.0,

                    headerTheme:  const HeaderThemeData(
                      headerTextStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      searchFieldTextStyle: TextStyle(color: Colors.black87),
                      searchFieldBackgroundColor: Color(0xfff5f5f5),
                      closeIconColor: Colors.black54,
                      searchFieldIconColor: Colors.black87,
                      backgroundColor: Colors.white,
                      searchFieldInputBorder: InputBorder.none,
                      boxShadow: [BoxShadow(color: Colors.brown)],
                      searchFieldBorderRadius: 10,
                      searchFieldHintText: 'Find your required tag here..',
                      searchFieldHintTextStyle: TextStyle(color: Colors.black54),
                    ),
                    choiceChipTheme: const ChoiceChipThemeData(
                        elevation: 4,
                        backgroundColor: Colors.black
                    ),
                    controlButtonBarTheme: ControlButtonBarThemeData(
                      context,

                      height: 86,
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.all(0.0),
                      buttonSpacing: 20,
                      backgroundColor: Colors.white,
                      controlButtonTheme: const ControlButtonThemeData(
                        buttonWidth: 130,
                        // primaryButtonBackgroundColor : Colors.black,
                        // backgroundColor: Colors.green,
                        borderRadius: 14,
                        // boxShadow: [BoxShadow(color: Colors.brown)],
                        // elevation: 3,
                        // padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                        // primaryButtonTextStyle: TextStyle(fontSize: 16, color: Colors.green),
                        // textStyle: TextStyle(
                        //   fontSize: 16,
                        //   color: Colors.black,
                        // ),

                      ),
                      decoration:  const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.0),
                        ),

                        color: Colors.transparent

                      )
                    ),
                  ),
                  controlButtons: const [
                    // ControlButtonType.All,
                    ControlButtonType.Reset,

                  ],
                  choiceChipBuilderSelected: (context, item, isSelected) {
                    return WrappedChip(
                      // key: ValueKey(simpleTagsList.indexOf(item)),
                      theme: 'white',
                      nft: item.nft ?? false,
                      name: item.tag,
                      control: false,
                      page: widget.page
                    );

                  },
                  choiceChipBuilder: (context, item, isSelected) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),

                            border: Border.all(
                              color: isSelected! ? Colors.orangeAccent[100]! : Colors.grey[400]!,
                                width: 1
                            ),
                            color: isSelected! ? Colors.orangeAccent[100]! : Colors.white!,
                          ),

                          child: RichText(
                            text: TextSpan(
                              children: [
                                if (item.nft == true)
                                   WidgetSpan(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 3.0),
                                      child: Icon(
                                        Icons.star,
                                        size: 17,
                                        color: isSelected! ? Colors.black : Colors.deepOrange),
                                    ),
                                  ),
                                TextSpan(
                                  text: item.tag,
                                  style: TextStyle(
                                    color: isSelected! ? Colors.black : Colors.black,
                                  )
                                ),

                              ],
                            ),
                          )
                        ),
                      ],
                    );
                  },
                  listData: simpleTagsList,
                  selectedListData: selectedListData,
                  onApplyButtonClick: (list) {
                    // do something with list ..
                    interface.updateTagList(list ?? [], page: widget.page);


                    // Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  choiceChipLabel: (item) {
                    /// Used to display text on chip
                    return item!.tag;
                  },
                  validateSelectedItem: (list, val) {
                    ///  identify if item is selected or not
                    // if (list!.contains(val) && !WrappedChip.tags.value.contains(val)) {
                    //   // WrappedChip.tags.value.add(val);
                    //   print(val);
                    //   WrappedChip.tags.value = List.from(WrappedChip.tags.value)..add(val);
                    // }
                    // if(!list!.contains(val) && WrappedChip.tags.value.contains(val)) {
                    //   // WrappedChip.tags.value.removeWhere((item) => item.tag == val.tag);
                    //   WrappedChip.tags.value = List.from(WrappedChip.tags.value)..removeWhere((item) => item.tag == val.tag);
                    // }
                    return list!.contains(val);
                  },
                  onItemSearch: (user, query) {
                    /// When search query change in search bar then this method will be called
                    ///
                    /// Check if items contains query
                    return user.tag!.toLowerCase().contains(query.toLowerCase());
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class SimpleTags {
  final String? tag;
  final String? icon;
  final bool? nft;
  final String? id;
  final bool? isInitial;
  SimpleTags({this.tag, this.icon, this.nft, this.id, this.isInitial});
}

List<SimpleTags> simpleTagsList = [
  SimpleTags(tag: "C++", icon: ""),
  SimpleTags(tag: "Javascript", icon: ""),
  SimpleTags(tag: "Ruby", icon: ""),
  SimpleTags(tag: "Dart", icon: "", nft: true),
  SimpleTags(tag: "Flutter", icon: "", nft: true),
  SimpleTags(tag: "JAVA", icon: ""),
  SimpleTags(tag: "Node.js", icon: ""),
  SimpleTags(tag: "C#", icon: ""),
  SimpleTags(tag: ".Net", icon: ""),
  SimpleTags(tag: "Redux", icon: ""),
  SimpleTags(tag: "MongoDb", icon: ""),
  SimpleTags(tag: "Solidity", icon: "", nft: true),
  SimpleTags(tag: "Kafka", icon: ""),
  SimpleTags(tag: "Maven", icon: ""),
  SimpleTags(tag: "Docker", icon: ""),
  SimpleTags(tag: "Jenkins", icon: ""),
  SimpleTags(tag: "Python", icon: ""),
  SimpleTags(tag: "Azure", icon: ""),
  SimpleTags(tag: "MS-SQL", icon: ""),

  SimpleTags(tag: "Axelar", icon: "", nft: true),
  SimpleTags(tag: "Hyperlane", icon: "", nft: true),
  SimpleTags(tag: "Diamond", icon: "", nft: true),
  SimpleTags(tag: "Web3", icon: "", nft: true),

  SimpleTags(tag: "Ruby on Rails", icon: ""),
  SimpleTags(tag: "REST", icon: ""),
  SimpleTags(tag: "MySQL", icon: ""),
  SimpleTags(tag: "pySPARK", icon: ""),
  SimpleTags(tag: "Pandas", icon: ""),
  SimpleTags(tag: "Data Scientist", icon: ""),
  SimpleTags(tag: "SQL like", icon: ""),
  SimpleTags(tag: "Rancher", icon: ""),
  SimpleTags(tag: "K8s", icon: ""),
  SimpleTags(tag: "Data Science", icon: ""),
  SimpleTags(tag: "Cloudera", icon: ""),
  SimpleTags(tag: "Suse linux", icon: ""),
  SimpleTags(tag: "RedHat", icon: ""),
  SimpleTags(tag: "Openshift", icon: ""),
  SimpleTags(tag: "Lambda", icon: ""),
  SimpleTags(tag: "GitLab CI/CD", icon: ""),
  SimpleTags(tag: "EC2", icon: ""),
  SimpleTags(tag: "Eclipse RCP", icon: ""),
  SimpleTags(tag: "JUnit", icon: ""),
  SimpleTags(tag: "SQL", icon: ""),
  SimpleTags(tag: "Moonbase", icon: ""),
  SimpleTags(tag: "Moonbase Alpha", icon: ""),

];

