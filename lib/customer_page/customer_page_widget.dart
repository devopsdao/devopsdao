import 'package:badges/badges.dart';
import 'package:devopsdao/custom_widgets/payment.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../create_job/create_job_widget.dart';
import '../custom_widgets/badgetab.dart';
import '../custom_widgets/task_dialog.dart';
import '../custom_widgets/loading.dart';
import '../custom_widgets/participants_list.dart';
import '../custom_widgets/task_item.dart';
import '../custom_widgets/wallet_action.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:beamer/beamer.dart';

class CustomerPageWidget extends StatefulWidget {
  // static final beamLocation = BeamPage(key: ValueKey('Home'), child: CustomerPageWidget());
  // static final path = '/';
  final String? taskAddress;
  const CustomerPageWidget({Key? key, this.taskAddress}) : super(key: key);

  @override
  _CustomerPageWidgetState createState() => _CustomerPageWidgetState();
}

class _CustomerPageWidgetState extends State<CustomerPageWidget>
    // with TickerProviderStateMixin
{
  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 1000,
      delay: 1000,
      hideBeforeAnimating: false,
      fadeIn: false, // changed to false(orig from FLOW true)
      initialState: AnimationState(
        opacity: 0,
      ),
      finalState: AnimationState(
        opacity: 1,
      ),
    ),
  };
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (widget.taskAddress != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (context) => TaskDialog(taskAddress: widget.taskAddress!, role: 'customer',));
      });
    }

    // startPageLoadAnimations(
    //   animationsMap.values
    //       .where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
    //   this,
    // );
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();

    bool _lightIsOn = false;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Customer',
                  style: FlutterFlowTheme.of(context).title2.override(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 22,
                      ),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          LoadButtonIndicator(),
          // Row(
          //   mainAxisSize: MainAxisSize.max,
          //   children: [
          //     LoadButtonIndicator(),
          //     Padding(
          //       padding: EdgeInsetsDirectional.fromSTEB(11, 11, 11, 11),
          //       child: Icon(
          //         Icons.settings_outlined,
          //         color: FlutterFlowTheme.of(context).primaryBtnText,
          //         size: 24,
          //       ),
          //     ),
          //   ],
          // ),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFF1E2429),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => CreateJobWidget(),
      //       ),
      //     );
      //   },
      //   backgroundColor: FlutterFlowTheme.of(context).maximumBlueGreen,
      //   elevation: 8,
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //     size: 28,
      //   ),
      // ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0E2517), Color(0xFF0D0D50), Color(0xFF531E59)],
            stops: [0, 0.5, 1],
            begin: AlignmentDirectional(1, -1),
            end: AlignmentDirectional(-1, 1),
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            // fit: BoxFit.cover,
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: DefaultTabController(
                length: 3,
                initialIndex: 0,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.white,
                      labelStyle: FlutterFlowTheme.of(context).bodyText1,
                      indicatorColor: const Color(0xFF47CBE4),
                      indicatorWeight: 3,
                      // isScrollable: true,
                      tabs: [
                        Tab(
                          child: BadgeTab(
                            taskCount:
                                tasksServices.tasksCustomerApplied.length,
                            tabText: 'Selection',
                          ),
                        ),
                        Tab(
                          child: BadgeTab(
                              taskCount:
                                  tasksServices.tasksCustomerWorking.length,
                              tabText: 'Progress'),
                        ),
                        Tab(
                          child: BadgeTab(
                              taskCount:
                                  tasksServices.tasksCustomerComplete.length,
                              tabText: 'Complete'),
                        ),
                      ],
                    ),
                    tasksServices.isLoading
                        ? const LoadIndicator()
                        : Expanded(
                            child: TabBarView(
                              children: [
                                mySubmitterTabWidget(
                                    obj: tasksServices
                                        .tasksCustomerApplied), //new
                                mySubmitterTabWidget(
                                    obj: tasksServices
                                        .tasksCustomerWorking), //agreed
                                mySubmitterTabWidget(
                                    obj: tasksServices
                                        .tasksCustomerComplete), //completed & canceled
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          // .animated([animationsMap['containerOnPageLoadAnimation']!]),
    );
  }
}

class mySubmitterTabWidget extends StatefulWidget {
  final Map<String, Task>? obj;
  const mySubmitterTabWidget({
    Key? key,
    required this.obj,
  }) : super(key: key);

  @override
  _mySubmitterTabWidgetState createState() => _mySubmitterTabWidgetState();
}

class _mySubmitterTabWidgetState extends State<mySubmitterTabWidget> {
  late bool justLoaded = true;
  bool enableRatingButton = false;
  double ratingScore = 0;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    List objList = widget.obj!.values.toList();
    // TODO: implement build
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
        child: RefreshIndicator(
          onRefresh: () async {
            tasksServices.isLoadingBackground = true;
            tasksServices.fetchTasks();
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: widget.obj?.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                child: InkWell(
                  onTap: () {
                    // setState(() {
                    //   // Toggle light when tapped.
                    // });
                    // showDialog(
                    //     context: context,
                    //     builder: (context) => TaskInformationDialog(
                    //           role: 'customer',
                    //           object: objList[index],
                    //         ));
                    final taskAddress = tasksServices.filterResults.values
                        .toList()[index]
                        .taskAddress;
                    context.beamToNamed('/customer/$taskAddress');
                  },
                  child: TaskItem(
                    role: 'customer',
                    object: objList[index],
                  )

                ),
              );
            },
          ),
        ));
  }
}
