import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../customer_page/customer_page_widget.dart';

class HomeLocation extends BeamLocation {
  // @override
  // List<BeamPage> get pages => [CustomerPageWidget.beamLocation];
  //
  // @override
  // String get pathBlueprint => CustomerPageWidget.path;

  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable state) {
    throw UnimplementedError();
  }

  @override
  List<Pattern> get pathPatterns => throw UnimplementedError();
  
}