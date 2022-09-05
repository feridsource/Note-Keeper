import 'dart:io';

import 'package:intl/intl.dart';

class Utility {
  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      bool isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      return isConnected;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Get now as a formatted date.
  static String getNow() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd kk:mm');
    return formatter.format(now);
  }
}