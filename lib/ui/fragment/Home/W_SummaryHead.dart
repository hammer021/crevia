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

class HomeSummaryHead extends StatefulWidget {
  @override
  _HomeSummaryHeadState createState() => _HomeSummaryHeadState();
}

class _HomeSummaryHeadState extends State<HomeSummaryHead> {
  String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length <= 4)
      return phoneNumber; // Jika kurang dari 4 digit, biarkan
    String maskedPart = '*' * (phoneNumber.length - 4);
    String lastFourDigits = phoneNumber.substring(phoneNumber.length - 4);
    return '$maskedPart$lastFourDigits';
  }

  String? tokens;
  String url = APIConstant.urlBase + APIConstant.serverApi + "profile";

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
  double total_swajib = 0;

  void persist(String value) {
    setState(() {
      tokens = value;
    });
    sharedPreferences?.setString('LastToken', value);
  }

  fetchJson() async {
    //get token
    SharedPreferences.getInstance().then((SharedPreferences sp) async {
      sharedPreferences = sp;
      tokens = sharedPreferences?.getString('LastToken');
      // will be null if never previously saved
      if (tokens == null) {
        tokens = "";
        persist(tokens ?? ""); // set an initial value
      } else {
        if (tokens != "") {
          var response = await executeRequest(
            url,
            // headers: headers,
          );
          // debugPrint("url: " + url + " header: " + headers.toString());

          if (response.statusCode == 200) {
            profile = new ProfileModel.fromJson(json.decode(response.body));
            if (mounted) {
              setState(() {
                nama = profile?.nmAng;
                tlpHp = profile?.tlpHp;
                nak = profile?.nak;
                nik = profile?.noPeg;
                tglMsk = formatDate(profile?.tglMsk.toString() ?? '');
                nmPrsh = profile?.nmPrsh;
                photo = profile?.pathFoto;
                plafon = profile?.plafon ?? 0;
                plafonPakai = profile?.plafonPakai ?? 0;
                plafonSisa = profile?.plafonSisa ?? 0;
                yourpoint = profile?.yourpoint ?? 0;
                total_swajib = profile?.total_simpanan_wajib ?? 0;
                isData = true;
              });
            }

            // setState(() {});
          } else if (response.statusCode == 401) {
            if (mounted) {
              Navigator.of(context).pushReplacementNamed('/LoginScreen');
            }
          } else {
            print(
                'Something went wrong. \nResponse Code : ${response.statusCode}');
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _checkTokenExist();
    Timer(Duration(seconds: 1), () {
      fetchJson();
    });
  }
  // if (tokens == null || tokens == "") {

  // } else {}

  _checkTokenExist() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    if (tokens == null) {
      Timer(Duration(seconds: 1), () {
        fetchJson();
      });
    } else {
      fetchJson();
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isData
        ? Center(
            child: SizedBox(
                width: 40.0,
                height: 40.0,
                child: const CircularProgressIndicator()),
          )
        : Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.coins,
                            color: ColorPalette.menuTix,
                            size: 28,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Simpanan Wajib",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                formatCurrency(total_swajib),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) =>
                      //             PointDetail(profile: profile!),
                      //       ),
                      //     );
                      //   },
                      //   child: Container(
                      //     padding:
                      //         EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      //     decoration: BoxDecoration(
                      //       color: ColorPalette.warnaCorporate,
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     child: Row(
                      //       children: [
                      //         Text(
                      //           "More",
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //         SizedBox(width: 4),
                      //         Icon(
                      //           Icons.arrow_forward_ios,
                      //           color: Colors.white,
                      //           size: 12,
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}
