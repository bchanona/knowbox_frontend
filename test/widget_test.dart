import 'package:flutter_test/flutter_test.dart';
import 'package:knowbox/app.dart';
import 'package:knowbox/core/di/app_container.dart';
import 'package:knowbox/features/auth/di/auth_di.dart';
import 'package:knowbox/features/files/di/files_di.dart';

void main() {
  testWidgets('App renders home page', (WidgetTester tester) async {
    final appContainer = AppContainer();
    final authDI = AuthDI(appContainer);
    final filesDI = FilesDI(appContainer);
    await tester.pumpWidget(MyApp(
      authProvider: authDI.authProvider,
      filesProvider: filesDI.filesProvider,
    ));
    expect(find.text('KnowBox'), findsOneWidget);
    appContainer.dispose();
  });
}
