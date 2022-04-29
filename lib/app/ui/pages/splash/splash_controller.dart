import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:flutter_google_maps/app/ui/routes/routes.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends ChangeNotifier {
  final Permission _locationPermission;
  String? _routesName;
  String? get routesName => _routesName;

  SplashController(this._locationPermission);

  Future<void> checkPermission() async {
    final isGranted = await _locationPermission.isGranted;
    _routesName = isGranted ? Routes.HOME : Routes.PERMISSIONS;
    notifyListeners();
  }
}
