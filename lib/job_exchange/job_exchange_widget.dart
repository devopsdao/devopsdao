import 'package:badges/badges.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';
import '../create_job/create_job_widget.dart';
import '../custom_widgets/loading.dart';
import '../custom_widgets/wallet_action.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';




// class ExchangeFilterWidget extends ChangeNotifier {
//   List<Task> filterResults = [];
//
//   void _runFilter(String enteredKeyword, _allTasks) {
//
//     filterResults.clear();
//     // filterResults = _allTasks.toList();
//     if (enteredKeyword.isEmpty) {
//       // if the search field is empty or only contains white-space, we'll display all tasks
//       filterResults = _allTasks.toList();
//       // print(filterResults);
//
//     } else {
//       for (int i = 0; i<_allTasks.length ; i++) {
//         if(_allTasks.elementAt(i).title.toLowerCase().contains(enteredKeyword.toLowerCase())) {
//           print('${_allTasks.elementAt(i).title}');
//           filterResults.add(_allTasks.elementAt(i));
//           // notifyListeners();
//         }
//       }
//     }
//     // Refresh the UI
//     notifyListeners();
//   }
// }


class JobExchangeWidget extends StatefulWidget {
  const JobExchangeWidget({Key? key}) : super(key: key);

  @override
  _JobExchangeWidgetState createState() => _JobExchangeWidgetState();
}

