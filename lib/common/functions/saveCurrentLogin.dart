import 'package:flutter/material.dart';
import 'package:kmob/model/loginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

saveCurrentLogin(Map<String, dynamic> responseJson) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  var user;
  if (responseJson.isNotEmpty) {
    user = LoginModel.fromJson(responseJson).userName;
  } else {
    user = "";
  }
  var token =
      (responseJson.isNotEmpty) ? LoginModel.fromJson(responseJson).token : "";
  var email =
      (responseJson.isNotEmpty) ? LoginModel.fromJson(responseJson).email : "";
  var pk =
      (responseJson.isNotEmpty) ? LoginModel.fromJson(responseJson).userId : "";

  debugPrint("token sekarang: " + token);

  await preferences.setString('LastUser', (user.length > 0) ? user : "");
  await preferences.setString('LastToken', (token.length > 0) ? token : "");
  await preferences.setString('LastEmail', (email.length > 0) ? email : "");
  await preferences.setString('LastUserId', (pk.length > 0) ? pk : "");
}
