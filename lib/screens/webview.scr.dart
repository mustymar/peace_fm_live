// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:prtv_stream/include/colors.inc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PRTVWebView extends StatefulWidget {
  const PRTVWebView({super.key});

  @override
  State<PRTVWebView> createState() => _PRTVWebViewState();
}

class _PRTVWebViewState extends State<PRTVWebView> {
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
                    Icons.home_outlined,
                    color: AppColor.primaryColor,
                    size: 20,
                  ),
                  onPressed: () {
                    controller.loadRequest(Uri.parse("http://prtvc.ng"));
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: AppColor.primaryColor,
                    size: 20,
                  ),
                  onPressed: () async {
                    if (await controller.canGoBack()) {
                      controller.goBack();
                    }
                  },
                ),
                IconButton(
                    icon: const Icon(
                      Icons.refresh_outlined,
                      color: AppColor.primaryColor,
                      size: 20,
                    ),
                    onPressed: () async => controller.reload()),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: AppColor.primaryColor,
                    size: 20,
                  ),
                  onPressed: () async {
                    if (await controller.canGoForward()) {
                      controller.goForward();
                    }
                  },
                ),
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
      ..loadRequest(Uri.parse('http://prtvc.ng'));
    return WebViewWidget(controller: controller);
  }
}
