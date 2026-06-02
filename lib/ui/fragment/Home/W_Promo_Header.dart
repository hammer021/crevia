import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/ui/fragment/point/PointDetail.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
import 'package:kmob/model/home_model.dart';
import 'package:kmob/ui/PromoScreen.dart';
import 'package:kmob/model/produk_model.dart';

class HeaderSummary extends StatefulWidget {
  @override
  _HeaderSummaryState createState() => _HeaderSummaryState();
}

class _HeaderSummaryState extends State<HeaderSummary> {
  String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length <= 4)
      return phoneNumber; // Jika kurang dari 4 digit, biarkan
    String maskedPart = '*' * (phoneNumber.length - 4);
    String lastFourDigits = phoneNumber.substring(phoneNumber.length - 4);
    return '$maskedPart$lastFourDigits';
  }

  String urlN = APIConstant.urlBase + APIConstant.serverApi + "product/promo";

  String? tokens;
  String url = APIConstant.urlBase + APIConstant.serverApi + "profile";
  List<Produk> _promoList = [];
  SharedPreferences? sharedPreferences;
  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };
  ProfileModel? profile;
  String? nama = "", nak, tglMsk, nmPrsh, photo, nik, tlpHp;
  double plafon = 0;
  double plafonPakai = 0;
  double plafonSisa = 0;
  bool isData = false;
  double point = 0;
  double redeem = 0;
  double yourpoint = 0;

  Timer _timer = Timer(Duration.zero, () {});
  PageController _pageController = PageController();

  void persist(String value) {
    setState(() {
      tokens = value;
    });
    sharedPreferences?.setString('LastToken', value);
  }

  // Future<List<Produk>> fetchPromo() async {
  Future<void> fetchPromo() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    Map<String, dynamic> body = {
      "product_type": "promo",
    };
    // final response = await executeRequest(urlN);
    final response = await executeRequest(
      urlN,
      method: RequestMethod.POST, // Pastikan menggunakan POST
      headers: headers,
      body: body, // Encode body ke JSON
    );
    // http.get(Uri.parse(url), headers: headers);

    // debugPrint(url);

    if (response.statusCode == 200) {
      // var data = json.decode(response.body);
      // var rest = data as List;
      var data = json.decode(response.body) as List;
      setState(() {
        _promoList = data.map<Produk>((json) => Produk.fromJson(json)).toList();
      });
    } else if (response.statusCode == 401) {
      // Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }
    // return _promoList;
  }

  @override
  void initState() {
    super.initState();
    fetchPromo();

    // Auto slide setiap 5 detik
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = (_pageController.page?.toInt() ?? 0) + 1;

        if (nextPage >= _promoList.length) {
          // Jika sudah sampai halaman terakhir, langsung ke halaman pertama
          _pageController.jumpToPage(0);
        } else {
          // Jika masih dalam batas, lanjutkan ke halaman berikutnya dengan animasi
          _pageController.animateToPage(
            nextPage,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Jika data kosong, tampilkan loading
          _promoList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Container(
                  height: 200.0,
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: _promoList.length,
                    itemBuilder: (context, index) {
                      return _rowPromo(_promoList[index]);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _rowPromo(Produk produk) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PromoScreen(param: produk)),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: FadeInImage.assetNetwork(
                height: 172.0,
                width: double.infinity,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
                placeholder: 'assets/img/loading.gif',
                image: produk.attachment[0].imagePath,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
