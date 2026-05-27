


import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:knowbox/app.dart';

void main(){
  runApp(
    DevicePreview(
        enabled: kIsWeb,
        builder: (context) => const MyApp())
  );
}