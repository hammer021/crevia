import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformWillPopScope extends StatelessWidget {
  final Widget child;
  final WillPopCallback onWillPop;
  final EdgeInsetsGeometry paddingExternal;

  const PlatformWillPopScope({
    Key? key,
    required this.child,
    this.onWillPop = _defaultOnWillPop,
    this.paddingExternal = EdgeInsets.zero,
  }) : super(key: key);

  static Future<bool> _defaultOnWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding(
            padding: paddingExternal,
            child: child,
          )
        : WillPopScope(
            child: child,
            onWillPop: onWillPop,
          );
  }
}
