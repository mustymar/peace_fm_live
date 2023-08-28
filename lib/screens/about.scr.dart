// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:prtv_stream/include/colors.inc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PRTVAbout extends StatefulWidget {
  const PRTVAbout({super.key});

  @override
  State<PRTVAbout> createState() => _PRTVAboutState();
}

class _PRTVAboutState extends State<PRTVAbout> {
  WebViewController controller = WebViewController();
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await controller.canGoBack()) {
          controller.goBack();
          return false;
        } else {
          Navigator.of(context).pop();
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: AppColor.primaryColor,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.close_outlined,
                    color: AppColor.primaryColor,
                    size: 20,
                  ),
                  onPressed: () {
                    controller.clearCache();
                    controller.clearLocalStorage();
                    WebViewCookieManager().clearCookies();
                    Navigator.of(context).pop();
                  },
                ),
                const Expanded(
                  child: SizedBox(
                    width: double.infinity,
                  ),
                ),
                IconButton(
                    icon: const Icon(
                      Icons.refresh_outlined,
                      color: AppColor.primaryColor,
                      size: 20,
                    ),
                    onPressed: () async => controller.reload()),
              ],
            ),
            Expanded(child: Container(child: func()))
          ],
        ),
      ),
    );
  }

  func() {
    controller = WebViewController()
      ..clearLocalStorage()
      ..canGoForward()
      ..canGoBack()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColor.primaryColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int localProgress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse('http://prtvc.ng/about.php'));
    return WebViewWidget(controller: controller);
  }
}
