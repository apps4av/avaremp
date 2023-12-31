
import 'package:avaremp/chart.dart';
import 'package:avaremp/settings_cache_provider.dart';
import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';

class AppSettings {

  Future<void> initSettings() async {
    await Settings.init(
      cacheProvider: SettingsCacheProvider(),
    );
  }

  void setChartType(String chart) {
    Settings.setValue("key-chart-v1", chart);
  }

  String getChartType() {
    return Settings.getValue("key-chart-v1", defaultValue: ChartCategory.sectional) as String;
  }

  bool getNorthUp() {
    return Settings.getValue("key-north-up", defaultValue: true) as bool;
  }

  void setNorthUp(bool northUp) {
    Settings.setValue("key-north-up", northUp);
  }

  void setZoom(double zoom) {
    Settings.setValue("key-chart-zoom", zoom);
  }

  double getZoom() {
    return Settings.getValue("key-chart-zoom", defaultValue: 0.0) as double;
  }

  void setRotation(double rotation) {
    Settings.setValue("key-chart-rotation", rotation);
  }

  double getRotation() {
    return Settings.getValue("key-chart-rotation", defaultValue: 0.0) as double;
  }

  void setCenterLatitude(double l) {
    Settings.setValue("key-chart-center-latitude", l);
  }

  double getCenterLatitude() {
    return Settings.getValue("key-chart-center-latitude", defaultValue: 37.0) as double;
  }

  void setCenterLongitude(double l) {
    Settings.setValue("key-chart-center-longitude", l);
  }

  double getCenterLongitude() {
    return Settings.getValue("key-chart-center-longitude", defaultValue: -95.0) as double;
  }

  void setInstruments(String instruments) {
    Settings.setValue("key-instruments-v4", instruments);
  }

  String getInstruments() {
    return Settings.getValue("key-instruments-v4", defaultValue: "Gnd Speed,Alt,Track,Next,Distance,Bearing,Up Timer,UTC") as String;
  }

  List<String> getLayers() {
    return (Settings.getValue("key-layers-v5", defaultValue: "Nav,Circles,Chart,OSM") as String).split(",");
  }

  List<bool> getLayersState() {
    return (Settings.getValue("key-layers-state-v5", defaultValue: "true,false,true,true") as String).split(",").map((String e) => e == 'true' ? true : false).toList();
  }

  void setLayersState(List<bool> state) {
    Settings.setValue("key-layers-state-v5", state.map((bool e) => e.toString()).toList().join(","));
  }

  void setCurrentPlateAirport(String name) {
    Settings.setValue("key-current-plate-airport", name);
  }

  String getCurrentPlateAirport() {
    return Settings.getValue("key-current-plate-airport", defaultValue: "") as String;
  }


}
