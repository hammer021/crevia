import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kmob/model/profile_model.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';

import '../../../utils/constant.dart';

class PinInputModal extends StatefulWidget {
  @override
  _PinInputModalState createState() => _PinInputModalState();
}

class _PinInputModalState extends State<PinInputModal> {
  List<String> _pin = ["", "", "", "", "", ""]; // PIN dengan 6 digit
  BuildContext? _context;

  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };
  String? tokens;
  Map<String, String> get headersKmobile => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };

  void _updatePin(String value) {
    for (int i = 0; i < _pin.length; i++) {
      if (_pin[i].isEmpty) {
        setState(() {
          _pin[i] = value;
        });
        break;
      }
    }
    if (_pin.every((digit) => digit.isNotEmpty)) {
      _confirmPin();
    }
  }

  void _deletePin() {
    for (int i = _pin.length - 1; i >= 0; i--) {
      if (_pin[i].isNotEmpty) {
        setState(() {
          _pin[i] = "";
        });
        break;
      }
    }
  }

  void _confirmPin() {
    String enteredPin = _pin.join("");
    validateData(_pin);
  }

  void showPinDialog(BuildContext context, String title, String title2,
      String message, String buttonLabel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                TextSpan(
                  text: title2,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          content: Text(message),
          actions: [
            TextButton(
              child: Text(buttonLabel),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future sendNewPin() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    // print(tokens);
    String url = "" +
        APIConstant.urlBase +
        "" +
        APIConstant.serverApi +
        "Profile/sendnewpin";
    Map<String, String> body = {
      // 'nohp': nohp,
      'token': tokens!,
    };
    Map<String, String> headers = {
      'Authorization': 'Bearer $tokens',
      'Content-Type': 'application/json',
    };
    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: headers);
    if (response.statusCode == 200) {
      final resbody = json.decode(response.body);

      // print(resbody['status']);

      if (resbody['status'] == 'success') {
        // print(resbody['status']);
        showPinDialog(context, "PIN BARU ", "Berhasil dikirim",
            "Silahkan cek Whatsapp untuk PIN BARU Anda", "OK");
      } else if (resbody['status'] == 'berlaku') {
        showPinDialog(context, "PIN BARU ", "Berhasil dikirim",
            "silahkan cek Whatsapp untuk PIN BARU Anda", "OK");
      } else if (resbody['status'] == 'failedupdt') {
        showPinDialog(context, "PIN BARU ", "Gagal diupdate",
            "silahkan cek nomor hp yang dimasukkan", "OK");
      } else {
        showPinDialog(context, "PIN BARU ", "Gagal dikirim",
            "silahkan cek nomor hp yang dimasukkan", "OK");
      }
    } else {
      showPinDialog(context, "PIN BARU ", "Gagal dikirim",
          "silahkan cek nomor hp yang dimasukkan", "OK");
    }
  }

  Future validateData(_pin) async {
    String enteredPin = _pin.join("");
    // print(_pin);
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    // print(url);
    String url = APIConstant.urlBase + APIConstant.serverApi + "profile/getpin";
    print(url);

    Map<String, String> body = {
      'pin': enteredPin,
    };
    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      // print(responseBody);
      if (responseBody['status'] == 'success')
        Navigator.pop(context, true);
      // _showErrorDialog(responseBody['message']);
      else if (responseBody['status'] == 'warning') {
        _showWarningDialog();
        // Timer(Duration(seconds: 2), () {
        //   Navigator.popUntil(_context, ModalRoute.withName('/HomeScreen'));
        // });
      } else
        _showErrorDialog();
    } else {
      // _showErrorDialog("ERROR");
    }
  }

  void _showErrorDialog() {
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
                "PIN Yang Anda Masukkan Salah",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            "PIN yang dimasukkan tidak sesuai. Silakan coba lagi.",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                setState(() {
                  _pin = ["", "", "", "", "", ""]; // Reset PIN
                });
              },
              child: Text("OK", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _showWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Column(
            children: [
              Icon(Icons.warning,
                  color: Colors.yellow, size: 50), // Ikon X merah
              SizedBox(height: 10),
              Text(
                "Belum Aktivasi PIN",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            "Silahkan aktivasi di Menu Profile",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .popUntil(ModalRoute.withName('/HomeScreen'));
                // Navigator.pop(context); // Tutup dialog
                // setState(() {
                //   _pin = ["", "", "", "", "", ""]; // Reset PIN
                // });
              },
              child: Text("OK", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: 30),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ),
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Masukkan PIN",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                // Text(
                //   "Gunakan PIN  Anda",
                //   style: TextStyle(fontSize: 16, color: Colors.grey),
                // ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pin.length,
                    (index) => Container(
                      width: 16,
                      height: 16,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: _pin[index].isEmpty
                            ? Colors.grey[300]
                            : Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
            Spacer(),
            GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 50),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                if (index < 9) {
                  return _buildNumberButton((index + 1).toString());
                } else if (index == 9) {
                  return _buildForgotButton();
                } else if (index == 10) {
                  return _buildNumberButton("0");
                } else {
                  return IconButton(
                    icon: Icon(Icons.backspace, size: 24),
                    onPressed: _deletePin,
                  );
                }
              },
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotButton() {
    return TextButton(
      onPressed: () {
        // Logika ketika tombol "Lupa?" ditekan, misalnya membuka dialog
        _showForgotPinDialog();
      },
      child: Text(
        "Lupa?",
        style: TextStyle(fontSize: 16, color: Colors.blue),
      ),
    );
  }

  // void _showForgotPinDialog_() {
  //   showDialogSingleButtons(
  //       context,
  //       "Silahkan ke fitur Profile",
  //       "Untuk mengubah PIN silahkan ke Fitur Profile -> Setting PIN",
  //       "OK",
  //       onOkPressed: () {
  //         Future.delayed(Duration(milliseconds: 10), () {
  //           Navigator.of(context).pushReplacementNamed('/HomeScreen');
  //         });
  //       }
  //   );
  // }
  void _showForgotPinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Apakah anda yakin akan mereset PIN ?"),
          content: Text("PIN BARU akan dikirim ke WhatsApp Anda. Lanjutkan?"),
          actions: [
            TextButton(
              child: Text("BATAL"),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Tutup dialog tanpa melakukan apa-apa
              },
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () async {
                Navigator.of(context).pop(); // Tutup dialog sebelum lanjut

                bool isSuccess =
                    await sendNewPin(); // Tunggu hasil pengiriman PIN

                if (isSuccess) {
                  // Jika berhasil, delay sebentar lalu pindah ke HomeScreen
                  Future.delayed(Duration(milliseconds: 10), () {
                    Navigator.of(context).pushReplacementNamed('/HomeScreen');
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => _updatePin(number),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Text(
          number,
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}

// Fungsi untuk memunculkan modal
Future<bool> showPinInputModal(BuildContext context) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PinInputModal()),
  ).then((result) {
    return result ?? false; // If result is null, return false
  });
}
