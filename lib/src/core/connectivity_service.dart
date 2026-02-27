import 'dart:io';

class ConnectivityService {
  Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 5));

      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}