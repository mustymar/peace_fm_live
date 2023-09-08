import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class AppState extends ChangeNotifier {
  String? getCurrentStreamUrl;
  InternetStatus connectionStatus = InternetStatus.connected;
  StreamSubscription<InternetStatus>? subscription;

  void streamLink(String currentStreamLink) {
    getCurrentStreamUrl = currentStreamLink;
    notifyListeners();
  }

  void connectionStatusFn(InternetStatus status) {
    connectionStatus = status;
    notifyListeners();
  }
}
