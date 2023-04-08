import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';
import '../main.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();

    return Drawer(

      child: Container(
        color: Colors.black26,
        child: ListView(

          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(

              decoration: const BoxDecoration(
                  color: Colors.black,
                  // image: DecorationImage(
                  //     fit: BoxFit.fill,
                  //     image: AssetImage('assets/images/cover.jpg'))
              ),
              child: Container(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Dodao',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Consumer<ModelTheme>(
                      builder: (context, ModelTheme themeNotifier, child) {
                        return IconButton(
                            icon: Icon(themeNotifier.isDark
                                ? Icons.nightlight_round
                                : Icons.wb_sunny, color: Colors.white,),
                            onPressed: () {
                              themeNotifier.isDark
                                  ? themeNotifier.isDark = false
                                  : themeNotifier.isDark = true;
                        });
                    })
                  ],
                ),
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.input),
            //   title: Text('Welcome'),
            //   onTap: () => {},
            // ),
            // ListTile(
            //   leading: Icon(Icons.verified_user),
            //   title: Text('Profile'),
            //   onTap: () => {Navigator.of(context).pop()},
            // ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            // ListTile(
            //   leading: Icon(Icons.border_color),
            //   title: Text('Feedback'),
            //   onTap: () => {Navigator.of(context).pop()},
            // ),
            ListTile(
              leading: Icon(Icons.brush),
              title: Text('Theme'),
              trailing: Switch(
                value: true,
                onChanged: (bool value) {
                  // setState(() {
                  //   _switchValue = value;
                  // });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
