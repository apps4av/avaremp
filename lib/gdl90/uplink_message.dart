import 'dart:typed_data';

import 'package:latlong2/latlong.dart';

import 'fis_buffer.dart';
import 'message.dart';

class UplinkMessage extends Message {

  FisBuffer? fis;

  UplinkMessage(super.type);

  @override
  void parse(Uint8List message) {
    /*
     * First 3 bytes are Zulu time,
     * Next 8 is UAT header
     * Rest of 424 is payload
     *
     */
    int skip = 3;
    int lat = 0;
    lat += (message[skip + 0].toInt()) & 0xFF;
    lat <<= 8;
    lat += (message[skip + 1].toInt()) & 0xFF;
    lat <<= 8;
    lat += (message[skip + 2].toInt()) & 0xFE;
    lat >>= 1;

    bool isSouth = (lat & 0x800000) != 0;
    double degLat = lat.toDouble() * 2.1457672E-5;
    if (isSouth) {
      degLat *= -1;
    }

    int lon = 0;
    lon += (message[skip + 3].toInt()) & 0xFF;
    lon <<= 8;
    lon += (message[skip + 4].toInt()) & 0xFF;
    lon <<= 8;
    lon += (message[skip + 5].toInt()) & 0xFE;
    lon >>= 1;
    if ((message[skip + 2].toInt() & 0x01) != 0) {
      lon += 0x800000;
    }

    bool isWest = (lon & 0x800000) != 0;
    double degLon = (lon & 0x7fffff) * 2.1457672E-5;
    if (isWest) {
      degLon = -1 * (180 - degLon);
    }

    bool applicationDataValid = (message[skip + 6].toInt() & 0x20) != 0;
    if (false == applicationDataValid) {
      return;
    }

    // byte 9-432: application data (multiple iFrames).
    skip = 3 + 8;

    Uint8List data = message.sublist(skip);
    FisBuffer fisBuffer = FisBuffer(data, LatLng(degLat, degLon)); // this product does not happen at a location?

    //Now decode all.
    fisBuffer.makeProducts();
    fis = fisBuffer;
  }
}