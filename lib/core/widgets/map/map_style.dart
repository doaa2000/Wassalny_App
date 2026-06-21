/// A clean, soft Google Maps style (light theme) used by [MapView].
///
/// Unlike a fully minimal style, this keeps **place names visible** (roads,
/// districts, parks, POIs) while muting the base colours so the map reads as a
/// calm-but-informative backdrop. Only administrative borders and transit are
/// hidden to cut clutter.
const String wassalnyMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#f5f6f8"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#5f6672"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#ffffff"},{"weight":2}]},
  {"featureType":"administrative","elementType":"geometry","stylers":[{"visibility":"off"}]},
  {"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},
  {"featureType":"poi","elementType":"geometry","stylers":[{"color":"#e9ece6"}]},
  {"featureType":"poi.business","elementType":"labels.icon","stylers":[{"visibility":"off"}]},
  {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#d8e8dc"}]},
  {"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#5b8a66"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},
  {"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#ffffff"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#ffe6bf"}]},
  {"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#f3d6a4"}]},
  {"featureType":"transit","stylers":[{"visibility":"off"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#bcd6e8"}]},
  {"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#6f97b3"}]}
]
''';
