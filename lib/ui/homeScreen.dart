import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kmob/common/apifunctions/requestLogoutAPI.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/model/home_model.dart';
import 'package:kmob/model/profile_model.dart';
import 'package:kmob/ui/fragment/Administrasi/AdministrasiFragment.dart';
import 'package:kmob/ui/fragment/Bantuan/BantuanFragment.dart';
import 'package:kmob/ui/fragment/AllMenu/AllMenuFragment.dart';
import 'package:kmob/ui/fragment/Notifikasi/NotifikasiFragment.dart';
import 'package:kmob/ui/fragment/InfoRate/RatePinjamanFragment.dart';
import 'package:kmob/ui/fragment/InfoRate/RateSimpananFragment.dart';
import 'package:kmob/ui/fragment/ListSPBU/RiwayatSPBU.dart';
import 'package:kmob/ui/fragment/ListSetoran/FragmentListSetoran.dart';
import 'package:kmob/ui/fragment/PembayaranKredit/PembayaranKreditFragment.dart';
import 'package:kmob/ui/fragment/Pinjaman/PinjamanFragment.dart';
import 'package:kmob/ui/fragment/Pinjaman/SimulasiPinjaman.dart';
import 'package:kmob/ui/fragment/Rekening/SimpananFragment.dart';
import 'package:kmob/ui/fragment/Setoran/FragmentSetoran.dart';
import 'package:kmob/ui/fragment/Simulasi/SimulasiFragment.dart';
import 'package:kmob/ui/fragment/Produk/ProdukFragment.dart';
import 'package:kmob/ui/fragment/Spbu/UploadNotaSPBU.dart';
// import 'package:kmob/ui/fragment/Spbu/EntrySPBUScreen.dart';
// import 'package:kmob/ui/fragment/Spbu/UploadSPBUScreen.dart';
import 'package:kmob/ui/fragment/TentangFragment.dart';
import 'package:kmob/ui/fragment/Voucher/VoucherFragmentScreen.dart';
import 'package:kmob/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
// import 'package:http/http.dart' as http;
import 'fragment/Home/HomeFragment.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

//Let's define a DrawerItem data object
class DrawerItem {
  String? key;
  String? title;
  String? subtitle;
  IconData? icon;
  DrawerItem(this.key, this.title, this.subtitle, this.icon);
}

class HomeScreen extends StatefulWidget {
  String? menu;

  HomeScreen({this.menu});

