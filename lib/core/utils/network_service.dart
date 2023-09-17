import 'package:connectivity/connectivity.dart';

class NetworkService {
  Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<String> checkNetworkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return "Connected to Mobile Network";
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return "Connected to WiFi Network";
    } else {
      return "No Network Connection";
    }
  }
}
