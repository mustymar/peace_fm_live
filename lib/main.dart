import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:prtv_stream/screens/splash.scr.dart';

import 'include/app.state.inc.dart';
import 'include/colors.inc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColor.primaryColor,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => AppState(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Plateau Radio Television Radio - PRTV",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)
            .copyWith(background: Colors.black),
      ),
      home: const PRTVSplash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
