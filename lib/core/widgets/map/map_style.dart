/// A clean, soft Google Maps style (light theme) used by [MapView].
///
/// It mutes the default colours, hides most points-of-interest clutter and
/// transit noise, and tints water/roads to match the Wassalny palette so the
/// map reads as a calm backdrop behind the booking sheets.
const String wassalnyMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#f5f6f8"}]},
  {"elementType":"labels.icon","stylers":[{"visibility":"off"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#8a93a6"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#f5f6f8"}]},
  {"featureType":"administrative","elementType":"geometry","stylers":[{"visibility":"off"}]},
  {"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},
  {"featureType":"administrative.neighborhood","stylers":[{"visibility":"off"}]},
  {"featureType":"poi","stylers":[{"visibility":"off"}]},
  {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#dcece0"}]},
  {"featureType":"poi.park","elementType":"labels.text","stylers":[{"visibility":"off"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},
  {"featureType":"road","elementType":"labels","stylers":[{"visibility":"off"}]},
  {"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#ffffff"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#ffe9c7"}]},
  {"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#f4d9a8"}]},
  {"featureType":"road.local","elementType":"labels","stylers":[{"visibility":"off"}]},
  {"featureType":"transit","stylers":[{"visibility":"off"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#bcd6e8"}]},
  {"featureType":"water","elementType":"labels.text","stylers":[{"visibility":"off"}]}
]
''';
