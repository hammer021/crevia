import 'package:flutter/material.dart';
import 'package:kmob/utils/constant.dart';
import 'package:kmob/model/home_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kmob/common/functions/future.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:kmob/ui/fragment/Voucher/VoucherFragmentScreen.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/ui/fragment/Voucher/pin_input_modal.dart';
import 'package:kmob/ui/fragment/Voucher/DetailVoucherScreen.dart';
import 'package:kmob/common/functions/showDialogSingleButton.dart';
import 'package:kmob/model/voucher_model.dart';
import 'package:http/http.dart' as http;

const String kTestString = 'Hello world!';

class NotifikasiFragment extends StatefulWidget {
  @override
  _NotifikasiFragmentState createState() => _NotifikasiFragmentState();
}

class _NotifikasiFragmentState extends State<NotifikasiFragment> {
  List<Notif> _notifList = [];
  String? tokens;
  VoucherModel? voucherModel;
  String kode_voucher = "";

  String formatTanggal(String tanggal) {
    try {
      DateTime parsedDate = DateTime.parse(tanggal);
      return DateFormat('dd-MM-yyyy HH:mm').format(parsedDate);
    } catch (e) {
      return tanggal; // Jika error, tampilkan original
    }
  }

  String url = APIConstant.urlBase + APIConstant.serverApi + "notifikasi";
  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };
  Future<List<Notif>> fetchNotif() async {
    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';

    final response = await executeRequest(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data is List) {
        return data.map<Notif>((json) => Notif.fromJson(json)).toList();
      } else {
        return []; // Pastikan selalu mengembalikan List<Notif>
      }
    } else {
      return []; // Jika error, tetap kembalikan List kosong
    }
  }

  Future<void> markAsRead(String idNotif) async {
    String readUrl =
        APIConstant.urlBase + APIConstant.serverApi + "notifikasi/read";
    Map<String, String> headers = {
      'Authorization': 'Bearer $tokens',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> body = {
      "id_notif": idNotif,
    };

    try {
      final response = await executeRequest(
        readUrl,
        method: RequestMethod.POST, // Pastikan menggunakan POST
        headers: headers,
        body: body, // Encode body ke JSON
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notifikasi berhasil dibaca')),
        );

        // Update daftar notifikasi setelah membaca
        setState(() {
          _notifList
              .removeWhere((notif) => notif.idNotif.toString() == idNotif);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membaca notifikasi')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  fetchDataDetailVoucher() async {
    String url = "" +
        APIConstant.urlBase +
        "" +
        APIConstant.serverApi +
        "/notifikasi2/detail_voucher";
    Map<String, String> body = {'kode_voucher': kode_voucher};

    final prefs = await SharedPreferences.getInstance();
    tokens = prefs.getString('LastToken') ?? '';
    var response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      voucherModel = new VoucherModel.fromJson(json.decode(response.body));
      // print('🔔 Data res: $voucherModel');
      // print('🔔 Data kode_voucher: $kode_voucher');
      showPinInputModal(context).then((isPinCorrect) {
        if (isPinCorrect == true) {
          // PIN benar, lanjutkan aksi
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailVoucherScreen(param: voucherModel!),
            ),
          );
        }
      });

      //  return rowDataVoucher1(
      //                 voucherModel, context, (1).toString()
      //             );
      // setState(() {
      //   _exists = true;
      // });
    } else {
      // setState(() {
      //   _exists = false;
      // });
      showDialogSingleButton(context, "Informasi", "Kupon tidak valid.", "OK");
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  }

  Widget _rowNotif(Notif notif) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorPalette.menuCar)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ✅ Hanya teks yang bisa diklik untuk navigasi
          Expanded(
            child: InkWell(
              onTap: () {
                if (notif.type == "Voucher" || notif.type == "Info Voucher") {
                  kode_voucher = notif.reff;
                  fetchDataDetailVoucher();
                  markAsRead(notif.idNotif);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => Scaffold(
                  //       appBar: appBarDetail(context, 'Voucher'),
                  //       // drawer: MyDrawer(),
                  //       body: VoucherFragment(),
                  //     ),
                  //   ),
                  // );
                } else {
                  markAsRead(notif.idNotif);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0), // Padding agar tampilan lebih rapi
                    decoration: BoxDecoration(
                      color: notif.type == "Voucher"
                          ? Colors.green
                              .withOpacity(0.3) // Warna hijau transparan
                          : notif.type == "Informasi"
                              ? Colors.blue.withOpacity(0.3)
                              : notif.type == "Info Voucher"
                                  ? Colors.blue.withOpacity(0.3)
                                  : notif.type == "Promo"
                                      ? Colors.yellow.withOpacity(0.3)
                                      : notif.type == "Berita"
                                          ? Colors.purple.withOpacity(0.3)
                                          : Colors.grey.withOpacity(
                                              0.3), // Default warna abu-abu transparan
                      borderRadius:
                          BorderRadius.circular(4.0), // Membuat sudut membulat
                    ),
                    child: Text(
                      notif.type,
                      style: TextStyle(
                        fontFamily: "WorkSansBold",
                        fontSize: 12.0,
                        color: Colors.black, // Warna teks hitam agar terbaca
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    notif.message ?? 'N/A',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color.fromARGB(255, 120, 120, 120),
                      fontSize: 12.0,
                      fontFamily: "WorkSans",
                    ),
                  ),
                  SizedBox(height: 5.0),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatTanggal(notif.tgl), // ✅ Tanggal tetap di posisi yang sama
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 9.0,
                  fontFamily: "WorkSans",
                ),
              ),
              SizedBox(
                  height: 3.0), // Jarak kecil antara tanggal dan notif.open
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0), // Padding untuk tampilan lebih baik
                decoration: BoxDecoration(
                  color: notif.open == '0'
                      ? Colors.red
                      : Colors.blue, // Warna background sesuai kondisi
                  borderRadius:
                      BorderRadius.circular(4.0), // Membuat sudut membulat
                ),
                child: Text(
                  notif.open == '0' ? 'Belum Dibaca' : 'Sudah Dibaca',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white, // Warna teks putih
                    fontSize: 9.0,
                    fontFamily: "WorkSans",
                    fontWeight: FontWeight.bold, // Teks lebih tegas
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Notif>>(
      future: fetchNotif(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        // Pastikan snapshot.data tidak null sebelum digunakan
        final List<Notif> notifList = snapshot.data ?? [];
        if (notifList == null || notifList.isEmpty) {
          return Center(child: Text("Tidak ada notifikasi"));
        }

        return ListView.builder(
          itemCount: notifList.length,
          itemBuilder: (context, index) {
            return _rowNotif(notifList[index]);
          },
        );
      },
    );
  }
}
