import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  // Status koneksi jaringan
  var isConnected = true.obs;

  // Stream untuk memantau koneksi jaringan
  late final Stream<ConnectivityResult> _connectivityStream;

  @override
  void onInit() {
    super.onInit();

    // Inisialisasi stream untuk memantau perubahan koneksi
    _connectivityStream = Connectivity().onConnectivityChanged.map((results) {
      // Return the first result from the list or none if the list is empty
      return results.isNotEmpty ? results.first : ConnectivityResult.none;
    });

    // Pantau perubahan koneksi
    _connectivityStream.listen(_handleConnectivityChange);

    // Periksa status koneksi awal
    _checkInitialConnection();
  }

  void _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    isConnected.value = result != ConnectivityResult.none;
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    final wasConnected = isConnected.value;
    isConnected.value = result != ConnectivityResult.none;

    // Tampilkan snackbar saat status berubah
    if (wasConnected != isConnected.value) {
      _showConnectivitySnackbar(result);
    }
  }

  void _showConnectivitySnackbar(ConnectivityResult result) {
    String title;
    String message;

    switch (result) {
      case ConnectivityResult.wifi:
        title = "Wi-Fi Connected";
        message = "You are connected to Wi-Fi.";
        break;
      case ConnectivityResult.mobile:
        title = "Mobile Data Connected";
        message = "You are connected to mobile data.";
        break;
      case ConnectivityResult.none:
      default:
        title = "No Connection";
        message = "You are offline.";
        break;
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
    );
  }
}