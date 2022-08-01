import 'package:expanded_listview_demo/subCategory.dart';
import 'package:flutter/material.dart';
import 'dataModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  List<Menu> data = [];

  get dataList => null;

  @override
  void initState() {
    dataList.forEach((element) {
      data.add(Menu.fromJson(element));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),

      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemCount: tasksServices.tasksAgreedSubmitter.length,
        itemBuilder: (context, index) {

          return Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
                16, 8, 16, 0),
            child: Container(
              // color: Colors.white,
              child: InkWell(
                onTap: () {
                  setState(() {
                    // Toggle light when tapped.
                  });
                  showDialog(context: context, builder: (context) => AlertDialog(
                    title: Text(tasksServices.tasksAgreedSubmitter[index].title),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text("Description: ${tasksServices.tasksAgreedSubmitter[index].description}",
                            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                          Text('Contract owner: ${tasksServices.tasksAgreedSubmitter[index].contractOwner.toString()}',
                            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                          Text('Contract address: ${tasksServices.tasksAgreedSubmitter[index].contractAddress.toString()}',
                            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                          Divider(
                            height: 20,
                            thickness: 1,
                            indent: 40,
                            endIndent: 40,
                            color: Colors.black,
                          ),
                          Text('text',
                            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                          // Container(
                          //   height: 300.0, // Change as per your requirement
                          //   width: 300.0, // Change as per your requirement
                          //   child: ListView.builder(
                          //     // padding: EdgeInsets.zero,
                          //     // scrollDirection: Axis.vertical,
                          //     //
                          //     // shrinkWrap: true,
                          //     // physics: NeverScrollableScrollPhysics(),
                          //       itemCount: tasksServices.tasksOwner[index].contributors.length,
                          //       itemBuilder: (context2, index2) {
                          //         return
                          //           Column(
                          //               children: [
                          //                 // Text(
                          //                 //   tasksServices.tasksOwner[index].contributors[index2].toString(),
                          //                 //   style: FlutterFlowTheme.of(
                          //                 //       context2)
                          //                 //       .bodyText2,
                          //                 // ),
                          //                 TextButton(
                          //                   style: TextButton.styleFrom(
                          //                     textStyle: const TextStyle(fontSize: 13),
                          //                   ),
                          //                   onPressed: () {
                          //                     tasksServices.changeTaskStatus(tasksServices.tasksOwner[index].contractAddress, 'agreed');
                          //                   },
                          //                   child: Text(tasksServices.tasksOwner[index].contributors[index2].toString()),
                          //                 ),]
                          //           );
                          //       }
                          //   ),
                          // ),

                        ],
                      ),

                    ),
                    actions: [
                      TextButton(child: Text('Close'), onPressed: () => Navigator.pop(context)),
                      TextButton(child: Text('Participate'), onPressed: () {
                        print('Button pressed ...');
                        // tasksServices.changeTaskStatus(
                        //     tasksServices.tasksOwner[index].contractAddress,
                        //     tasksServices.tasksOwner[index].contributors[index2],
                        //     ""
                        // );
                      })
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
                              Text(
                                tasksServices.tasksAgreedSubmitter[index].title,
                                style: FlutterFlowTheme.of(context).subtitle1,
                              ),
                              Text(
                                tasksServices.tasksAgreedSubmitter[index].description,
                                style: FlutterFlowTheme.of(
                                    context)
                                    .bodyText2,
                              ),
                              Text(
                                tasksServices.tasksAgreedSubmitter[index].contractOwner.toString(),
                                style: FlutterFlowTheme.of(
                                    context)
                                    .bodyText2,
                              ),

                            ],
                          ),
                        ),
                      ),

                      // tasksServices.tasksAgreed[index].contributorsCount != 0 ? Badge(
                      //
                      //   // position: BadgePosition.topEnd(top: 10, end: 10),
                      //   badgeContent: Text(
                      //     tasksServices.tasksAgreed[index].contributorsCount.toString(),
                      //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      //   ),
                      //   animationDuration: Duration(milliseconds: 300),
                      //   animationType: BadgeAnimationType.scale,
                      //   shape: BadgeShape.square,
                      //   borderRadius: BorderRadius.circular(5),
                      //   // borderSide: BorderSide(color: Colors.black, width: 3),
                      //   // child: Icon(Icons.settings),
                      // ) :
                      //
                      // Row(
                      // ),

                      Padding(
                        padding:
                        EdgeInsetsDirectional.fromSTEB(
                            0, 0, 12, 0),
                        child: Icon(
                          Icons.info_outlined,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),





          );
        },
        // children: [
        //
        // ],
      ),
    ),
  }

  Widget _drawer (List<Menu> data){
    return Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                UserAccountsDrawerHeader(margin: EdgeInsets.only(bottom: 0.0),
                    accountName: Text('demo'), accountEmail: Text('demo@webkul.com')),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder:(context, index){return _buildList(data[index]);},)
              ],
            ),
          ),
        ));
  }

  Widget _buildList(Menu list) {
    if (list.subMenu.isEmpty)
      return Builder(
          builder: (context) {
            return ListTile(
                onTap:() => Navigator.push(context, MaterialPageRoute(builder: (context) => SubCategory(list.name))),
                leading: SizedBox(),
                title: Text(list.name)
            );
          }
      );
    return ExpansionTile(
      leading: Icon(list.icon),
      title: Text(
        list.name,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: list.subMenu.map(_buildList).toList(),
    );
  }
}

class Menu {
  static Menu fromJson(element) {}
}