  //Let's define our drawer items, strings and images
  final drawerItems = [
    new DrawerItem("beranda", "Beranda", "Halaman Depan", Icons.home),
    new DrawerItem("simpanan", "Rekening Simpanan",
        "Informasi Rekening Simpanan", FontAwesomeIcons.moneyBill),
    new DrawerItem("pinjaman", "Rekening Pinjaman",
        "Informasi Rekening Pinjaman", FontAwesomeIcons.moneyCheck),
    //new DrawerItem("simulasipinjaman", "Simulasi Pinjaman", "Simulasi Pinjaman",
    //   FontAwesomeIcons.moneyCheck),
    new DrawerItem("setoran", "Setoran Tunai", "Setoran tunai ke rekening anda",
        FontAwesomeIcons.moneyBillWave),
    new DrawerItem("riwayatsetoran", "Riwayat Setoran",
        "Riwayat Setoran tunai ke rekening anda", FontAwesomeIcons.history),
    new DrawerItem("spbu", "Transaksi SPBU", "Klaim Transaksi SPBU Tunai",
        FontAwesomeIcons.gasPump),
    new DrawerItem("riwayatspbu", "Riwayat Transaksi SPBU",
        "Riwayat klaim transaksi SPBU Tunai", FontAwesomeIcons.history),
    new DrawerItem("voucher", "Voucher", "Kupon & Voucher Elektronik",
        FontAwesomeIcons.creditCard),
    new DrawerItem("infolain", "Informasi Produk & Jasa Lainnya",
        "Layanan lainnya", FontAwesomeIcons.productHunt),
    new DrawerItem("bantuan", "Bantuan", "Bantuan penggunaan aplikasi",
        FontAwesomeIcons.book),
    new DrawerItem("notifikasi", "Notifikasi", "Notifikasi aplikasi",
        FontAwesomeIcons.solidBell),
        new DrawerItem("ratepinjaman", "Rate Pinjaman", "Informasi rate pinjaman",
        FontAwesomeIcons.calculator),
        new DrawerItem("ratesimpanan", "Rate Simpanan", "Informasi rate simpanan",
        FontAwesomeIcons.funnelDollar),
    new DrawerItem("administrasi", "Administrasi",
        "Profil , Pengaturan, dan lain - lain", FontAwesomeIcons.cogs),
    new DrawerItem("homepage", "Homepage", "Halaman website",
        FontAwesomeIcons.chrome),
    new DrawerItem("produkjasa", "Pembayaran Kredit", "Pembayaran Kredit",
        FontAwesomeIcons.creditCard),
    new DrawerItem(
        "allmenu", "Lihat Semua", "Lihat Semua Menu", FontAwesomeIcons.thLarge),
    new DrawerItem("tentang", "Tentang aplikasi",
        "Versi Aplikasi, Term and Condition", FontAwesomeIcons.infoCircle),
    new DrawerItem("keluar", "Keluar", "Log out dan keluar aplikasi",
        FontAwesomeIcons.signOutAlt),
  ];
  // final drawerItems = [
  //   new DrawerItem("beranda", "Beranda", "Halaman Depan", Icons.home),
  //   new DrawerItem("administrasi", "Administrasi",
  //       "Profil , Pengaturan, dan lain - lain", FontAwesomeIcons.cogs),
  //   new DrawerItem("homepage", "Homepage K3PG", "Halaman website K3PG",
  //       FontAwesomeIcons.chrome),
  //   new DrawerItem("tentang", "Tentang aplikasi",
  //       "Versi Aplikasi, Term and Condition", FontAwesomeIcons.infoCircle),
  //   new DrawerItem("keluar", "Keluar", "Log out dan keluar aplikasi",
  //       FontAwesomeIcons.signOutAlt),
  // ];
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? tokens;
  String? appBarTitle;
  String username = "";
  String email = "";
  String nak = "";
  String unread_count = "";
  String? photo;
  bool isData = false;
  int notificationCount = 0;
  Timer? _timer;
  SharedPreferences? sharedPreferences;
  Map<String, String> get headers => {
        'Authorization': 'Bearer $tokens',
        'Content-Type': 'application/json',
      };
  ProfileModel? profile;
  CountNotif? notify;
  bool? tokenReady;

  void persist(String value) {
    // setState(() {
    // });

    tokens = value;
    sharedPreferences?.setString('LastToken', value);
  }

  Future<void> getData() async {
    //get token
    SharedPreferences.getInstance().then((SharedPreferences sp) async {
      sharedPreferences = sp;
      tokens = sharedPreferences!.getString('LastToken');
      debugPrint('Last Token: ' + tokens!);
      // will be null if never previously saved
      if (["", null, false, 0].contains(tokens)) {
        tokens = "";
        persist(tokens!); // set an initial value
      } else {
        if (tokens != "") {
          String url = APIConstant.urlBase + APIConstant.serverApi + "profile";

          // debugPrint(url);

          final response = await executeRequest(url);
          //  http.get(Uri.parse(url), headers: headers);

          if (response.statusCode == 200) {
            // If the call to the server was successful, parse the JSON.
            profile = new ProfileModel.fromJson(json.decode(response.body));
            username = profile?.nmAng ?? '';
            email = profile?.email ?? '';
            photo = profile?.pathFoto ?? '';
            isData = true;

            if (mounted) {
              setState(() {});
            }
          } else if (response.statusCode == 401) {
            if (mounted) {
              Navigator.of(context).pushReplacementNamed('/LoginScreen');
            }
          } else {
            print(
                'Something went wrosdng. \nResponse Code : ${response.statusCode}');
          }
        }
      }
    });
  }

  Future<void> fetchUnreadCount() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      tokens = sharedPreferences!.getString('LastToken');

      if (tokens != "") {
        String xurl = APIConstant.urlBase +
            APIConstant.serverApi +
            "notifikasi/count_unread";

        final response = await executeRequest(
          xurl,
          method: RequestMethod.POST,
          headers: {"Authorization": "Bearer $tokens"},
        );

        if (response.statusCode == 200) {
          notify = CountNotif.fromJson(json.decode(response.body));
          int newCount = notify?.unreadCount ?? 0;
          if (mounted && newCount != notificationCount) {
            setState(() {
              notificationCount = newCount;
            });
          }
        } else {
          print('Error: Response Code ${response.statusCode}');
        }
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }

  int _selectedDrawerIndex = 0;
  String callback = "";

