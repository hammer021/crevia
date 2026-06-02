import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/utils/constant.dart';
// import 'package:progress_hud/progress_hud.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GantiPin extends StatefulWidget {
  final ProfileModel? profile;
  const GantiPin({Key? key, this.profile}) : super(key: key);
  @override
  _GantiPinState createState() => _GantiPinState();
}

class _GantiPinState extends State<GantiPin> {
  double maxWidth = 0;
  double maxHeight = 0;
  String _oldPassword = "";
  String _newPassword = "";
  String _newPassword2 = "";
  String? hp;
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureNew2 = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String url = APIConstant.url + "registercust";

  BuildContext? _context;
  bool _loading = false;
  void dismissProgressHUD() {
    setState(() {
      _loading = !_loading;
    });
  }

  //main build method
  Widget build(BuildContext context) {
    _context = context;
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height >= 775.0
        ? MediaQuery.of(context).size.height
        : 775.0;
    return SafeArea(
      child: PlatformScaffold(
        appBar: appBarDetail(context, "Pin Transaksi") as PreferredSizeWidget,
        backgroundColor: Colors.grey[300],
        body: Stack(
          children: <Widget>[
            Container(
              width: maxWidth,
              height: maxHeight,
              margin: EdgeInsets.all(5.0),
              color: Colors.grey[200],
              child: new Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 40.0, 8.0),
                      child: _buildForm(),
                    ),
                    elevation: 2.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  )),
            ),
            if (_loading)
              // new ProgressHUD(
              //   backgroundColor: Colors.black12,
              //   color: Colors.white,
              //   containerColor: Colors.blue,
              //   borderRadius: 5.0,
              //   text: 'Mohon Tunggu...',
              // ),
              Container(
                color: Colors.black54, // background semi transparan
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Mohon Tunggu...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _buildForm() {
    void _validateInputs() {
      // Simpan nilai input dari form
      _formKey.currentState?.save();

      // Validasi form
      if (_formKey.currentState?.validate() ?? false) {
        // Cek apakah PIN yang diulang sama
        if (_newPassword2 != _newPassword) {
          showDialogSingleButton(
              context, "Peringatan", 'PIN baru tidak sama', "OK");
        } else {
          // Cek panjang PIN
          if (_newPassword.length == 6 && _newPassword2.length == 6) {
            validateData(_newPassword, _newPassword2, _oldPassword);
          } else {
            showDialogSingleButton(context, "Peringatan",
                'PIN harus terdiri dari 6 digit angka', "OK");
          }
        }
      } else {
        // Jika form tidak valid, tampilkan pesan kesalahan
        setState(() {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Peringatan'),
              content: Text('Harap isi semua kolom dengan benar'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        });
      }
    }

    return SingleChildScrollView(
        child: Column(children: <Widget>[
      new TextFormField(
        decoration: InputDecoration(
          labelText: "PIN Lama : ",
          icon: Icon(FontAwesomeIcons.lock, color: Colors.black),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureOld ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureOld = !_obscureOld;
              });
            },
          ),
        ),
        keyboardType: TextInputType.number,
        maxLength: 6,
        obscureText: _obscureOld,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (String? arg) {
          if (arg == null || arg.isEmpty)
            return 'Harus diisi';
          else if (arg.length != 6)
            return 'Pin terdiri dari 6 angka';
          else
            return null;
        },
        onSaved: (String? val) {
          _oldPassword = val ?? '';
        },
      ),
      new TextFormField(
        decoration: InputDecoration(
          labelText: "6 digit angka PIN : ",
          icon: Icon(FontAwesomeIcons.lock, color: Colors.black),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureNew ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureNew = !_obscureNew;
              });
            },
          ),
        ),
        keyboardType: TextInputType.number,
        maxLength: 6,
        obscureText: _obscureNew,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (String? arg) {
          if (arg == null || arg.isEmpty)
            return 'Harus diisi';
          else if (arg.length != 6)
            return 'Pin terdiri dari 6 angka';
          else
            return null;
        },
        onSaved: (String? val) {
          _newPassword = val ?? '';
        },
      ),
      new TextFormField(
        decoration: InputDecoration(
          labelText: "Ketik ulang PIN : ",
          icon: Icon(FontAwesomeIcons.lock, color: Colors.black),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureNew2 ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureNew2 = !_obscureNew2;
              });
            },
          ),
        ),
        keyboardType: TextInputType.number,
        maxLength: 6,
        obscureText: _obscureNew2,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (String? arg) {
          if (arg == null || arg.isEmpty)
            return 'Harus diisi';
          else if (arg.length != 6)
            return 'Pin terdiri dari 6 angka';
          else
            return null;
        },
        onSaved: (String? val) {
          _newPassword2 = val ?? '';
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      new Text(
        "PIN akan digunakan untuk menverifikasi pengajuan pinjaman dan lihat voucher. Harap ingat baik baik dan jaga kerahasiaan PIN anda.",
        style: new TextStyle(fontFamily: "WorkSans", fontSize: 10.0),
      ),
      SizedBox(
        height: 10.0,
      ),
      MaterialButton(
          color: ColorPalette.warnaCorporate,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
            child: Text(
              "LANJUTKAN PROSES AKTIVASI PIN",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontFamily: "WorkSansBold"),
            ),
          ),
          onPressed: _validateInputs)
    ]));
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

  Future validateData(
      String _newPassword, String _newPassword2, String _oldPassword) async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    print(tokens);
    String url =
        APIConstant.urlBase + APIConstant.serverApi + "profile/addnewpin";

    Map<String, String> body = {
      'pinold': _oldPassword,
      'pin1': _newPassword,
      'pin2': _newPassword2,
    };
    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      print(responseBody);
      if (responseBody['status'] == 'failed')
        _showErrorDialog(responseBody['message']);
      else {
        showDialogSingleButtons(context, "PIN berhasil diubah", "", "OK",
            onOkPressed: () {
          // Navigator.of(context).pop(); // Tutup dialog dulu
          Future.delayed(Duration(milliseconds: 10), () {
            Navigator.of(context).pushReplacementNamed('/HomeScreen');
          });
        });
      }
    } else {
      _showErrorDialog("ERROR");
    }
  }

  void _showErrorDialog(String params) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Column(
            children: [
              Icon(Icons.close, color: Colors.red, size: 50), // Ikon X merah
              SizedBox(height: 10),
              Text(
                "Gagal", // Title tetap
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            params, // Isi error dari params
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Future.delayed(Duration(milliseconds: 300), () {
                  setState(() {
                    _oldPassword = ""; // Reset PIN
                    _newPassword = "";
                    _newPassword2 = "";
                  });
                });
              },
              child: Text("OK", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(params) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Column(
            children: [
              Icon(Icons.check_circle_outline,
                  color: Colors.lightBlue, size: 50), // Ikon X merah
              SizedBox(height: 10),
              Text(
                "Berhasil",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            params,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Future.delayed(Duration(milliseconds: 300), () {
                  setState(() {
                    _oldPassword = ""; // Reset PIN
                    _newPassword = "";
                    _newPassword2 = "";
                  });
                });
              },
              child: Text("OK", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}