class _JobExchangeWidgetState extends State<JobExchangeWidget>
    with TickerProviderStateMixin {
  // String _searchKeyword = '';
  final _searchKeywordController = TextEditingController();

  // _changeField() {
  //   setState(() =>_searchKeyword = _searchKeywordController.text);
  // }

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
    // _searchKeywordController.text = '';
    // _searchKeywordController.addListener(() {_changeField();});
        startPageLoadAnimations(
      animationsMap.values
          .where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
      this,
    );
  }


  @override
  void dispose() {
    _searchKeywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    if(_searchKeywordController.text.isEmpty) {
        tasksServices.resetFilter();
    }

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
                  'Job Exchange',
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
        actions: [
          LoadButtonIndicator(),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(11, 11, 11, 11),
                child: Icon(
                  Icons.settings_outlined,
                  color: FlutterFlowTheme.of(context).primaryBtnText,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: Color(0xFF1E2429),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateJobWidget(),
            ),
          );
        },
        backgroundColor: FlutterFlowTheme.of(context).maximumBlueGreen,
        elevation: 8,
        child: Icon(
          Icons.add,
          color: Color(0xFFFCFCFC),
          size: 28,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0E2517), Color(0xFF0D0D50), Color(0xFF531E59)],
            stops: [0, 0.5, 1],
            begin: AlignmentDirectional(1, -1),
            end: AlignmentDirectional(-1, 1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: DefaultTabController(
                length: 1,
                initialIndex: 0,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                      decoration: BoxDecoration(
                        // color: Colors.white70,
                        // borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(

                        controller: _searchKeywordController,
                        onChanged: (_searchKeyword) {
                          // searchKeyword = value;
                          tasksServices.runFilter(_searchKeyword);
                          // print(tasksServices.tasksNew);
                        },
                        decoration: InputDecoration(
                            hintText: '[Find task by Title...]',
                            hintStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                            labelStyle: TextStyle(fontSize: 17.0, color: Colors.white),
                            labelText: 'Search', suffixIcon: Icon(Icons.search)),
                        ),
                      ),
                    // TabBar(
                    //   labelColor: Colors.white,с
                    //   labelStyle: FlutterFlowTheme.of(context).bodyText1,
                    //   indicatorColor: Color(0xFF47CBE4),
                    //   indicatorWeight: 3,
                    //   tabs: [
                    //     Tab(
                    //       text: 'New offers',
                    //     ),
                    //     // Tab(
                    //     //   text: 'Reserved tab',
                    //     // ),
                    //     // Tab(
                    //     //   text: 'Reserved tab',
                    //     // ),
                    //   ],
                    // ),

                    tasksServices.isLoading ?
                        LoadIndicator()
                        :
                    Expanded(
                      child: TabBarView(
                        children: [

                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                            child: RefreshIndicator(
                              onRefresh: () async {},
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                itemCount: tasksServices.filterResults.length,
                                itemBuilder: (context, index) {

                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16, 8, 16, 0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          // Toggle light when tapped.
                                        });
                                        showDialog(context: context, builder: (context) => AlertDialog(
                                          title: Text(tasksServices.filterResults[index].title),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                // Divider(
                                                //   height: 20,
                                                //   thickness: 1,
                                                //   indent: 40,
                                                //   endIndent: 40,
                                                //   color: Colors.black,
                                                // ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: 'Description: \n',
                                                          style: const TextStyle( fontWeight: FontWeight.bold)),
                                                      TextSpan(text: tasksServices.filterResults[index].description)
                                                    ]
                                                )),
                                                RichText(text: TextSpan(
                                                    style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: 'Contract value: \n',
                                                          style: const TextStyle(height: 2, fontWeight: FontWeight.bold)),
                                                      TextSpan(
                                                          text: tasksServices.filterResults[index].contractValue.toString() + ' Eth',
                                                          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0))
                                                    ]

                                                )),
                                                RichText(text: TextSpan(
                                                    style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: 'Contract owner: \n',
                                                          style: const TextStyle(height: 2, fontWeight: FontWeight.bold)),
                                                      TextSpan(
                                                          text: tasksServices.filterResults[index].contractOwner.toString(),
                                                          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7))
                                                    ]
                                                )),
                                                RichText(text: TextSpan(
                                                    style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: 'Contract address: \n',
                                                          style: const TextStyle(height: 2, fontWeight: FontWeight.bold)),
                                                      TextSpan(
                                                          text: tasksServices.filterResults[index].contractAddress.toString(),
                                                          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7)
                                                      )
                                                    ]
                                                )),
                                                RichText(text: TextSpan(
                                                    style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: 'Created: ',
                                                          style: const TextStyle(height: 2, fontWeight: FontWeight.bold)),
                                                      TextSpan(
                                                          text: DateFormat('MM/dd/yyyy, hh:mm a').format(tasksServices.filterResults[index].createdTime),

                                                      )
                                                    ]
                                                )),
                                                // Text("Description: ${exchangeFilterWidget.filterResults[index].description}",
                                                //   style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                                                // Text('Contract owner: ${exchangeFilterWidget.filterResults[index].contractOwner.toString()}',
                                                //   style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                                                // Text('Contract address: ${exchangeFilterWidget.filterResults[index].contractAddress.toString()}',
                                                //   style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                                                // Divider(
                                                //   height: 20,
                                                //   thickness: 0,
                                                //   indent: 40,
                                                //   endIndent: 40,
                                                //   color: Colors.black,
                                                // ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(child: Text('Close'), onPressed: () => Navigator.pop(context)),
                                            if(tasksServices.filterResults[index].contractOwner != tasksServices.ownAddress)
                                            TextButton(
                                              child: Text('Participate'),
                                              style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.green),
                                              onPressed: () {
                                                setState(() {
                                                  tasksServices.filterResults[index].justLoaded = false;
                                                });
                                                tasksServices.taskParticipation(tasksServices.filterResults[index].contractAddress);
                                                Navigator.pop(context);
                                                WalletAction();
                                            }),

                                          ],
                                        ));
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 86,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 5,
                                              color: Color(0x4D000000),
                                              offset: Offset(0, 2),
                                            )
                                          ],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12, 8, 8, 8),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          tasksServices.filterResults[index].title,
                                                          style: FlutterFlowTheme.of(context).subtitle1,
                                                        ),
                                                        Spacer(),
                                                        // Text(
                                                        //   'Value: ' +
                                                        //       tasksServices.filterResults[index].contractValue.toString()
                                                        //   + ' Eth',
                                                        //   style: FlutterFlowTheme.of(
                                                        //       context)
                                                        //       .bodyText2,
                                                        // ),
                                                      ],
                                                    ),

                                                    Text(
                                                      tasksServices.filterResults[index].description,
                                                      style: FlutterFlowTheme.of(
                                                          context)
                                                          .bodyText2,
                                                    ),

                                                    Row(
                                                      children: [
                                                        Text(
                                                          DateFormat('MM/dd/yyyy, hh:mm a').format(tasksServices.filterResults[index].createdTime),
                                                          style: FlutterFlowTheme.of(
                                                              context)
                                                              .bodyText2,
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          tasksServices.filterResults[index].contractValue.toString()
                                                              + ' Eth',
                                                          style: FlutterFlowTheme.of(
                                                              context)
                                                              .bodyText2,
                                                        ),
                                                      ],
                                                    ),




                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (tasksServices.filterResults[index].contributorsCount != 0 )

                                            Badge(
                                              // position: BadgePosition.topEnd(top: 10, end: 10),
                                              badgeContent: Text(
                                                  tasksServices.filterResults[index].contributorsCount.toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold)
                                              ),
                                              animationDuration: Duration(milliseconds: 1000),
                                              animationType: BadgeAnimationType.scale,
                                              shape: BadgeShape.square,
                                              borderRadius: BorderRadius.circular(5),
                                              // child: Icon(Icons.settings),
                                            ),

                                            if (tasksServices.filterResults[index].justLoaded == false)
                                            Padding(
                                              padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 12, 0),
                                              child: CircularProgressIndicator(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ).animated([animationsMap['containerOnPageLoadAnimation']!]),
    );
  }
}