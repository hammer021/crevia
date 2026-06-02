import 'package:flutter/material.dart';
import 'package:kmob/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kmob/model/home_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:kmob/ui/fragment/Administrasi/AdministrasiFragment.dart';
import 'package:kmob/common/apifunctions/requestLogoutAPI.dart';
import 'package:kmob/ui/fragment/Bantuan/BantuanFragment.dart';
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
import 'package:kmob/ui/fragment/BuktiPotong/BuktiPotongFragment.dart';
import 'package:kmob/ui/fragment/Produk/ProdukFragment.dart';
import 'package:kmob/ui/fragment/Spbu/UploadNotaSPBU.dart';
import 'package:kmob/ui/fragment/TentangFragment.dart';
import 'package:kmob/ui/fragment/Voucher/VoucherFragmentScreen.dart';

const String kTestString = 'Hello world!';
typedef MenuCallback = void Function(String menu);

class AllMenuFragment extends StatefulWidget {
  const AllMenuFragment({this.onMenuSelect});
  final MenuCallback? onMenuSelect;

  @override
  _AllMenuFragmentState createState() => _AllMenuFragmentState();
}

class _AllMenuFragmentState extends State<AllMenuFragment> {
  BuildContext? _context;
  Map<String, List<K3PGService>> categorizedMenu = {
    "Simpan Pinjam": [
      K3PGService(
          image: FontAwesomeIcons.moneyBill,
          color: ColorPalette.menuRide,
          mode: "simpanan",
          title: "SIMPANAN"),
      K3PGService(
          image: FontAwesomeIcons.moneyCheck,
          color: ColorPalette.menuCar,
          mode: "pinjaman",
          title: "PINJAMAN"),
      K3PGService(
          image: FontAwesomeIcons.funnelDollar,
          color: ColorPalette.menuBluebird,
          mode: "ratesimpanan",
          title: "RATE SIMPANAN"),
      K3PGService(
          image: FontAwesomeIcons.calculator,
          color: ColorPalette.menuFood,
          mode: "ratepinjaman",
          title: "RATE PINJAMAN"),
      K3PGService(
          image: FontAwesomeIcons.dollarSign,
          color: ColorPalette.menuShop,
          mode: "setoran",
          title: "SETORAN TUNAI"),
      K3PGService(
          image: FontAwesomeIcons.fileInvoiceDollar,
          color: ColorPalette.menuPulsa,
          mode: "riwayatsetoran",
          title: "RIWAYAT SETORAN"),
      K3PGService(
          image: FontAwesomeIcons.bookReader,
          color: Colors.blueGrey,
          mode: "buktipotong",
          title: "BUKTI POTONG"),
    ],
    // "SPBU": [
    //   K3PGService(
    //       image: FontAwesomeIcons.gasPump,
    //       color: ColorPalette.menuDeals,
    //       mode: "spbu",
    //       title: "TRANSAKSI SPBU"),
    //   K3PGService(
    //       image: FontAwesomeIcons.receipt,
    //       color: Colors.orange[500] ?? Colors.orange,
    //       mode: "riwayatspbu",
    //       title: "RIWAYAT TRANSAKSI SPBU"),
    // ],
    // "Produk & Voucher": [
    //   K3PGService(
    //       image: FontAwesomeIcons.gift,
    //       color: ColorPalette.menuSend,
    //       mode: "voucher",
    //       title: "VOUCHER"),
    //   K3PGService(
    //       image: FontAwesomeIcons.shoppingBag,
    //       color: Colors.orange[500] ?? Colors.orange,
    //       mode: "infolain",
    //       title: "PRODUK & JASA"),
    //   K3PGService(
    //       image: FontAwesomeIcons.creditCard,
    //       color: Colors.pink,
    //       mode: "produkjasa",
    //       title: "PEMBAYARAN KREDIT"),
    // ],
    "Lainnya": [
      K3PGService(
          image: FontAwesomeIcons.book,
          color: Colors.blueAccent,
          mode: "bantuan",
          title: "BANTUAN"),
      K3PGService(
          image: FontAwesomeIcons.chrome,
          color: Colors.green,
          mode: "homepage",
          title: "HOMEPAGE"),
      K3PGService(
          image: FontAwesomeIcons.infoCircle,
          color: Color.fromARGB(255, 63, 219, 206),
          mode: "tentang",
          title: "TENTANG APLIKASI"),
      // K3PGService(
      //     image: FontAwesomeIcons.signOutAlt,
      //     color: Color.fromARGB(255, 76, 129, 175),
      //     mode: "keluar",
      //     title: "LOGOUT"),
    ]
  };