  _getAppBar(int post) {
    String title = "";

    if (appBarTitle != null && appBarTitle != "") {
      // title = "K3PG - " + appBarTitle!;
      title = appBarTitle!;
    } else {
      // title = "K3PG - " + widget.drawerItems[post].title!;
      title = widget.drawerItems[post].title!;
    }

    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(Icons.home,
            color: Colors.white), // Ganti dengan gambar jika ingin custom image
        onPressed: () {
          // Navigator.of(context).pushReplacementNamed('/HomeScreen');
          setState(() {
            _selectedDrawerIndex =
                widget.drawerItems.indexWhere((item) => item.key == "beranda");
            fetchUnreadCount();
          });
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Container(
              padding: new EdgeInsets.only(right: 13.0),
              child: Text(
                "$title",
                // overflow: TextOverflow.ellipsis,
                maxLines: 2, // maksimal 2 baris
                overflow: TextOverflow.visible,
                softWrap: true,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: "WorkSans"),
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDrawerIndex = widget.drawerItems
                        .indexWhere((item) => item.key == "notifikasi");
                    fetchUnreadCount();
                  });
                },
                child: Stack(
                  children: [
                    Icon(Icons.notifications_active_rounded,
                        color: Colors.white, size: 28),
                    // if (int.tryParse(unread_count ?? '0') ?? 0 > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 7,
                          minHeight: 7,
                        ),
                        child: Text(
                          '$notificationCount',
                          // '1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDrawerIndex = widget.drawerItems
                        .indexWhere((item) => item.key == "administrasi");
                    fetchUnreadCount();
                  });
                },
                child: Column(
                  children: [
                    ClipOval(
                      child: photo != null && photo!.isNotEmpty
                          ? Image.network(
                              photo!,
                              height: 40,
                              width: 40,
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              'assets/img/logo.jpg',
                              fit: BoxFit.contain,
                              height: 35,
                            ),
                    ),
                    SizedBox(height: 1), // Jarak antara foto dan username
                    Text(
                      username,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.0,
                        fontFamily: "WorkSans",
                      ),
                    ),
                  ],
                ),
              ),
              // ClipOval(
              //   child:
              //   Image.network(
              //                 photo,
              //                 height: 40,
              //                 width: 40,
              //                 fit: BoxFit.contain,
              //               ),
              // ),
            ],
          ),
        ],
      ),
      backgroundColor: ColorPalette.warnaCorporate,
      iconTheme: IconThemeData(color: Colors.white),
      elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
    );
  }

  //Let's update the selectedDrawerItemIndex the close the drawer
  _onSelectItem(int index) {
    // setState(() => _selectedDrawerIndex = index);
    if (index == 12) {
      // _launchURL();
    }

    if (index == 12) {
      _launchURL();
      // } else if (index == 11) {
      //   _aboutApps();
    }

    setState(() {
      _selectedDrawerIndex = index;

      // if (index == 11) {
      //   _launchURL();
      //   // } else if (index == 11) {
      //   //   _aboutApps();
      // } else {
      //   _selectedDrawerIndex = index;
      // }
    });
    //we close the drawer
    if (index != (widget.drawerItems.length - 1)) {
      Navigator.of(context).pop();
      fetchUnreadCount();
    } else {
      requestLogoutAPI(context);
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }
  }

  _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastScreenRoute', lastRoute);
  }

  Stream<int>? notificationStream;
  @override
  void initState() {
    super.initState();
    fetchUnreadCount();

    Timer(Duration(seconds: 3), () {
      this.getData();
      fetchUnreadCount();
      //  this.getCountNotif();
      _saveCurrentRoute("/HomeScreen");
    });

    if (widget.menu != null) {
      // Cari index drawerItem yang punya key = widget.menu
      final index =
          widget.drawerItems.indexWhere((item) => item.key == widget.menu);
      if (index != -1) {
        setState(() {
          _selectedDrawerIndex = index;
          callback = widget.menu!;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() => fetchUnreadCount());
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
  }

  // Widget _buildChild(int position) {
  //   String key = widget.drawerItems[position].key;
  //   String mode = callback == "" ? key : callback;
  //   callback = "";
  //   appBarTitle = "";
  //   switch (mode) {
  //     //home
  //     case "beranda":
  //       return new HomeFragment(onMenuSelect: (String menu) {
  //         print(menu);
  //         switch (menu) {
  //           case "ratesimpanan":
  //             appBarTitle = "Rate Simpanan";
  //             break;
  //           case "voucher":
  //             appBarTitle = "Voucher";
  //             break;
  //           case "ratepinjaman":
  //             appBarTitle = "Rate Pinjaman";
  //             break;
  //           case "administrasi":
  //             appBarTitle = "Administrasi";
  //             break;
  //           case "produkjasa":
  //             appBarTitle = "Pembayaran Kredit";
  //             break;
  //           case "bantuan":
  //             appBarTitle = "Bantuan";
  //             break;
  //           case "allmenu":
  //             appBarTitle = "Semua Menu & Layanan";
  //             break;
  //           case "notifikasi":
  //             appBarTitle = "Notifikasi";
  //             break;
  //           case "infolain":
  //             appBarTitle = "Informasi Produk & Jasa";
  //             break;
  //           default:
  //         }
  //         if (menu != null) {
  //           setState(() {
  //             callback = menu;
  //           });
  //         }
  //       });
  //       break;
  //     //rekeningku simpanan
  //     case "simpanan":
  //       return new SimpananFragment();
  //     //rekeningku pinjaman
  //     case "pinjaman":
  //       return new PinjamanFragment();
  //     case "simulasipinjaman":
  //       return new SimulasiPinjaman();
  //     //setoran
  //     case "setoran":
  //       return new FragmentSetoran();
  //     //riwayat setoran
  //     case "riwayatsetoran":
  //       return new FragmentListSetoran();
  //     //form klaim spbu
  //     case "spbu":
  //       return new TabEntriNotaSPBU();
  //     // return new EntrySPBUScreen();
  //     //riwayat klaim spbu
  //     case "riwayatspbu":
  //       return new RiwayatSPBU();
  //     //bantuan
  //     case "bantuan":
  //       return new BantuanFragment();
  //     //Notifikasi
  //     case "notifikasi":
  //       return new NotifikasiFragment();
  //     //Administrasi
  //     case "administrasi":
  //       return new AdministrasiFragment();
  //       // requestLogoutAPI(context);
  //       // Navigator.of(context).pushReplacementNamed('/LoginScreen');
  //       break;
  //     case "tentang":
  //       return new TentangFragment();
  //     case "ratesimpanan":
  //       return new RateSimpananFragment();
  //     // return new RateSimpananTableFragment();
  //     case "ratepinjaman":
  //       return new RatePinjamanFragment();
  //     case "produkjasa":
  //       return new PembayaranKreditFragment();
  //     case "voucher":
  //       return new VoucherFragment();
  //     case "infolain":
  //       return new ProdukFragment();
  //     case "allmenu":
  //       return AllMenuFragment();
  //     default:
  //       return new SimulasiFragment();
  //   }
  // }
  Widget _buildChild(int position) {
    String key = widget.drawerItems[position].key!;
    appBarTitle = "";

    switch (key) {
      // home
      case "beranda":
        return HomeFragment(onMenuSelect: (String menu) {
          if (menu != null) {
            setState(() {
              int foundIndex =
                  widget.drawerItems.indexWhere((item) => item.key == menu);

              if (foundIndex != -1) {
                _selectedDrawerIndex = foundIndex;
              } else {
                print("Menu $menu tidak ditemukan di drawerItems");
              }
              // optional: set title sesuai menu yang dipilih
              switch (menu) {
                case "ratesimpanan":
                  appBarTitle = "Rate Simpanan";
                  break;
                case "voucher":
                  appBarTitle = "Voucher";
                  break;
                case "ratepinjaman":
                  appBarTitle = "Rate Pinjaman";
                  break;
                case "administrasi":
                  appBarTitle = "Administrasi";
                  break;
                case "produkjasa":
                  appBarTitle = "Pembayaran Kredit";
                  break;
                case "bantuan":
                  appBarTitle = "Bantuan";
                  break;
                case "allmenu":
                  appBarTitle = "Semua Menu & Layanan";
                  break;
                case "notifikasi":
                  appBarTitle = "Notifikasi";
                  break;
                case "infolain":
                  appBarTitle = "Informasi Produk & Jasa";
                  break;
                default:
                  appBarTitle = "";
              }
            });
          }
        });
      // rekening simpanan
      case "simpanan":
        return SimpananFragment();
      // rekening pinjaman
      case "pinjaman":
        return PinjamanFragment();
      case "simulasipinjaman":
        return SimulasiPinjaman();
      // setoran
      case "setoran":
        return FragmentSetoran();
      // riwayat setoran
      case "riwayatsetoran":
        return FragmentListSetoran();
      // form klaim spbu
      case "spbu":
        return TabEntriNotaSPBU();
      // riwayat klaim spbu
      case "riwayatspbu":
        return RiwayatSPBU();
      // bantuan
      case "bantuan":
        return BantuanFragment();
      // notifikasi
      case "notifikasi":
        return NotifikasiFragment();
      // administrasi
      case "administrasi":
        return AdministrasiFragment();
      case "tentang":
        return TentangFragment();
      case "ratesimpanan":
        return RateSimpananFragment();
      case "ratepinjaman":
        return RatePinjamanFragment();
      case "produkjasa":
        return PembayaranKreditFragment();
      case "voucher":
        return VoucherFragment();
      case "infolain":
        return ProdukFragment();
      case "allmenu":
        return AllMenuFragment();
      default:
        return SimulasiFragment();
    }
  }

  _launchURL() async {
    const url = 'https://www.kopkarpkt.com/';
    try {
      await launch(url);
    } catch (e) {
      throw 'Could not launch $url: $e';
    }
  }

  // Future<bool> _onWillPop() {
  //   if (_selectedDrawerIndex != 0) {
  //     setState(() {
  //       _selectedDrawerIndex = 0;
  //     });
  //   } else {
  //     return showDialog(
  //       context: context,
  //       builder: (context) {
  //         print("tes " + _selectedDrawerIndex.toString());
  //         return new AlertDialog(
  //           title: new Text('Are you sure?'),
  //           content: new Text('Do you want to exit an App'),
  //           actions: <Widget>[
  //             new TextButton(
  //               onPressed: () => Navigator.of(context).pop(false),
  //               child: new Text('No'),
  //             ),
  //             new TextButton(
  //               onPressed: () => Navigator.of(context).pop(true),
  //               child: new Text('Yes'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }
  DateTime? _lastBackPressed;

  Future<bool> _onWillPop() async {
    int berandaIndex =
        widget.drawerItems.indexWhere((item) => item.key == "beranda");
    print('🔔 berandaIndex: $berandaIndex');

    if (_selectedDrawerIndex != berandaIndex) {
      // Kalau bukan di Beranda → balik ke Beranda
      setState(() {
        _selectedDrawerIndex = berandaIndex;
      });
      return false;
    }

    // Sudah di Beranda → double back to exit
    DateTime now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tekan kembali sekali lagi untuk keluar'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      return false; // tahan keluar dulu
    }

    // Back 2x dalam 2 detik → keluar aplikasi
    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // drawerOptions.clear();

    List<String> divide = [
      "beranda",
      "simulasipinjaman",
      "riwayatsetoran",
      "riwayatspbu",
      "infolain"
    ];
    // List<int> divide = [0, 2, 4, 6, 7, 9];
    List<Widget> drawerOptions = [];
    //Let's create drawer list items. Each will have an icon and text
    for (int i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];

      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(
          d.title!,
          style: new TextStyle(fontFamily: "WorkSans", fontSize: 14.0),
        ),
        subtitle: new Text(
          d.subtitle!,
          style: new TextStyle(color: Colors.grey[300], fontSize: 11.0),
        ),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
      if (divide.contains(d.key))
        drawerOptions.add(Divider(
          color: Color.fromARGB(255, 255, 255, 255),
        ));
    }

    return WillPopScope(
      child: SafeArea(
        child: PlatformScaffold(
          // appBar: new MyAppBar(_selectedDrawerIndex),
          appBar: _getAppBar(_selectedDrawerIndex),
          drawer: Drawer(
            child: Container(
              color: ColorPalette.warnaCorporate,
              child: ListTileTheme(
                iconColor: Colors.white,
                selectedColor: Colors.yellow[500],
                textColor: Colors.white,
                child: new ListView(
                  children: <Widget>[
                    !isData
                        ? new Center(
                            child: Center(
                            child: SizedBox(
                                width: 40.0,
                                height: 40.0,
                                child: const CircularProgressIndicator()),
                          ))
                        : new UserAccountsDrawerHeader(
                            accountName: new Text(username),
                            accountEmail: new Text(email),
                            currentAccountPicture: new CircleAvatar(
                              backgroundImage: new NetworkImage(photo!),
                            ),
                            decoration: new BoxDecoration(
                                image: new DecorationImage(
                                    image:
                                        new AssetImage("assets/img/header.jpg"),
                                    fit: BoxFit.cover)),
                          ),
                    ...drawerOptions
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: _buildChild(_selectedDrawerIndex),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }
}
