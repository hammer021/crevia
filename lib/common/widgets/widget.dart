import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kmob/utils/constant.dart';

class ReusableWidgets {
  static getAppBar(BuildContext context, String title) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            // "K3PG - $title",
            "$title",
            style: TextStyle(
                color: ColorPalette.warnaCorporate,
                fontSize: 16.0,
                fontFamily: "WorkSansSemiBold"),
          ),
          new Image.asset(
            'assets/img/logok3pg.png',
            fit: BoxFit.contain,
            height: 16,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: ColorPalette.warnaCorporate),
      elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
    );
  }
}

Widget tombol({
  required Widget child,
  required VoidCallback onPressed,
  Color? backgroundColor,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: backgroundColor ?? Colors.blue,
      foregroundColor: Colors.white,
    ),
    onPressed: onPressed,
    child: child,
  );
}

/// Tombol hijau
Widget tombolIjo({
  required Widget child,
  required VoidCallback onPressed,
  Color? backgroundColor,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: backgroundColor ?? const Color.fromARGB(255, 2, 167, 98),
    ),
    onPressed: onPressed,
    child: child,
  );
}

/// View loading overlay
Widget loadingView() {
  return Stack(
    children: [
      Container(color: Colors.transparent),
      Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(20.0),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20.0),
              Text(
                'Loading...',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

/// Info dialog
void showInfoDialog(
  BuildContext context, {
  String? title,
  Widget? content,
  List<Widget>? actions,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? 'Judul'),
        content: content ?? const Text('Info'),
        actions: actions ??
            <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
      );
    },
  );
}

/// Confirm dialog
Future<bool> confirmDialog(
  BuildContext context, {
  String? title,
  Widget? content,
  List<Widget>? actions,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? 'Judul'),
        content: content ?? const Text('Info'),
        actions: actions ??
            <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
      );
    },
  );

  return result ?? false; // supaya ga null
}
