import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();

    _connectivity.onConnectivityChanged.listen((result) {
      isConnected.value = result != ConnectivityResult.none;
    });
  }
}
