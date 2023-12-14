import 'package:avaremp/storage.dart';
import 'package:avaremp/user_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'main_database_helper.dart';

class FindScreen extends StatefulWidget {
  const FindScreen({super.key});
  @override
  State<StatefulWidget> createState() => FindScreenState();
}

class FindScreenState extends State<FindScreen> {

  List<FindDestination>? _curItems;

  @override
  Widget build(BuildContext context) {

    bool searching = true;
    return FutureBuilder(
      future: MainDatabaseHelper.db.findDestinations("BOS"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _curItems = snapshot.data;
          searching = false;
        }
        return _makeContent(_curItems, searching);
      },
    );
  }

  void addRecent(FindDestination d) {
    Recent r = Recent(d.id, d.type, d.name);
    UserDatabaseHelper.db.addRecent(r);
  }

  Widget _makeContent(List<FindDestination>? items, bool searching) {
    if(null == items) {
      if(searching) {
        return const Center(child:CircularProgressIndicator());
      }
      return Container();
    }
    return
      Scaffold(
        body: Stack(children:
          [
            searching ? const Center(child:CircularProgressIndicator()) : Container() , // show progress indicator when searching
            ListView.separated(
              itemCount: items.length,
              padding: const EdgeInsets.all(30),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index].id),
                  subtitle: Text("${items[index].name} - ${items[index].type}"),
                  leading: _TypeIcons.getIcon(items[index].type),
                  onTap: () {
                    addRecent(items[index]);
                  },
                  onLongPress: () {
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
            Positioned(child: Text("sddjwidiw")),

          ]
        )
      );
  }
}

class _TypeIcons {

  static Icon getIcon(String type) {
    if(type == "TACAN" ||
        type == "NDB/DME" ||
        type == "MARINE NDB" ||
        type == "UHF/NDB" ||
        type == "NDB" ||
        type == "VOR/DME" ||
        type == "VOT" ||
        type == "VORTAC" ||
        type == "FAN MARKER" ||
        type == "VOR") {

      return Icon(MdiIcons.hexagonOutline);
    }
    else if(
    type == "AIRPORT" ||
        type == "SEAPLANE BAS" ||
        type == "HELIPORT" ||
        type == "ULTRALIGHT" ||
        type == "GLIDERPORT" ||
        type == "BALLOONPORT") {
      return Icon(MdiIcons.airport);
    }
    else if(
    type == "YREP-PT" ||
        type == "YRNAV-WP" ||
        type == "NARTCC-BDRY" ||
        type == "NAWY-INTXN" ||
        type == "NTURN-PT" ||
        type == "YWAYPOINT" ||
        type == "YMIL-REP-PT" ||
        type == "YCOORDN-FIX" ||
        type == "YMIL-WAYPOINT" ||
        type == "YNRS-WAYPOINT" ||
        type == "YVFR-WP" ||
        type == "YGPS-WP" ||
        type == "YCNF" ||
        type == "YRADAR" ||
        type == "NDME-FIX" ||
        type == "NNOT-ASSIGNED" ||
        type == "NDP-TRANS-XING" ||
        type == "NSTAR-TRANS-XIN" ||
        type == "NBRG-INTXN") {
      return Icon(MdiIcons.triangleOutline);
    }
    else if(type == "GPS") {
      return Icon(MdiIcons.crosshairsGps);
    }
    else if(type == "Maps") {
      return Icon(MdiIcons.mapMarker);
    }
    else if(type == "UDW") {
      return Icon(MdiIcons.flagTriangle);
    }
    return Icon(MdiIcons.help);
  }
}

