/// Reads a Google encoded polyline (precision 5), the format the API sends as `routePolyline`, into latitude and longitude pairs.
/// Returns an empty list for text that is not a valid polyline, so a bad value draws no line instead of crashing the map.
List<({double lat, double lng})> decodePolyline(String? encoded) {
  final out = <({double lat, double lng})>[];
  if (encoded == null || encoded.isEmpty) return out;
  var i = 0, lat = 0, lng = 0;
  int? next() {
    var result = 0, shift = 0;
    int b;
    do {
      if (i >= encoded.length) return null;
      b = encoded.codeUnitAt(i++) - 63;
      if (b < 0 || b > 63) return null;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    return (result & 1) != 0 ? ~(result >> 1) : result >> 1;
  }

  while (i < encoded.length) {
    final dLat = next();
    final dLng = next();
    if (dLat == null || dLng == null) return <({double lat, double lng})>[];
    lat += dLat;
    lng += dLng;
    out.add((lat: lat / 1e5, lng: lng / 1e5));
  }
  return out;
}
