import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/utils/constant.dart';

class SimulasiPinjaman extends StatefulWidget {
  const SimulasiPinjaman({Key? key}) : super(key: key);

  @override
  State<SimulasiPinjaman> createState() => _SimulasiPinjamanState();
}

class _SimulasiPinjamanState extends State<SimulasiPinjaman> {
  bool isError = false;

  late InAppWebViewController controllerWeb;

  double progress = 0.0;

  var nak;

  getProfile() async {
    String url = APIConstant.urlBase + APIConstant.serverApi + "profile";

    try {
      var response = await executeRequest(
        url,
      );

      var responseData = json.decode(response.body);

      nak = responseData['akun']['nak'];

      debugPrint('nak=' + nak);

      if (mounted) {
        setState(() {});
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();

    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: (!nak)
          ? Container()
          : InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri('http://35.197.136.216/simulasi?no_ang=' + nak),
                method: 'GET',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
              ),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptCanOpenWindowsAutomatically: true,
                  //supportMultipleWindows: true,
                ),
              ),
              onLoadStart: (controller, url) {
                setState(() {
                  isError = false;
                });
                debugPrint('currenturl: ${url?.toString()}');
              },
              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                return ServerTrustAuthResponse(
                    action: ServerTrustAuthResponseAction.PROCEED);
              },
              onWebViewCreated: (controller) {
                controllerWeb = controller;

                // var curUrl = controller.getUrl();
                // var curUrl1 = curUrl.

                // if (condition) {}
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
              onCreateWindow: (controller, createWindowAction) async {
                // create a headless WebView using the createWindowAction.windowId to get the correct URL
                HeadlessInAppWebView? headlessWebView;
                headlessWebView = HeadlessInAppWebView(
                  windowId: createWindowAction.windowId,
                  onLoadStart: (controller, url) async {
                    if (url != null) {
                      InAppBrowser.openWithSystemBrowser(
                          url: url); // to open with the system browser
                      // or use the https://pub.dev/packages/url_launcher plugin
                    }
                    // dispose it immediately
                    await headlessWebView?.dispose();
                    headlessWebView = null;
                  },
                );
                headlessWebView?.run();

                // return true to tell that we are handling the new window creation action
                return true;
              },
              onLoadError: (controller, url, code, message) {
                debugPrint('Load error: $message (Code: $code)');
                setState(() {
                  isError = true;
                });
              },
            ),
    );
  }
}
