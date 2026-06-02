import 'dart:convert';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BankModel {
  final String idbank;
  final String nama;
  final String tipe;

  BankModel({
    required this.idbank,
    required this.nama,
    required this.tipe,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      idbank: json['idbank']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      tipe: json['tipe']?.toString() ?? '',
    );
  }
}

class BankModelViewModel {
  static List<BankModel> banks = [];

  static Future<void> loadBanks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokens = prefs.getString('LastToken') ?? '';

      final String url = "${APIConstant.urlBase}${APIConstant.serverApi}bank";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $tokens',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> rest = json.decode(response.body) as List<dynamic>;
        banks = rest.map((e) => BankModel.fromJson(e)).toList();
      } else if (response.statusCode == 401) {
        // TODO: handle token expired (misalnya redirect ke login)
        // Navigator.of(context).pushReplacementNamed('/LoginScreen');
      } else {
        throw Exception("Failed to load banks: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loadBanks: $e");
    }
  }
}
