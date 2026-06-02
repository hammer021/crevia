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

class HomeSummary extends StatefulWidget {
  @override
  _HomeSummaryState createState() => _HomeSummaryState();
}

class _HomeSummaryState extends State<HomeSummary> {
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
  String? nama = "", nak, tglMsk, nmPrsh, photo, nik, tlpHp, email;
  double plafon = 0;
  double plafonPakai = 0;
  double plafonSisa = 0;
  bool isData = false;
  double point = 0;
  double redeem = 0;
  double yourpoint = 0;
  double saldo_swajib = 0;

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
        persist(tokens ?? ''); // set an initial value
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
                email = profile?.email;
                nama = profile?.nmAng;
                tlpHp = profile?.tlpHp;
                nak = profile?.nak;
                nik = profile?.noPeg;
                tglMsk = formatDate(profile?.tglMsk.toString() ?? "");
                nmPrsh = profile?.nmPrsh;
                photo = profile?.pathFoto;
                plafon = profile?.plafon ?? 0;
                plafonPakai = profile?.plafonPakai ?? 0;
                plafonSisa = profile?.plafonSisa ?? 0;
                yourpoint = profile?.yourpoint ?? 0;
                saldo_swajib = profile?.total_simpanan_wajib ?? 0;
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

  Widget _buildProfileTable() {
    final rows = [
      ["No Anggota (NAK)", nak ?? ""],
      ["No NIK", nik ?? ""],
      ["No HP", tlpHp ?? ""],
      ["Email", email ?? ""],
      ["Perusahaan", nmPrsh ?? ""],
      ["Tanggal Masuk", tglMsk ?? ""],
      ["Plafon", formatCurrency(plafon)],
      ["Plafon terpakai", formatCurrency(plafonPakai)],
      ["Sisa Plafon", formatCurrency(plafonSisa)],
    ];

    return Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(), // kolom kiri selebar teks
        1: FlexColumnWidth(), // kolom kanan fleksibel
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: rows.map((row) {
        return TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              "${row[0]} ",
              style: const TextStyle(
                fontFamily: 'WorkSans',
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              ": ${row[1]}",
              style: const TextStyle(
                fontFamily: 'WorkSans',
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ),
        ]);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.all(10.0),
        padding: const EdgeInsets.only(bottom: 20.0),
        // height: 270.0,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xff3164bd), const Color(0xff295cb5)],
            ),
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: !isData
            ? const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xff3164bd),
                            const Color(0xff295cb5)
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Flexible(
                            fit: FlexFit.tight,
                            child: Text("Profile ",
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontFamily: "WorkSansBold"))),
                        Row(
                          children: <Widget>[
                            new Text(
                              "Saldo Simpanan Wajib: ",
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontFamily: "WorkSans"),
                            ),
                            new Text(
                              formatCurrency(saldo_swajib),
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontFamily: "WorkSansBold"),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PointDetail(
                                              profile: profile!,
                                            )),
                                    ModalRoute.withName("/HomeScreen"));
                              },
                              child: Column(
                                children: <Widget>[
                                  // new Container(
                                  //   child: new Icon(
                                  //     FontAwesomeIcons.ellipsisV,
                                  //     color: Colors.white,
                                  //     size: 12.0,
                                  //   ),
                                  // ),
                                  new Padding(
                                    padding: EdgeInsets.only(top: 7.0),
                                  ),
                                  // Center(
                                  //   child: new Text(
                                  //     "More",
                                  //     style: new TextStyle(
                                  //         fontSize: 12.0,
                                  //         color: Colors.white,
                                  //         fontFamily: "WorkSansBold"),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15.0),
                    child: SizedBox(
                      height: 190.0,
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          const SizedBox(width: 5.0),
                          Expanded(child: _buildProfileTable()),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
  }
}
