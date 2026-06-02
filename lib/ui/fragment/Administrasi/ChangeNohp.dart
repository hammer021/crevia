import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart'; // Untuk FilteringTextInputFormatter
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/ui/PasswordBaru.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import '../model/loginModel.dart';

class ChangeNohp extends StatefulWidget {
  // final LoginModel user; // Tambahkan parameter ini
  // ChangeNohp({this.user});
  // ChangeNohp({required this.user}); // Konstruktor untuk menerima user

  @override
  _ChangeNohpState createState() => _ChangeNohpState();
}

class _ChangeNohpState extends State<ChangeNohp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isOtpSent = false; // Tambahkan variabel ini

  final _phoneController = TextEditingController();
  String? _otp;
  String? _nohp;
  ProfileModel? profile;
  String notlp = "";
  bool isData = false;
  bool vEmail = false;
  bool vTelp = false;
  bool canEwallet = false;
  String url = APIConstant.urlBase + APIConstant.serverApi + "/profile";
  var url2 = APIConstant.urlBase + APIConstant.serverApi + "/profile/finance";

  fetchJson() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      profile = new ProfileModel.fromJson(json.decode(response.body));
      notlp = profile?.tlpHp ?? '';
      vEmail = profile?.emailConfirm ?? false;
      vTelp = profile?.phoneConfirm ?? false;
      if (vEmail) {
        canEwallet = true;
      }
      isData = true;
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
    var response2 = await http.get(
      Uri.parse(url2),
      headers: headers,
    );
    if (response2.statusCode == 200) {
    } else {
      print('Something went wrong. \nResponse Code : ${response2.statusCode}');
    }
    setState(() {});
  }

  @override
  void initState() {
    fetchJson();
    super.initState();
    // Inisialisasi controller dengan nilai nohp dari user
    // _phoneController.text = widget.user.nohp; // Set nilai awal
    // _no_ang = widget.user.no_ang;
  }

  @override
  void dispose() {
    _phoneController.dispose(); // Pastikan untuk membuang controller
    super.dispose();
  }

  // bool isOtpSent = false;
  String? phoneError; // Menyimpan pesan error jika ada

  void _validatePhoneAndSendOtp() {
    setState(() {
      String nohp = _phoneController.text.trim();
      // _nohp = nohp;
      String no_ang;
      if (nohp.isEmpty) {
        phoneError = 'Harus diisi';
        isOtpSent = false;
      } else if (nohp.length < 10 || nohp.length > 15) {
        phoneError = 'Nomor HP tidak valid';
        isOtpSent = false;
      } else {
        sendOTP(nohp);
        isOtpSent = false;
        // sendOTP('082112021682', no_ang);
      }
    });
  }

  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };
  String? tokens;
  Map<String, String> get headersKmobile => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };
  Future sendOTP(String nohp) async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    // print(tokens);
    String url = "" +
        APIConstant.urlBase +
        "" +
        APIConstant.serverApi +
        "Profile/insertotpchange";
    Map<String, String> body = {
      'nohp': nohp,
      'token': tokens ?? '',
    };
    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: headers);
    if (response.statusCode == 200) {
      final resbody = json.decode(response.body);
      isOtpSent = false;
      // print(resbody['status']);

      if (resbody['status'] == 'success') {
        // print(resbody['status']);
        showDialogSingleButton(context, "Kirim OTP Berhasil",
            "silahkan cek Whatsapp dan input OTP yang diberikan", "OK");
        setState(() {
          phoneError = null;
          isOtpSent = true;
        });
      } else if (resbody['status'] == 'berlaku') {
        showDialogSingleButton(context, "OTP Sudah dikirim",
            "silahkan cek Whatsapp dan input OTP yang diberikan", "OK");
        setState(() {
          phoneError = null;
          isOtpSent = true;
        });
      } else {
        showDialogSingleButton(context, "Kirim OTP Gagal",
            "silahkan cek nomor hp yang dimasukkan", "OK");
        setState(() {
          isOtpSent = false;
        });
      }
    } else {
      showDialogSingleButton(context, "Kirim OTP Gagal",
          "silahkan cek nomor hp yang dimasukkan", "OK");
      setState(() {
        isOtpSent = false;
      });
    }
  }

  void _validateInputs() {
    final otp = _otp ?? ""; // fallback ke string kosong kalau null
    final nohp = _phoneController.text.trim();

    // Validasi OTP
    if (otp.length != 6 || int.tryParse(otp) == null) {
      print("OTP tidak valid. Pastikan OTP terdiri dari 6 digit angka.");
      return;
    }

    // Validasi No HP
    if (nohp.length < 10 || nohp.length > 13 || int.tryParse(nohp) == null) {
      print(
          "Nomor HP tidak valid. Pastikan Nomor HP terdiri dari 10-13 digit angka.");
      return;
    }

    // Kalau semua valid
    _otp = otp;
    _nohp = nohp;
    cekOTP(_nohp!, _otp!);
  }

  Future cekOTP(String nohp, String otp) async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';

    String url = "" +
        APIConstant.urlBase +
        "" +
        APIConstant.serverApi +
        "Profile/getotp";
    Map<String, String> body = {
      'nohp': nohp,
      'otp': otp,
    };
    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: headers);
    // print(response.statusCode);
    if (response.statusCode == 200) {
      final resbody = json.decode(response.body);
      isOtpSent = false;
      print(resbody['status']);

      if (resbody['status'] == 'success') {
        // print(resbody['status']);
        showDialogSingleButtons(context, "Verifikasi Nomor Baru berhasil",
            "Anda akan dialihkan ke halaman Home", "OK", onOkPressed: () {
          Future.delayed(Duration(milliseconds: 10), () {
            Navigator.of(context).pushReplacementNamed('/HomeScreen');
          });
        });
      } else {
        showDialogSingleButton(
            context, "OTP Salah", "OTP yang anda masukkan salah", "OK");
      }
    } else {
      showDialogSingleButton(
          context, "OTP Salah", "OTP yang anda masukkan salah", "OK");
    }
  }

  BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      SingleChildScrollView(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height >= 775.0
            ? MediaQuery.of(context).size.height
            : 775.0,
        color: ColorPalette.warnaCorporate,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 75.0),
              child: Center(
                  child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.asset(
                  'assets/img/logo.jpg',
                  height: 200.0,
                  width: 200.0,
                  fit: BoxFit.fill,
                ),
              )),
            ),
            Container(
                padding: EdgeInsets.only(
                    top: 20.0, bottom: 0.0, left: 20.0, right: 25.0),
                child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Card(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 40.0, 8.0),
                            child: SingleChildScrollView(
                                child: Column(children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Nomor yang terdaftar saat ini: " + notlp,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: _phoneController,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  labelText: "Nomor Handphone Baru anda : ",
                                  icon: Icon(FontAwesomeIcons.phone,
                                      color: Colors.black),
                                  errorText:
                                      phoneError, // Tampilkan error jika ada
                                ),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly, // Hanya angka
                                ],
                                validator: (value) {
                                  // Validasi untuk memastikan input tidak kosong dan hanya angka
                                  if (value == null || value.isEmpty) {
                                    return 'Nomor handphone tidak boleh kosong';
                                  }
                                  if (value.length < 10) {
                                    return 'Nomor handphone tidak valid';
                                  }
                                  return null; // Jika valid
                                },
                                onChanged: (value) {
                                  // Trim input untuk menghapus spasi di awal dan akhir
                                  _phoneController.text = value.trim();
                                  _phoneController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: _phoneController.text.length),
                                  );
                                  _nohp = value.trim();
                                },
                                onSaved: (value) {
                                  _nohp = value; // Simpan nilai OTP
                                },
                              ),
                              MaterialButton(
                                  color: ColorPalette.warnaCorporate,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 42.0),
                                    child: Text(
                                      "KIRIM OTP",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontFamily: "WorkSansBold"),
                                    ),
                                  ),
                                  onPressed: _validatePhoneAndSendOtp),
                              Visibility(
                                visible: isOtpSent,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: "OTP : ",
                                        icon: Icon(FontAwesomeIcons.idCardAlt,
                                            color: Colors.black),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly, // Hanya angka
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Harus diisi';
                                        }
                                        if (value.length != 6) {
                                          return 'OTP harus 6 digit';
                                        }
                                        return null; // Jika valid
                                      },
                                      onChanged: (value) {
                                        String trimmedValue = value.trim();
                                        if (trimmedValue.length > 6) {
                                          trimmedValue = trimmedValue.substring(
                                              0, 6); // Ambil 6 karakter pertama
                                        }
                                        _otp = trimmedValue;
                                      },
                                      onSaved: (value) {
                                        _otp = value; // Simpan nilai OTP
                                      },
                                    ),
                                    MaterialButton(
                                        color: ColorPalette.warnaCorporate,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 42.0),
                                          child: Text(
                                            "SUBMIT",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0,
                                                fontFamily: "WorkSansBold"),
                                          ),
                                        ),
                                        onPressed: _validateInputs)
                                  ],
                                ),
                              )
                            ]))))))
          ],
        ),
      ))
    ]));
  }
}
