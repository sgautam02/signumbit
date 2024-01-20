import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:SignumBeat/pages/NavigationPage.dart';
import 'package:SignumBeat/utils/AppColor.dart';
import 'package:SignumBeat/utils/permission.dart';

import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await checkPermission();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SignumBit',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.mainColor,
        ),
      ),
      darkTheme: ThemeData.dark(),
      home: NavigationPage(),
    );
  }
}
