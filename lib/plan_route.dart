
import 'package:avaremp/airway.dart';
import 'package:avaremp/geo_calculations.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'destination.dart';

class PlanRoute {

  // all segments
  final List<Waypoint> _waypoints = [];
  List<LatLng> _pointsPassed = [];
  List<LatLng> _pointsCurrent = [];
  List<LatLng> _pointsNext = [];
  Waypoint? _current;
  final change = ValueNotifier<int>(0);

  void _airwayAdjust(Waypoint waypoint) {

    waypoint.currentAirwaySegment = 0; // on change to airway, reset it
    waypoint.airwaySegmentsOnRoute = [];

    // adjust airways, nothing to do when airway is not in the middle of points
    int index = _waypoints.indexOf(waypoint);
    // need a start and end
    if(index == 0 || index == _waypoints.length - 1) {
      return;
    }

    // replace the airway with the new airway with the right points
    List<Destination> points = Airway.find(
        _waypoints[index - 1].destination,
        _waypoints[index].destination as AirwayDestination,
        _waypoints[index + 1].destination);
    if(points.isNotEmpty) {
      waypoint.airwaySegmentsOnRoute = points;
    }
  }

  void _update(bool pathsOnly) {

    if(_waypoints.isNotEmpty) {
      _current ??= _waypoints[0];
    }

    if(_waypoints.length < 2) {
      _pointsPassed = [];
      _pointsCurrent = [];
      _pointsNext = [];
      return;
    }

    // find path
    List<Destination> path = [];
    List<int> status = [];
    int cIndex = _current == null ? 0 : _waypoints.indexOf(_current!);
    for(int index = 0; index < _waypoints.length; index++) {
      Destination destination = _waypoints[index].destination;
      if(Destination.isAirway(destination.type)) {
        pathsOnly ? _airwayAdjust(_waypoints[index]) : {}; // add all airways
        path.addAll(_waypoints[index].airwaySegmentsOnRoute);
        index == cIndex ? status.addAll(_waypoints[index].airwaySegmentsOnRoute.map((e) => 0)) : {};
        index > cIndex ? status.addAll(_waypoints[index].airwaySegmentsOnRoute.map((e) => 1)) : {};
        index < cIndex ? status.addAll(_waypoints[index].airwaySegmentsOnRoute.map((e) => -1)) : {};
      }
      else {
        path.add(destination);
        index == cIndex ? status.add(0) : {};
        index > cIndex ? status.add(1) : {};
        index < cIndex ? status.add(-1) : {};
      }
    }

    GeoCalculations calc = GeoCalculations();
    //2 at a time
    _pointsPassed = [];
    _pointsCurrent = [];
    _pointsNext = [];
    for(int index = 0; index < path.length - 1; index++) {
      LatLng destination1 = path[index].coordinate;
      LatLng destination2 = path[index + 1].coordinate;
      List<LatLng> routeIntermediate = calc.findPoints(destination1, destination2);
      (status[index] == 0) ? _pointsCurrent.addAll(routeIntermediate) : {};
      (status[index] == 1) ? _pointsNext.addAll(routeIntermediate) : {};
      (status[index] == -1) ? _pointsPassed.addAll(routeIntermediate) : {};
    }
  }

  Waypoint removeWaypointAt(int index) {
    Waypoint waypoint = _waypoints.removeAt(index);
    _current = (waypoint == _current) ? null : _current; // clear next its removed
    _update(true);
    change.value++;
    return(waypoint);
  }

  void addDirectTo(Waypoint waypoint) {
    addWaypoint(waypoint);
    _current = _waypoints[_waypoints.indexOf(waypoint)]; // go here
    _update(true);
    change.value++;
  }

  void addWaypoint(Waypoint waypoint) {
    _waypoints.add(waypoint);
    _update(true);
    change.value++;
  }

  void moveWaypoint(int from, int to) {
    Waypoint waypoint = _waypoints.removeAt(from);
    _waypoints.insert(to, waypoint);
    _update(true);
    change.value++;
  }


  void setNextWithWaypoint(Waypoint waypoint) {
    _current = _waypoints[_waypoints.indexOf(waypoint)];
    _update(false);
    change.value++;
  }

  void setNext(int index) {
    _current = _waypoints[index];
    _update(false);
    change.value++;
  }

  Waypoint getWaypointAt(int index) {
    return _waypoints[index];
  }

  List<LatLng> getPathPassed() {
    return _pointsPassed;
  }

  List<LatLng> getPathCurrent() {
    return _pointsCurrent;
  }

  List<LatLng> getPathNext() {
    return _pointsNext;
  }

  List<LatLng> getPathFromLocation(Position position) {
    Destination? destination = getCurrentWaypoint()?.destination;
    if(destination == null) {
      return [];
    }
    LatLng destination1 = LatLng(position.latitude, position.longitude);
    LatLng destination2 = destination.coordinate;
    List<LatLng> points = GeoCalculations().findPoints(destination1, destination2);
    return points;
  }

  Waypoint? getCurrentWaypoint() {
    // if no route then destination
    return _current;
  }

  bool isNext(int index) {
    if(_current == null) {
      return false;
    }
    return _waypoints.indexOf(_current!) == index;
  }

  int get length => _waypoints.length;

}


class Waypoint {

  final Destination _destination;
  List<Destination> airwaySegmentsOnRoute = [];
  int currentAirwaySegment = 0;

  Waypoint(this._destination);

  Destination get destination {
    return airwaySegmentsOnRoute.isNotEmpty ? airwaySegmentsOnRoute[currentAirwaySegment] : _destination;
  }

}