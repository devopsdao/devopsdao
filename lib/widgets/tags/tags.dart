import 'package:another_flushbar/flushbar.dart';
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
              return Center();
            }),
          );
        }),
      ),
    );
  }
}

