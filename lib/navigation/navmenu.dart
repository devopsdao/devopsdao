import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_animate/icons_animate.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blockchain/task_services.dart';
import '../config/theme.dart';
import '../main.dart';
import '../nft_manager/main.dart';

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
        color: DodaoTheme.of(context).taskBackgroundColor,
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
                    Builder(builder: (context) {
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
                        onPressed: () {},
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

class SideBar extends StatelessWidget {
  const SideBar({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var modelTheme = context.read<ModelTheme>();
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        // padding: const EdgeInsets.only(left: 6, right: 6),
        // margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: DodaoTheme.of(context).background,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: DodaoTheme.of(context).menuButtonColor,
        textStyle: TextStyle(color: DodaoTheme.of(context).primaryText.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: DodaoTheme.of(context).borderRadius,
          border: Border.all(color: DodaoTheme.of(context).menuButtonColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: DodaoTheme.of(context).borderRadius,
          border: Border.all(
            color: DodaoTheme.of(context).menuButtonSelectedBorder.withOpacity(0.0),
          ),
          gradient: const LinearGradient(
            colors: [Colors.purpleAccent, Colors.deepOrangeAccent, Color(0xfffadb00)],
            stops: [0.1, 0.5, 1],
          ),
          boxShadow: [
            BoxShadow(
              color: DodaoTheme.of(context).flushForCopyBackgroundColor.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: DodaoTheme.of(context).primaryText.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 220,
        // margin: EdgeInsets.only(),
        //   itemPadding: const EdgeInsets.only(left: 10, right: 10),
        padding: const EdgeInsets.only(left: 14, right: 14),
        decoration: BoxDecoration(
          color: DodaoTheme.of(context).background,
        ),
      ),
      footerDivider: Divider(color: DodaoTheme.of(context).primaryText.withOpacity(0.3), height: 1),
      headerBuilder: (context, extended) {
        final double statusBarHeight = MediaQuery.of(context).viewPadding.top;
        return Column(
          children: [
            SizedBox(
              height: 105,
              child: Padding(
                  padding: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0, top: statusBarHeight),
                  child: AnimatedOpacity(
                    opacity: extended ? 1.0 : 0.0,
                    curve: !extended ? Curves.easeOutCirc : Curves.easeInExpo,
                    duration: const Duration(milliseconds: 450),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Image.asset(
                        //   'assets/images/logo.png',
                        //   filterQuality: FilterQuality.medium,
                        // ),
                        Builder(builder: (context) {
                          const Duration duration = Duration(milliseconds: 450);
                          return AnimatedIconButton(
                            // animationController: animationController,
                            size: 28,
                            onPressed: () {},
                            duration: duration,
                            initialIcon: modelTheme.isDark ? 1 : 0,
                            icons: <AnimatedIconItem>[
                              AnimatedIconItem(
                                icon: const Icon(
                                  Icons.nightlight_round,
                                  color: Colors.black87,
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
                        })
                      ],
                    ),
                  )),
            ),
          ],
        );
      },
      footerBuilder: (context, extended) {
        return Column(
          children: [
            if (extended)
              Container(
                  padding: const EdgeInsets.only(top: 13.0, bottom: 12),
                  alignment: Alignment.center,
                  child: InkWell(
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(
                          Icons.library_books_outlined,
                          color: DodaoTheme.of(context).primaryText,
                          size: 18,
                        ),
                        Text(
                          ' docs.dodao.dev',
                          style:
                              DodaoTheme.of(context).bodyText3.override(fontFamily: 'Inter', color: DodaoTheme.of(context).primaryText, fontSize: 12),
                        ),
                      ]),
                      onTap: () => launchUrl(Uri.parse('https://docs.dodao.dev/')))),
            if (extended)
              Text(
                  tasksServices.browserPlatform ??
                      'v${tasksServices.version}-${tasksServices.buildNumber};\nPlatform: ${tasksServices.platform};\nBrowser: ${tasksServices.browserPlatform}',
                  style: TextStyle(
                    height: 2,
                    fontWeight: FontWeight.bold,
                    color: DodaoTheme.of(context).primaryText,
                    fontSize: 10,
                  )),
          ],
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.dashboard_rounded,
          label: 'Dashboard',
          onTap: () {
            context.beamToNamed('/home');
          },
        ),
        SidebarXItem(
          icon: Icons.list_rounded,
          label: 'Tasks',
          onTap: () {
            context.beamToNamed('/tasks');
          },
        ),
        SidebarXItem(
          icon: Icons.work_rounded,
          label: 'Customer',
          onTap: () {
            context.beamToNamed('/customer');
          },
        ),
        SidebarXItem(
          icon: Icons.engineering_rounded,
          label: 'Performer',
          onTap: () {
            context.beamToNamed('/performer');
          },
        ),
        if (tasksServices.roleNfts['auditor'] > 0)
          SidebarXItem(
            icon: Icons.engineering_rounded,
            label: 'Auditor',
            onTap: () {
              context.beamToNamed('/auditor');
            },
          ),
        if (tasksServices.roleNfts['governor'] > 0)
          SidebarXItem(
            icon: Icons.engineering_rounded,
            label: 'Accounts',
            onTap: () {
              context.beamToNamed('/accounts');
            },
          ),
        SidebarXItem(
          icon: Icons.token_outlined,
          label: 'NFT Manager',
          onTap: () {
            // const TagManagerPage();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TagManagerPage()),
            );
          },
        ),
        // const SidebarXItem(
        //   icon: Icons.token_outlined,
        //   label: 'NFT Manager',
        // ),
      ],
    );
  }
}
