import 'package:knowbox/core/network/http_client.dart';
import 'package:knowbox/core/storage/token_storage.dart';

class AppContainer {
  late final HttpClient httpClient;
  late final TokenStorage tokenStorage;

  Future<void> init() async {
    tokenStorage = TokenStorage();
    httpClient = HttpClient(baseUrl: 'http://localhost:3001');

    final savedToken = await tokenStorage.getToken();
    if (savedToken != null) {
      httpClient.setToken(savedToken);
    }
  }

  void dispose() {
    httpClient.dispose();
  }
}
