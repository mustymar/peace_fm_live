import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';
import 'package:prtv_stream/include/colors.inc.dart';

import '../include/app.state.inc.dart';
import '../include/app.stream.inc.dart';

AppStream appStream = AppStream();

class PRTVSplash extends StatefulWidget {
  const PRTVSplash({super.key});

  @override
  State<PRTVSplash> createState() => _PRTVSplashState();
}

class _PRTVSplashState extends State<PRTVSplash> {
  @override
  void initState() {
    super.initState();
    appStream.checkConnect(context);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: AppColor.primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).padding.top * 3,
                  horizontal: 40),
              child: Image.asset(
                "assets/image/prtv.png",
                fit: BoxFit.scaleDown,
                // width: 100,
                // height: 100,
              ),
            ),
            const Text(
              "Live Stream",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: AppColor.primaryColor),
            ),
            appState.connectionStatus == InternetStatus.connected
                ? const Padding(
                    padding: EdgeInsets.all(50.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ))
                : const Padding(
                    padding: EdgeInsets.symmetric(vertical: 50.0),
                    child: Text(
                      "No connection",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                          color: Colors.redAccent),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
