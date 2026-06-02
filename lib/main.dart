import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kmob/ui/KasirScreen.dart';
import 'package:kmob/ui/homeScreen.dart';
import 'package:kmob/ui/loginScreen.dart';
import 'package:kmob/ui/splashScreen.dart';
import 'package:kmob/ui/fragment/Voucher/VoucherFragmentScreen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:kmob/utils/constant.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:kmob/model/voucher_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:kmob/common/functions/showDialogSingleButton.dart';
// import 'package:kmob/common/widgets/MyAppBar.dart';
import '../../ui/fragment/Voucher/pin_input_modal.dart';
import 'package:kmob/ui/fragment/Voucher/DetailVoucherScreen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:kmob/model/home_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String latestVersion = "";
  String updateUrl = "";
  bool forceUpdate = false;
  bool checkingUpdate = true;
  // bool _exists = false;
  VoucherModel? voucherModel;
  String kode_voucher = "";
  // List<Notif> _notifList = [];
  @override
  void initState() {
    super.initState();
    initPlatformState();
    checkForUpdate();
  }

  Future<void> checkForUpdate() async {
    try {
      // Ambil versi terbaru dari server
      String xurl =
          APIConstant.urlBase + APIConstant.serverApi + "notifikasi2/apps_info";

      final response = await executeRequest(
        xurl,
        method: RequestMethod.GET,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        latestVersion = data["latest_version"];
        updateUrl = data["update_url"];
        forceUpdate = data["force_update"];

        // Ambil versi aplikasi saat ini
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String currentVersion = packageInfo.version;

        // Bandingkan versi
        if (latestVersion.compareTo(currentVersion) > 0 && forceUpdate) {
          showUpdateDialog();
        } else {
          setState(() => checkingUpdate = false);
        }
      }
    } catch (e) {
      print("Error checking update: $e");
    }
  }

  void showUpdateDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? ctx = navigatorKey.currentContext;
      if (ctx != null) {
        // Pastikan context tidak null sebelum digunakan
        showDialog(
          context: ctx,
          barrierDismissible: !forceUpdate,
          builder: (context) => AlertDialog(
            title: Text("Pembaruan Tersedia"),
            content: Text(
                "Versi terbaru ($latestVersion) tersedia. Harap perbarui aplikasi."),
            actions: [
              if (!forceUpdate)
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Nanti"),
                ),
              ElevatedButton(
                onPressed: openUpdateUrl,
                child: Text("Perbarui Sekarang"),
              ),
            ],
          ),
        );
      } else {
        print(
            "navigatorKey.currentContext masih null, dialog tidak bisa ditampilkan.");
      }
    });
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
      final BuildContext? navContext = navigatorKey.currentContext;
      if (navContext != null) {
        showPinInputModal(navContext).then((isPinCorrect) {
          if (isPinCorrect == true) {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => DetailVoucherScreen(param: voucherModel!),
              ),
            );
            markAsRead(kode_voucher);
          }
        });
      }

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

  Future<void> markAsRead(String kode_voucher) async {
    String readUrl =
        APIConstant.urlBase + APIConstant.serverApi + "notifikasi/read_kode";
    Map<String, String> headers = {
      'Authorization': 'Bearer $tokens',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> body = {
      "kode_voucher": kode_voucher,
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
        // setState(() {
        //   _notifList
        //       .removeWhere((notif) => notif.id_notif.toString() == idNotif);
        // });
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

  Future<void> initPlatformState() async {
    String app_id = APIConstant.app_id_onesignal;

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.initialize(app_id);
    OneSignal.Notifications.requestPermission(true);

    OneSignal.Notifications.addClickListener((event) {
      var data = event.notification.additionalData;
      // print('🔔 Notifikasi diklik! Data: $data');

      if (data != null && data['screen'] == 'voucher') {
        // navigatorKey.currentState?.pushNamed('/voucher');
        kode_voucher = data['extra_info'];
        kodeVoucherGlobal = data['extra_info'];
        // print('🔔 Running FetchData');

        fetchDataDetailVoucher();
        //  navigatorKey.currentState?.push(
        //   MaterialPageRoute(
        //     builder: (_) => HomeScreen(menu: 'voucher'),
        //   ),
        // );
      }
    });
    // LocationPermission permission = await Geolocator.requestPermission();

    // if (permission == LocationPermission.always ||
    //     permission == LocationPermission.whileInUse) {
    //   Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high,
    //   );

    //   // Kirim lokasi ke OneSignal
    //   // OneSignal.Location.setLocation(
    //   //   latitude: position.latitude,
    //   //   longitude: position.longitude,
    //   // );

    //   print(
    //       "Lokasi berhasil dikirim ke OneSignal: ${position.latitude}, ${position.longitude}");
    // } else {
    //   print("Izin lokasi ditolak");
    // }
    //   final statusLoc = await Permission.locationWhenInUse.request();
    //   if (statusLoc.isGranted) {
    //   print('Lokasi diizinkan');
    //   // OneSignal akan otomatis ambil lokasi tanpa perlu promoteLocation()
    // } else {
    //   print('Izin lokasi ditolak');
    // }
  }

  void openUpdateUrl() async {
    final Uri url = Uri.parse(updateUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $updateUrl");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "CREVIA Apps",
      routes: <String, WidgetBuilder>{
        "/HomeScreen": (BuildContext context) => HomeScreen(),
        "/KasirScreen": (BuildContext context) => KasirScreen(),
        "/LoginScreen": (BuildContext context) => LoginScreen(),
        "/voucher": (BuildContext context) => Scaffold(
              appBar: AppBar(
                title: Text("Voucher"),
                backgroundColor: ColorPalette.warnaCorporate,
              ),
              body: VoucherFragment(),
            ),
      },
      home: SplashScreen(),
    );
  }
}
