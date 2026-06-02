import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/common/functions/saveCurrentLogin.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'dart:convert';
import 'package:kmob/model/loginModel.dart';
import 'package:kmob/ui/VerifScreen.dart';
import 'package:kmob/utils/constant.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<bool> requestLoginAPI(
    BuildContext context, String username, String password) async {
  String url = APIConstant.urlBase +
      APIConstant.serverApi +
      "Oauth2/PasswordCredentials";

  if (RegExp(r'^[0-9]+$').hasMatch(username)) {
    String urlgets =
        APIConstant.urlBase + APIConstant.serverApi + "Pub/logvianum";
    Map<String, String> fill = {
      'nohp': username,
      'apicode': "012-&^%(*60090thisisapiforapi01283u(*^*092"
    };
    final ress = await executeRequest(
      urlgets,
      body: fill, method: RequestMethod.POST,
      // headers: {},
    );
    if (ress.statusCode == 200) {
      final responseJson = json.decode(ress.body);
      // print(responseJson["username"]);
      if (responseJson["status"] != 'success') {
        showDialogSingleButtonss(
            context,
            "Belum verifikasi Nomor HP",
            "Anda belum melakukan verifikasi nomor hp, anda harus Login dengan Email terlebih dahulu",
            "OK", onOkPressed: () {
          // return false;
          Navigator.of(context).pop();
        });
        return false;
      }
      username = responseJson["username"];
    }
  }

  Map<String, String> body = {
    'grant_type': "password",
    'username': username,
    'password': password,
    'client_id': "k3pg-flutter",
    'client_secret': "53f6dcbba0f8a4aa824effc750d30a63"
  };

  final response = await executeRequest(
    url,
    body: body, method: RequestMethod.POST,
    // headers: {},
  );

  if (response.statusCode == 200) {
    final responseJson = json.decode(response.body);
    if (responseJson is Map<String, dynamic> &&
        responseJson.containsKey("stats") &&
        responseJson["stats"] == 'verifhpinvalid') {
      showDialogSingleButtonss(
          context,
          "Belum verifikasi Nomor HP",
          "Anda belum melakukan verifikasi nomor hp, anda harus Login dengan Email terlebih dahulu",
          "OK", onOkPressed: () {
        // return false;
        Navigator.of(context).pop();
      });
    } else {
      var user = new LoginModel.fromJson(responseJson);

      await saveCurrentLogin(responseJson);

      if (user.is_verif_nohp == 0) {
        showDialogSingleButtonss(
            context,
            "Belum verifikasi Nomor HP",
            "Belum verifikasi Nomor HP, anda belum melakukan verifikasi nomor hp, anda akan dialihkan ke halaman verifikasi nomor hp",
            "OK", onOkPressed: () {
          // Navigator.of(context).pop(); // Tutup dialog dulu
          Future.delayed(Duration(milliseconds: 10), () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VerifScreen(user: user)));
          });
        });
        return true;
      } else {
        if (user.kasir) {
          Navigator.of(context).pushReplacementNamed('/KasirScreen');
          return true;
        } else {
          OneSignal.login(user.no_ang.toString());
          Navigator.of(context).pushReplacementNamed('/HomeScreen');
          return true;
        }
      }
    }
  } else if (response.statusCode == 502) {
    showDialogSingleButton(
        context, "Check your connection", "please check your connection", "OK");
    return false;
  } else {
    showDialogSingleButton(
        context,
        "Unable to Login",
        "You may have supplied an invalid 'Username' / 'Password' combination. Please try again or contact your support representative.",
        "OK");
    OneSignal.logout();
    return false;
  }
  return false;
}
