import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_animate/icons_animate.dart';
import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';
import '../config/theme.dart';
import '../main.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  // late AnimateIconController controller;

  // var animationController = AnimationController(
  //   vsync: this,
  //   duration: Duration(milliseconds: 300),
  //   reverseDuration: Duration(milliseconds: 300),
  // );

  @override
  void initState() {
    // controller = AnimateIconController();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   var modelTheme = Provider.of<ModelTheme>(context, listen: false);
    //   // print(modelTheme.isDark);
    //   if (modelTheme.isDark) {
    //     controller.animateToEnd;
    //     print('dark');
    //   } else {
    //     controller.animateToStart;
    //     print('light');
    //   }
    // });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var modelTheme = context.read<ModelTheme>();



    return Drawer(
      child: Container(
        color:  DodaoTheme.of(context).taskBackgroundColor,
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
                    Builder(
                      builder: (context) {

                        // return AnimateIcons(
                        //   startIcon:Icons.wb_sunny,
                        //   endIcon: Icons.nightlight_round,
                        //   size: 28.0,
                        //   controller: controller,
                        //   // startTooltip: 'Icons.add_circle',
                        //   // endTooltip: 'Icons.add_circle_outline',
                        //   // add this for splashColor, default is Colors.transparent means no click effect
                        //   // splashColor: Colors.blueAccent.shade100.withAlpha(50),
                        //   // add this to specify a custom splashRadius
                        //   // default is Material.defaultSplashRadius (35)
                        //   splashRadius: 24,
                        //   onStartIconPress: () {
                        //     Future.delayed(const Duration(milliseconds: 501)).whenComplete(() {
                        //       modelTheme.isDark = false;
                        //       setState(() {
                        //         light = modelTheme.isDark ? false : true;
                        //       });
                        //     });
                        //     // themeNotifier.isDark
                        //     //           ? themeNotifier.isDark = false
                        //     //           : themeNotifier.isDark = true;
                        //     return true;
                        //   },
                        //   onEndIconPress: () {
                        //     Future.delayed(const Duration(milliseconds: 501)).whenComplete(() {
                        //       modelTheme.isDark = true;
                        //       setState(() {
                        //         light = modelTheme.isDark ? false : true;
                        //       });
                        //     });
                        //     // themeNotifier.isDark
                        //     //     ? themeNotifier.isDark = false
                        //     //     : themeNotifier.isDark = true;
                        //     return true;
                        //   },
                        //   duration: const Duration(milliseconds: 500),
                        //   startIconColor: Colors.white,
                        //   endIconColor: Colors.white,
                        //   clockwise: false,
                        // );

                        const Duration duration = Duration(milliseconds: 450);
                        return AnimatedIconButton(
                          // animationController: animationController,
                          size: 28,
                          onPressed: () {
                          },
                          duration: duration,
                          initialIcon: modelTheme.isDark ? 1 : 0,
                          icons: <AnimatedIconItem>[
                            AnimatedIconItem(
                              icon: const Icon(
                                Icons.nightlight_round,
                                color: Colors.white,
                                // size: 30,
                              ),
                              onPressed: () {
                                Future.delayed(duration).whenComplete(() {
                                  modelTheme.isDark = true;
                                });
                              },
                              // backgroundColor: Colors.white,
                            ),
                            AnimatedIconItem(
                              icon: const Icon(
                                Icons.light_mode,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Future.delayed(duration).whenComplete(() {
                                  modelTheme.isDark = false;
                                });
                              },
                              // backgroundColor: Colors.white,
                            ),

                          ],
                        );
                      }
                    )
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
            // ListTile(
            //   leading: Icon(Icons.brush),
            //   title: Text('Theme'),
            //   trailing: Switch(
            //     value: true,
            //     onChanged: (bool value) {
            //       // setState(() {
            //       //   _switchValue = value;
            //       // });
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
