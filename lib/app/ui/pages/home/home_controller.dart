import 'dart:async';

import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};

  Set<Marker> get markers => _markers.values.toSet();

  final _markersController = StreamController<String>.broadcast();

  Stream<String> get onMarkerTap => _markersController.stream;

  final initialCameraPosition = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 0,
  );

  bool _loading = true;
  bool get loading => _loading;

  late bool _gpsEnable;
  bool get gpsEnable => _gpsEnable;

  StreamSubscription? _gpsSubscription;

  Future<void> turnOnGPS() => Geolocator.openLocationSettings();

  void onLongPress(LatLng position) {
    final id = _markers.length.toString();
    final markerId = MarkerId(id);
    final marker = Marker(
        markerId: markerId,
        position: position,
        onTap: () {
          _markersController.sink.add(id);
        });

    _markers[markerId] = marker;
    notifyListeners();
  }

  HomeController() {
    _init();
  }

  Future<void> _init() async {
    _gpsEnable = await Geolocator.isLocationServiceEnabled();

    _loading = false;

    _gpsSubscription = Geolocator.getServiceStatusStream().listen(
      (status) {
        _gpsEnable = status == ServiceStatus.enabled;
        notifyListeners();
      },
    );

    notifyListeners();
  }

  @override
  void dispose() {
    _gpsSubscription?.cancel();
    _markersController.close();
    super.dispose();
  }
}
