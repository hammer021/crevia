import 'dart:convert';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SourceFundModel {
  final int id;
  final String simpanan;
  final String abbrev;
  final int urut;

  SourceFundModel({
    this.id = 0,
    this.simpanan = '',
    this.abbrev = '',
    this.urut = 0,
  });

  factory SourceFundModel.fromJson(Map<String, dynamic> json) {
    return SourceFundModel(
      id: json['id'] == null ? 0 : int.tryParse(json['id'].toString()) ?? 0,
      simpanan: json['perusahaan']?.toString() ?? '',
      abbrev: json['abbrev']?.toString() ?? '',
      urut:
          json['urut'] == null ? 0 : int.tryParse(json['urut'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "perusahaan": simpanan,
      "abbrev": abbrev,
      "urut": urut,
    };
  }
}

class PerusahaanViewModel {
  static Future<List<SourceFundModel>> loadBanks() async {
    List<SourceFundModel> banks = [];
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('LastToken') ?? '';

      final url = "${APIConstant.urlBase}${APIConstant.serverApi}perusahaan";
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> rest = json.decode(response.body);
        banks = rest
            .map<SourceFundModel>((json) => SourceFundModel.fromJson(json))
            .toList();
      } else if (response.statusCode == 401) {
        // handle unauthorized, contoh: lempar exception biar bisa ditangkap UI
        throw Exception("Unauthorized. Please login again.");
      } else {
        throw Exception(
            "Failed to load perusahaan. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loadBanks: $e");
    }
    return banks;
  }
}
