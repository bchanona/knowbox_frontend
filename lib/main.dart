import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:knowbox/app.dart';
import 'package:knowbox/core/di/app_container.dart';
import 'package:knowbox/features/auth/di/auth_di.dart';
import 'package:knowbox/features/files/di/files_di.dart';

final AppContainer appContainer = AppContainer();
late final AuthDI authDI;
late final FilesDI filesDI;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appContainer.init();
  authDI = AuthDI(appContainer);
  filesDI = FilesDI(appContainer);

  await authDI.authProvider.initialize();

  runApp(
    DevicePreview(
        enabled: kIsWeb,
        builder: (context) => MyApp(
              authProvider: authDI.authProvider,
              filesProvider: filesDI.filesProvider,
            )),
  );
}
