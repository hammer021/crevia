import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/model/home_model.dart';
import 'package:kmob/ui/PromoScreen.dart';
import 'package:kmob/ui/NewsScreen.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePromo extends StatefulWidget {
  @override
  _HomePromoState createState() => _HomePromoState();
}

class _HomePromoState extends State<HomePromo> {
  List<Promo> _promoList = [];
  String? tokens;
  PageController _pageController = PageController();
  int _currentPage = 0;
  Timer _timer = Timer(Duration.zero, () {});

  String url = APIConstant.urlBase + APIConstant.serverApi + "News";

  @override
  void initState() {
    super.initState();
    fetchPromo();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_promoList.isNotEmpty) {
        setState(() {
          _currentPage = (_currentPage + 1) % _promoList.length;
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  Future<void> fetchPromo() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';

    final response = await executeRequest(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data as List;
      setState(() {
        _promoList = rest.map<Promo>((json) => Promo.fromJson(json)).toList();
      });
    } else if (response.statusCode == 401) {
      // Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }
  }

  Widget _sliderItem(Promo promo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewsScreen(param: promo)),
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
                fit: BoxFit.cover,
                placeholder: 'assets/img/loading.gif',
                image: promo.image,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promo.title,
                    style: TextStyle(
                        fontFamily: "WorkSansBold",
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    promo.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontFamily: "WorkSans",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "BERITA",
            style: TextStyle(fontFamily: "WorkSansBold", fontSize: 14.0),
          ),
          Text(
            "Update Informasi berita",
            style: TextStyle(fontFamily: "WorkSansBold", fontSize: 10.0),
          ),
          SizedBox(height: 10),
          _promoList.isEmpty
              ? Center(
                  child: SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: CircularProgressIndicator()))
              : Column(
                  children: [
                    SizedBox(
                      height: 300,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _promoList.length,
                        itemBuilder: (context, index) {
                          return _sliderItem(_promoList[index]);
                        },
                      ),
                    ),
                    // SizedBox(height: 15),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: MaterialButton(
                    //     minWidth: double.infinity,
                    //     color: ColorPalette.green,
                    //     onPressed: () {
                    //       // Tambahkan navigasi ke halaman berita lain
                    //     },
                    //     child: Text(
                    //       "Lihat berita lainnya",
                    //       style: TextStyle(
                    //           color: Colors.white,
                    //           fontFamily: "NeoSans",
                    //           fontSize: 12.0),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
        ],
      ),
    );
  }
}