  bool isData = false;
  @override
  Widget build(BuildContext context) {
    debugPrint("isData: " + isData.toString());
    _context = context;
    return Container(
        child: new ListView(
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        new Container(
            // padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            color: Colors.white,
            child: new Column(
              children: <Widget>[
                APIConstant.mode == "PROD"
                    ? menu()
                    : SizedBox(
                        height: 10,
                      ),
              ],
            )),
      ],
    ));
  }

  Widget menu() {
    return Container(
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: categorizedMenu.entries.map((entry) {
          final itemCount = entry.value.length;
          final rowCount = (itemCount + 3) ~/ 4;
          final itemHeight = 120.0;
          final totalHeight = rowCount * itemHeight;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                color: Colors.grey[200], // 🎨 Warna background
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                child: Text(
                  entry.key,
                  style: TextStyle(
                    fontFamily: "WorkSansBold",
                    fontSize: 12.0,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: totalHeight,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: itemCount,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return _rowMenuService(entry.value[index], index);
                  },
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  final Map<String, Widget> menuRoutes = {
    "simpanan": SimpananFragment(),
    "pinjaman": PinjamanFragment(),
    "simulasipinjaman": SimulasiPinjaman(),
    "setoran": FragmentSetoran(),
    "riwayatsetoran": FragmentListSetoran(),
    // "spbu": TabEntriNotaSPBU(),
    "riwayatspbu": RiwayatSPBU(),
    "bantuan": BantuanFragment(),
    "notifikasi": NotifikasiFragment(),
    "administrasi": AdministrasiFragment(),
    "tentang": TentangFragment(),
    "ratesimpanan": RateSimpananFragment(),
    "ratepinjaman": RatePinjamanFragment(),
    "produkjasa": PembayaranKreditFragment(),
    "voucher": VoucherFragment(),
    "infolain": ProdukFragment(),
    "default": SimulasiFragment(),
    "keluar": SimulasiFragment(),
    "buktipotong": BuktiPotongFragment(),
  };
  _launchURL() async {
    const url = 'https://kopkarpkt.com/';
    try {
      await launch(url);
    } catch (e) {
      throw 'Could not launch $url: $e';
    }
  }

  Widget _rowMenuService(K3PGService gojekService, int position) {
    return new Container(
      child: InkWell(
        onTap: () {
          if (gojekService.mode == "homepage") {
            _launchURL();
          } else {
            // For other menu items, navigate to the respective page
            Widget? selectedPage =
                menuRoutes[gojekService.mode] ?? menuRoutes["default"];

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text(
                      gojekService.title,
                      style: TextStyle(color: Colors.white),
                      maxLines: 2, // maksimal 2 baris
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                    // Set menu title
                    backgroundColor: ColorPalette.warnaCorporate,
                    iconTheme: const IconThemeData(
                      color: Colors.white, // ⬅️ warna panah back
                    ), // Customize theme color
                  ),
                  body: selectedPage,
                ),
              ),
            );
          }
        },
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                  border: Border.all(color: ColorPalette.grey200, width: 1.0),
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(10.0))),
              padding: EdgeInsets.all(6.0),
              child: new Icon(
                gojekService.image,
                color: gojekService.color,
                size: 28.0,
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 6.0),
            ),
            Center(
              child: new Text(
                gojekService.title,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 9.0,
                  fontFamily: "WorkSansBold",
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Keluar"),
          content: Text("Apakah Anda yakin ingin keluar aplikasi?"),
          actions: <Widget>[
            TextButton(
              child: Text("Tidak"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog if "No"
              },
            ),
            TextButton(
              child: Text("Ya"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                requestLogoutAPI(context); // Call the logout API
                Navigator.of(context).pushReplacementNamed(
                    '/LoginScreen'); // Redirect to Login screen
              },
            ),
          ],
        );
      },
    );
  }
}
