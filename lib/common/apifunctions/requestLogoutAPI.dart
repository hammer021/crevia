import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kmob/common/functions/saveLogout.dart';
// import 'package:kmob/model/loginModel.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

// Future<LoginModel> requestLogoutAPI(BuildContext context) async {
//   //kmob pakai oauth2
//    OneSignal.logout();
//   saveLogout();
//   Navigator.of(context).pushReplacementNamed('/LoginScreen');
//   return null;
// }

Future<void> requestLogoutAPI(BuildContext context) async {
  OneSignal.logout();
  saveLogout();
  Navigator.of(context).pushReplacementNamed('/LoginScreen');
}
