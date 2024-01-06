import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../blockchain/interface.dart';
import 'package:flutter/material.dart';

class CreateJobHeader extends StatefulWidget {
  const CreateJobHeader({
    Key? key,
  }) : super(key: key);

  @override
  _CreateJobHeaderState createState() => _CreateJobHeaderState();
}

class _CreateJobHeaderState extends State<CreateJobHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    return Container(
      padding: const EdgeInsets.only(bottom: 18),
      width: interface.maxStaticDialogWidth,
      child: Row(
        children: [
          const SizedBox(
            width: 30,
          ),
          const Spacer(),
          Expanded(
              flex: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RichText(
                      // softWrap: false,
                      // overflow: TextOverflow.ellipsis,
                      // maxLines: 1,
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          // const WidgetSpan(
                          //     child: Padding(
                          //       padding:
                          //       EdgeInsets.only(right: 5.0),
                          //       child: Icon(
                          //         Icons.copy,
                          //         size: 20,
                          //         color: Colors.black26,
                          //       ),
                          //     )),
                          TextSpan(
                            text: 'Add new Task',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
          const Spacer(),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              // RouteInformation routeInfo = RouteInformation(
              //     location: '/${widget.fromPage}');
              // Beamer.of(context)
              //     .updateRouteInformation(routeInfo);
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(0.0),
              height: 30,
              width: 30,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(6),
              // ),
              child: const Row(
                children: <Widget>[
                  Expanded(
                    child: Icon(
                      Icons.close,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
