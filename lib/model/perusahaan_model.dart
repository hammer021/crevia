import 'dart:convert';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PerusahaanModel {
  final int id;
  final String perusahaan;
  final String abbrev;
  final int urut;

  const PerusahaanModel({
    required this.id,
    required this.perusahaan,
    required this.abbrev,
    required this.urut,
  });

  factory PerusahaanModel.fromJson(Map<String, dynamic> json) {
    return PerusahaanModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      perusahaan: json['perusahaan']?.toString() ?? '',
      abbrev: json['abbrev']?.toString() ?? '',
      urut: int.tryParse(json['urut']?.toString() ?? '0') ?? 0,
    );
  }
}

// Token dari SharedPreferences
String? tokens;

final String url = "${APIConstant.urlBase}${APIConstant.serverApi}perusahaan";

Map<String, String> get headers => {
      if (tokens != null && tokens!.isNotEmpty)
        'Authorization': 'Bearer $tokens',
      'Content-Type': 'application/json',
    };

class PerusahaanViewModel {
  static List<PerusahaanModel> perusahaanList = [];

  static Future<void> loadPerusahaan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      tokens = prefs.getString('LastToken') ?? '';

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        perusahaanList = data.map((e) => PerusahaanModel.fromJson(e)).toList();
      } else if (response.statusCode == 401) {
        // TODO: handle unauthorized (misalnya logout user atau refresh token)
      } else {
        throw Exception(
            "Failed to load perusahaan. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loadPerusahaan: $e");
    }
  }
}
