import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:avaremp/weather_cache.dart';
import 'package:avaremp/weather_database_helper.dart';
import 'package:csv/csv.dart';
import 'metar.dart';


class MetarCache extends WeatherCache {

  MetarCache(super.url, super.dbCall);

  @override
  Future<void> parse(Uint8List data) async {
    final List<int> decodedData = GZipCodec().decode(data);
    final List<Metar> metars = [];
    String decoded = utf8.decode(decodedData, allowMalformed: true);
    List<List<dynamic>> rows = const CsvToListConverter().convert(decoded, eol: "\n");
    for (List<dynamic> row in rows) {
      DateTime time = DateTime.now().toUtc();
      // observation time like 2024-01-27T18:26:00Z in row[2]
      time = time.add(const Duration(minutes: 10)); // they update every minute but that's too fast

      Metar m;
      try {
        m = Metar(row[1], time, row[0], row[30]);
        metars.add(m);
      }
      catch(e) {
        continue;
      }
    }
    WeatherDatabaseHelper.db.addMetars(metars);
  }
}
