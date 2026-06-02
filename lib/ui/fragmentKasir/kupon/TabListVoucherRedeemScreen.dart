import 'dart:convert';

import 'package:badges/badges.dart' as badge;
// import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/model/voucher_model.dart';
import 'package:kmob/model/kdpromo_model.dart';
import 'package:kmob/utils/constant.dart';
// import 'package:progress_hud/progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TabListVoucherRedeemScreen extends StatefulWidget {
  @override
  _TabListVoucherRedeemScreenState createState() =>
      _TabListVoucherRedeemScreenState();
}

class _TabListVoucherRedeemScreenState
    extends State<TabListVoucherRedeemScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  var textController = new TextEditingController();
  var textController2 = new TextEditingController();

  bool _loading = false;
  bool _exists = false;
  VoucherModel? voucherModel;
  String barcode = "";
  String? selectedPromo;
  double? nominal;
  //main build method
  @override
  void initState() {
    super.initState();
    _exists = false;
    textController2.addListener(() {
      setState(() {}); // Trigger rebuild saat input berubah
    });
  }

  @override
  void dispose() {
    textController.dispose();
    textController2.dispose();
    super.dispose();
  }

  BuildContext? _context;
  Widget build(BuildContext context) {
    _context = context;
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5.0),
          color: Colors.grey[200],
          child: ListView(
            children: <Widget>[
              new Form(
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
              // if (_exists)
              if (_exists && voucherModel!.tipe != null)
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 8.0),
                    child: Container(
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(40.0)),
                          border: Border.all(
                              color: ColorPalette.warnaCorporate, width: 10.0)),
                      padding: EdgeInsets.all(10.0),
                      child: new Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          Center(
                            child: Text(
                              voucherModel!.tipe,
                              style: TextStyle(
                                  fontSize: 25.0,
                                  fontFamily: "NeoSans",
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Center(
                            child: Text(
                              "Nominal :",
                              style: TextStyle(
                                  fontSize: 20.0, fontFamily: "NeoSans"),
                            ),
                          ),
                          Center(
                            child: Text(
                              formatCurrency(voucherModel!.nominal),
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: "NeoSans",
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Center(
                            child: Text(
                              "Nominal Terpakai :" +
                                  formatCurrency(voucherModel!.nominalTerpakai),
                              style: TextStyle(
                                  fontSize: 15.0, fontFamily: "NeoSans"),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: voucherModel!.splittable.toString() == "0"
                                  ? Colors.blue[600]
                                  : Colors.green[600],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                                voucherModel!.splittable.toString() == "0"
                                    ? "Hanya berlaku untuk sekali pakai"
                                    : "Dapat digunakan beberapa kali.",
                                style: TextStyle(
                                    fontFamily: "WorkSansMedium",
                                    fontSize: 15.0,
                                    color: Colors.white)),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Center(
                            child: Text(
                              "Valid Hingga : ",
                              style: TextStyle(
                                  fontSize: 15.0, fontFamily: "NeoSans"),
                            ),
                          ),
                          Center(
                            child: Text(
                              formatDate(voucherModel!.validTo),
                              style: TextStyle(
                                  fontSize: 15.0, fontFamily: "NeoSans"),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: voucherModel!.idStatus.toString() == "2"
                                  ? Colors.blue[600]
                                  : (voucherModel!.idStatus.toString() == "3" ||
                                          voucherModel!.idStatus.toString() ==
                                              "4")
                                      ? Colors.yellow[600]
                                      : voucherModel!.idStatus.toString() == "5"
                                          ? Colors.green[600]
                                          : Colors.red[600],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(voucherModel!.voucherstatus.toString(),
                                style: TextStyle(
                                    fontFamily: "WorkSansMedium",
                                    fontSize: 15.0,
                                    color: Colors.white)),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          [3, 4].contains(voucherModel!.idStatus)
                              ? _buildForm2()
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.red[600],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text("Voucher tidak dapat digunakan",
                                      style: TextStyle(
                                          fontFamily: "WorkSansMedium",
                                          fontSize: 15.0,
                                          color: Colors.white)),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (_loading)
          // new ProgressHUD(
          //   backgroundColor: Colors.black12,
          //   color: Colors.white,
          //   containerColor: Colors.blue,
          //   borderRadius: 5.0,
          //   text: 'Loading data...',
          // ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              width: 120.0,
              height: 120.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Loading...",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          )
      ],
    );
  }

  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };

  fetchData() async {
    String url = "" +
        APIConstant.urlBase +
        "" +
        APIConstant.serverApi +
        "/Voucher/detail";
    Map<String, String> body = {'kode_voucher': barcode};

    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    var response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      voucherModel = new VoucherModel.fromJson(json.decode(response.body));
      setState(() {
        _exists = true;
      });
    } else {
      setState(() {
        _exists = false;
      });
      showDialogSingleButton(
          _context!, "Informasi", "Kupon tidak valid.", "OK");
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  List<KdPromoModel> kdPromoModel = [];
  fetchDataPromo() async {
    String url = "" +
        APIConstant.urlBase +
        "" +
        APIConstant.serverApi +
        "/Voucher/kdpromo";

    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    var response = await http.post(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      kdPromoModel = data.map((e) => KdPromoModel.fromJson(e)).toList();
      setState(() {
        _exists = true;
      });
    } else {
      setState(() {
        _exists = false;
      });
      showDialogSingleButton(
          _context!, "Informasi", "Kode Promo tidak valid.", "OK");
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  klaimProses() async {
    String url = "" +
        APIConstant.urlBase +
        "" +
        APIConstant.serverApi +
        "Voucher/redeem";
    Map<String, String> body = {
      'kode_voucher': barcode,
      'nominal': nominal.toString(),
      'kd_promo': selectedPromo ?? ''
    };

    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    var response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));
    setState(() {
      _loading = !_loading;
    });
    if (response.statusCode == 200) {
      showDialogSingleButtonWithAction(_context!, "Berhasil",
          response.body.toString(), "OK", '/KasirScreen');
    } else if (response.statusCode == 205) {
      showDialogSingleButton(
          _context!, "Error", response.body.toString(), "OK");
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }

    setState(() {
      _exists = true;
    });
  }

  Widget _buildForm() {
    void _validateInputs() {
      if (_formKey.currentState?.validate() ?? false) {
//    If all data are correct then save data to out variables
        _formKey.currentState?.save();
        fetchData();
        fetchDataPromo();
      }
    }

    // Future scan() async {
    //   try {
    //     var result = await BarcodeScanner.scan();

    //     String barcode = result.rawContent;
    //     setState(() {
    //       this.barcode = barcode;
    //       textController.text = barcode;
    //     });
    //   } on PlatformException catch (e) {
    //     if (e.code == BarcodeScanner.cameraAccessDenied) {
    //       setState(() {
    //         this.barcode = 'The user did not grant the camera permission!';
    //       });
    //     } else {
    //       setState(() => this.barcode = 'Unknown error: $e');
    //     }
    //   } on FormatException {
    //     setState(() => this.barcode =
    //         'null (User returned using the "back"-button before scanning anything. Result)');
    //   } catch (e) {
    //     setState(() => this.barcode = 'Unknown error: $e');
    //   }
    // }
    Future scan() async {
      try {
        final result = await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (_) => const MobileScannerPage(),
          ),
        );

        if (result != null && result.isNotEmpty) {
          setState(() {
            barcode = result;
            textController.text = result;
          });
        }
      } catch (e) {
        setState(() {
          barcode = 'Unknown error: $e';
        });
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new TextFormField(
          controller: textController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "Kode Voucher : ",
            icon: Icon(FontAwesomeIcons.userTag, color: Colors.blue),
          ),
          keyboardType: TextInputType.text,
          validator: (String? arg) {
            if (arg == null || arg.length < 1)
              return 'Harus diisi';
            else if (arg.length > 20)
              return 'Kode Voucher terlalu panjang';
            else
              return null;
          },
          onSaved: (String? val) {
            barcode = val ?? "";
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                // padding: MaterialStateProperty.all(EdgeInsets.all(10)),
              ),
              // color: Colors.blue,
              // textColor: Colors.white,
              // splashColor: Colors.blueGrey,
              onPressed: scan,
              child: const Text('START CAMERA SCAN')),
        ),
        new SizedBox(
          height: 10.0,
        ),
        ElevatedButton(
          onPressed: _validateInputs,
          // color: ColorPalette.warnaCorporate,
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(ColorPalette.warnaCorporate)),
          child: new Text(
            'Cek',
            style: new TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget _buildForm2() {
    void _validateInputs2() {
      if (_formKey2.currentState?.validate() ?? false) {
//    If all data are correct then save data to out variables
        _formKey2.currentState?.save();
        setState(() {
          _loading = !_loading;
        });
        klaimProses();
      }
    }

    return Form(
        key: _formKey2,
        autovalidateMode: AutovalidateMode.always,
        child: Card(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    voucherModel!.splittable == 1
                        ? Column(
                            children: [
                              TextFormField(
                                controller: textController2,
                                decoration: const InputDecoration(
                                  labelText: "Nominal yang digunakan : ",
                                  icon: Icon(FontAwesomeIcons.moneyBill,
                                      color: Colors.blue),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (String? arg) {
                                  if (arg == null || arg.length < 1)
                                    return 'Harus diisi';
                                  else if (arg.length > 20)
                                    return 'Tidak Valid';
                                  else if (int.parse(arg) >
                                      (voucherModel!.nominal -
                                          voucherModel!.nominalTerpakai))
                                    return 'Nilai terlalu besar dari sisa voucher';
                                  else
                                    return null;
                                },
                                onSaved: (String? val) {
                                  nominal = double.parse(val ?? "0");
                                },
                              ),
                              SizedBox(height: 10.0),
                              DropdownButtonFormField<String>(
                                value: (selectedPromo != null &&
                                        selectedPromo!.isNotEmpty)
                                    ? selectedPromo
                                    : null,
                                decoration: InputDecoration(
                                  labelText: 'Pilih Kode Promo',
                                  icon: Icon(FontAwesomeIcons.tag,
                                      color: Colors.blue),
                                ),
                                dropdownColor: Colors.white,
                                isExpanded: true,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                                items: kdPromoModel.map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item.kodePromo.trim(),
                                    child: Text(
                                      item.keterangan,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  // Hindari setState langsung saat render, gunakan post frame
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    setState(() {
                                      selectedPromo = value ?? '';
                                      print("Selected promo: '$selectedPromo'");
                                    });
                                  });
                                },
                                validator: (String? arg) {
                                  if (arg != null && arg != '0') {
                                    // Cari data promo yang dipilih
                                    final selected = kdPromoModel.firstWhere(
                                      // (e) => e.kodePromo.trim() == arg.trim(),
                                      // orElse: () => null,
                                      (e) => e.kodePromo.trim() == arg.trim(),
                                    );

                                    if (selected != null) {
                                      double sisa = selected.sisaNominal ?? 0;

                                      if (sisa <= 0) {
                                        return 'Kode Promo sudah habis';
                                      }
                                    }
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(height: 10.0),
                              if (selectedPromo != null &&
                                  textController2.text.isNotEmpty) ...[
                                Text("Nominal Promo : ",
                                    style: TextStyle(fontSize: 15)),
                                Text(
                                  () {
                                    try {
                                      final selected1 = kdPromoModel.firstWhere(
                                        (e) =>
                                            e.kodePromo.trim() ==
                                            selectedPromo!.trim(),
                                      );

                                      double inputNominal = double.tryParse(
                                              textController2.text) ??
                                          0.0;

                                      if (inputNominal >=
                                          selected1.minNominal) {
                                        double persen =
                                            selected1.prosentase ?? 0.0;
                                        double nominalUsed =
                                            (persen / 100) * inputNominal;
                                        return formatCurrency(nominalUsed);
                                      } else {
                                        return formatCurrency(0);
                                      }
                                    } catch (e) {
                                      return formatCurrency(0);
                                    }
                                  }(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ],
                          )
                        : Column(
                            children: <Widget>[
                              Text(
                                "Nominal yang akan digunakan : ",
                                style: TextStyle(
                                    fontSize: 15.0, fontFamily: "NeoSans"),
                              ),
                              Text(
                                formatCurrency(voucherModel!.nominal),
                                style: TextStyle(
                                    fontSize: 15.0, fontFamily: "NeoSans"),
                              ),
                            ],
                          ),
                    new SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                      onPressed: _validateInputs2,
                      // color: ColorPalette.warnaCorporate,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              ColorPalette.warnaCorporate)),
                      child: new Text(
                        'Klaim',
                        style: new TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ))));
  }
}

class MobileScannerPage extends StatelessWidget {
  const MobileScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          facing: CameraFacing.back,
        ),
        onDetect: (capture) {
          final String? code = capture.barcodes.first.rawValue;
          if (code != null) {
            Navigator.pop(context, code);
          }
        },
      ),
    );
  }
}
