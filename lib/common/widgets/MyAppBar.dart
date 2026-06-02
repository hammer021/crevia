import 'package:flutter/material.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/model/nota_model.dart';
import 'package:kmob/model/pinjaman_model.dart';
import 'package:kmob/model/rate_pinjaman_model.dart';
import 'package:kmob/model/rate_simpanan_model.dart';
import 'package:kmob/model/setoran_model.dart';
import 'package:kmob/model/simpanan_model.dart';
import 'package:kmob/model/voucher_model.dart';
import 'package:kmob/ui/fragment/Potongan/PotonganScreen.dart';
import 'package:kmob/ui/fragment/Rekening/DetailSimpanan2.dart';
import 'package:kmob/ui/fragment/Rekening/DetailSimpananInspira.dart';
import 'package:kmob/ui/fragment/Voucher/DetailVoucherScreen.dart';
import 'package:kmob/utils/constant.dart';
import 'package:badges/badges.dart' as badge;

import '../../ui/fragment/Voucher/pin_input_modal.dart';

Widget appBarDetail(BuildContext context, String title) => AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: Colors.white, fontSize: 16.0, fontFamily: "WorkSans"),
          ),
          ClipOval(
            child: Container(
              child: new Image.asset(
                'assets/img/logo.jpg',
                fit: BoxFit.contain,
                height: 35,
              ),
            ),
          )
          // new ClipRRect(
          //   borderRadius: new BorderRadius.circular(8.0),
          //   child: new Image.asset(
          //     'assets/img/logo.jpg',
          //     fit: BoxFit.contain,
          //     height: 40,
          //   ),
          // ),
        ],
      ),
      backgroundColor: ColorPalette.warnaCorporate,
      iconTheme: IconThemeData(color: Colors.white),
      elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
    );

Widget rowDataRatePinjaman(RatePinjamanModel row, BuildContext context) {
  return GestureDetector(
    onTap: () {
      // header
      //     ? Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => DetailSimpanan2(noSS2: row.noSs2)),
      //       )
      //     : print("tap");
    },
    child: new Container(
        decoration: BoxDecoration(
            color: ColorPalette.grey,
            borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
        margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
        padding: EdgeInsets.only(top: 5.0, bottom: 20.0, left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Margin : " + row.margin + "",
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 15.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Jenis Pinjaman : ",
                  style:
                      new TextStyle(fontFamily: "NeoSansBold", fontSize: 18.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  row.jenis,
                  style:
                      new TextStyle(fontFamily: "NeoSansBold", fontSize: 25.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Tenor : " + row.tenor + "",
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: <Widget>[
            //     Text(
            //       "Nominal : " + row.nominal + "",
            //       style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
            //     ),
            //   ],
            // ),
            SizedBox(
              height: 5.0,
            ),
          ],
        )),
  );
}

Widget rowDataRateSimpanan(RateSimpananModel row, BuildContext context) {
  return GestureDetector(
    onTap: () {
      // header
      //     ? Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => DetailSimpanan2(noSS2: row.noSs2)),
      //       )
      //     : print("tap");
    },
    child: new Container(
        decoration: BoxDecoration(
            color: ColorPalette.grey,
            borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
        margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
        padding: EdgeInsets.only(top: 5.0, bottom: 20.0, left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Jenis Simpanan : ",
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 15.0),
                ),
                Text(
                  row.simpanan,
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 15.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Tenor : ",
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 15.0),
                ),
                Text(
                  row.tenor,
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 15.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Nominal : ",
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 15.0),
                ),
                Text(
                  row.nominal,
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 15.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Suku Bunga : ",
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 15.0),
                ),
                Text(
                  row.sukubunga,
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 15.0),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
          ],
        )),
  );
}

// Widget rowDataRateSimpanan(RateSimpananModel row, BuildContext context) {
//   return GestureDetector(
//     onTap: () {
//       // header
//       //     ? Navigator.push(
//       //         context,
//       //         MaterialPageRoute(
//       //             builder: (context) => DetailSimpanan2(noSS2: row.noSs2)),
//       //       )
//       //     : print("tap");
//     },
//     child: new Container(
//         decoration: BoxDecoration(
//             color: ColorPalette.grey,
//             borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
//         margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
//         padding: EdgeInsets.only(top: 5.0, bottom: 20.0, left: 5.0, right: 5.0),
//         child: Column(
//           children: <Widget>[
//             SizedBox(
//               height: 10.0,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   "Suku Bunga : " + row.sukubunga + "",
//                   style: new TextStyle(fontFamily: "NeoSans", fontSize: 15.0),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 10.0,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   "Jenis Simpanan : ",
//                   style:
//                       new TextStyle(fontFamily: "NeoSansBold", fontSize: 18.0),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   row.simpanan,
//                   style:
//                       new TextStyle(fontFamily: "NeoSansBold", fontSize: 25.0),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 10.0,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   "Tenor : " + row.tenor + "",
//                   style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   "Nominal : " + row.nominal + "",
//                   style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 5.0,
//             ),
//           ],
//         )),
//   );
// }
Widget rowDataNotaSPBU(NotaModel row, BuildContext context) {
  return GestureDetector(
    onTap: () {
      // header
      //     ? Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => DetailSimpanan2(noSS2: row.noSs2)),
      //       )
      //     : print("tap");
    },
    child: new Container(
        decoration: BoxDecoration(
            color: ColorPalette.grey,
            borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
        margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
        padding: EdgeInsets.only(top: 5.0, bottom: 20.0, left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "No referensi : " + row.id,
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontFamily: "WorkSansMedium", fontSize: 10.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Tanggal Transaksi : " + formatDate(row.tanggal),
                            style: new TextStyle(
                                fontFamily: "WorkSansMedium", fontSize: 12.0)),
                      ],
                    ),
                  ],
                ),
                badge.Badge(
                  showBadge: true,
                  badgeStyle: badge.BadgeStyle(
                    badgeColor: row.kodeStatus.toString() == "submit"
                        ? (Colors.blue[600] ?? Colors.blue)
                        : (row.kodeStatus.toString() == "proses" ||
                                row.kodeStatus.toString() == "manual")
                            ? (Colors.yellow[600] ?? Colors.yellow)
                            : row.kodeStatus.toString() == "Terverifikasi"
                                ? (Colors.green[600] ?? Colors.green)
                                : (Colors.red[600] ?? Colors.red),
                    shape: badge.BadgeShape.square,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  badgeContent: Text(
                    row.status.toString(),
                    style: const TextStyle(
                      fontFamily: "WorkSansMedium",
                      fontSize: 10.0,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Nilai : ",
                  style:
                      new TextStyle(fontFamily: "NeoSansBold", fontSize: 18.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  formatCurrency(row.nominal),
                  style:
                      new TextStyle(fontFamily: "NeoSansBold", fontSize: 25.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "No Nota SPBU : " + row.noNota.toString() + "",
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Tanggal Klaim : " + formatDate(row.tanggal) + "",
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            row.kodeStatus.toString() == "Decline"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Alasan ditolak : " + row.keterangan,
                        style: new TextStyle(
                            fontFamily: "NeoSans", fontSize: 12.0),
                      ),
                    ],
                  )
                : Row(),
          ],
        )),
  );
}

Widget rowDataKredit(KreditModel row, BuildContext context) {
  return GestureDetector(
    onTap: () {
      // header
      //     ? Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => DetailSimpanan2(noSS2: row.noSs2)),
      //       )
      //     : print("tap");
    },
    child: new Container(
        decoration: BoxDecoration(
            color: ColorPalette.grey,
            borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
        margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
        padding: EdgeInsets.only(top: 5.0, bottom: 20.0, left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "No referensi : " + row.noTransaksi,
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontFamily: "WorkSansMedium", fontSize: 10.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Tanggal Transaksi : " + formatDate(row.usedDate),
                            style: new TextStyle(
                                fontFamily: "WorkSansMedium", fontSize: 12.0)),
                      ],
                    ),
                  ],
                ),
                badge.Badge(
                  showBadge: true, // pengganti toAnimate
                  badgeStyle: badge.BadgeStyle(
                    badgeColor: Colors.yellow[600] ?? Colors.yellow,
                    shape: badge.BadgeShape.square,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  badgeAnimation: const badge.BadgeAnimation.fade(
                    toAnimate: false, // matikan animasi
                  ),
                  badgeContent: Text(
                    "${row.cicilan} bulan",
                    style: const TextStyle(
                      fontFamily: "WorkSansMedium",
                      fontSize: 10.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Nilai : ",
                  style:
                      new TextStyle(fontFamily: "NeoSansBold", fontSize: 18.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  formatCurrency(row.nominal),
                  style:
                      new TextStyle(fontFamily: "NeoSansBold", fontSize: 25.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Kasir :  " + row.firstName + "" + row.lastName + "",
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            SizedBox(
              height: 5.0,
            ),
          ],
        )),
  );
}

Widget rowDataSetoran1(SetoranModel row, BuildContext context) {
  return GestureDetector(
    onTap: () {
      // Bisa tambahkan navigasi ke detail kalau perlu
    },
    child: Container(
      decoration: BoxDecoration(
        color: ColorPalette.grey,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      padding:
          const EdgeInsets.only(top: 5.0, bottom: 20.0, left: 5.0, right: 5.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "No referensi : ${row.id}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontFamily: "WorkSansMedium",
                      fontSize: 10.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Tanggal Setor : ${formatDate(row.tanggal)}",
                        style: const TextStyle(
                          fontFamily: "WorkSansMedium",
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              badge.Badge(
                showBadge: true,
                badgeStyle: badge.BadgeStyle(
                  badgeColor: row.kodeStatus.toString() == "submit"
                      ? (Colors.blue[600] ?? Colors.blue)
                      : (row.kodeStatus.toString() == "proses" ||
                              row.kodeStatus.toString() == "manual")
                          ? (Colors.yellow[600] ?? Colors.yellow)
                          : row.kodeStatus.toString() == "Terverifikasi"
                              ? (Colors.green[600] ?? Colors.green)
                              : (Colors.red[600] ?? Colors.red),
                  shape: badge.BadgeShape.square,
                  borderRadius: BorderRadius.circular(20),
                ),
                badgeAnimation: const badge.BadgeAnimation.fade(
                  toAnimate: false,
                ),
                badgeContent: Text(
                  row.status.toString(),
                  style: const TextStyle(
                    fontFamily: "WorkSansMedium",
                    fontSize: 10.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const <Widget>[
              Text(
                "Nilai : ",
                style: TextStyle(fontFamily: "NeoSansBold", fontSize: 18.0),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                formatCurrency(row.nominal),
                style:
                    const TextStyle(fontFamily: "NeoSansBold", fontSize: 25.0),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "No Rekening pengirim : ${row.rekening}",
                style: const TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Bank : ${row.bank}",
                style: const TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          row.kodeStatus.toString() == "Decline"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Alasan ditolak : ${row.keterangan}",
                      style: const TextStyle(
                          fontFamily: "NeoSans", fontSize: 12.0),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    ),
  );
}

Widget rowDataVoucher1(VoucherModel row, BuildContext context, String nomor) {
  return GestureDetector(
    onTap: () {
      showPinInputModal(context).then((isPinCorrect) {
        if (isPinCorrect == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailVoucherScreen(param: row),
            ),
          );
        }
      });
    },
    child: Container(
      decoration: BoxDecoration(
        color: ColorPalette.grey,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Row(
            children: [
              badge.Badge(
                showBadge: true,
                badgeStyle: badge.BadgeStyle(
                  badgeColor: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                badgeContent: Text(
                  nomor,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Kolom kiri: gambar + badge
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.asset(
                        'assets/img/logo.jpg',
                        height: 100.0,
                        width: 100.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(height: 5),
                    badge.Badge(
                      showBadge: true,
                      badgeStyle: badge.BadgeStyle(
                        badgeColor: row.idStatus.toString() == "2"
                            ? Colors.grey
                            : ((row.idStatus.toString() == "3" ||
                                        row.idStatus.toString() == "4") &&
                                    (row.voucherstatus == 'Expired'))
                                ? Colors.black
                                : row.idStatus.toString() == "5"
                                    ? Colors.red
                                    : Colors.green,
                        shape: badge.BadgeShape.square,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      badgeAnimation:
                          const badge.BadgeAnimation.fade(toAnimate: false),
                      badgeContent: Text(
                        row.voucherstatus.toString(),
                        style: const TextStyle(
                          fontFamily: "WorkSansMedium",
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 10),

                // Kolom kanan: teks (dibungkus Expanded)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        row.tipe,
                        style: const TextStyle(
                          fontFamily: "NeoSansBold",
                          fontSize: 15.0,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        formatCurrency(row.nominal),
                        style: TextStyle(
                          fontFamily: "NeoSansBold",
                          fontSize: 20.0,
                          color: ColorPalette.warnaCorporate,
                        ),
                      ),
                      Text(
                        "Nominal Terpakai : ${formatCurrency(row.nominalTerpakai)}",
                        style: const TextStyle(
                          fontFamily: "NeoSans",
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        "Sisa : ${formatCurrency(row.nominal - row.nominalTerpakai)}",
                        style: const TextStyle(
                          fontFamily: "NeoSans",
                          fontSize: 12.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Keterangan :",
                        style: TextStyle(
                          fontFamily: "NeoSans",
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        row.keterangan.toString(),
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontFamily: "NeoSans",
                        ),
                      ),
                      Text(
                        "Berlaku: ${formatDate(row.validTo.toString(), true, 'dd/mmm/yyyy')}",
                        style: const TextStyle(
                          fontFamily: "WorkSansMedium",
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget rowDataCouponLog2(CouponLogModel row, BuildContext context) {
  return GestureDetector(
    onTap: () {},
    child: new Container(
        decoration: BoxDecoration(
            color: ColorPalette.grey,
            borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
        margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        padding: EdgeInsets.only(top: 2.0, bottom: 2.0, left: 5.0, right: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: IconButton(
                onPressed: () {},
                iconSize: 36,
                icon: Icon(Icons.exit_to_app),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                //color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'PENUKARAN KUPON',
                          overflow: TextOverflow.fade,
                        ),
                        Text(
                          "" +
                              row.kodeCoupon.substring(0, 3) +
                              "xxxxxxxxx" +
                              row.kodeCoupon
                                  .substring(row.kodeCoupon.length - 3),
                          overflow: TextOverflow.fade,
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                //"Tanggal Transaksi : " +
                                formatDate(row.insertedDate.toString(), true),
                                style: new TextStyle(
                                  fontFamily: "Arial",
                                  fontSize: 13.0,
                                )),
                          ],
                        ),
                        Text("Catatan: " + row.remark.toString(),
                            //formatDate(row.insertedDate.toString(), true),
                            style: new TextStyle(
                              fontFamily: "Arial",
                              fontSize: 13.0,
                            )),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '- ' + formatCurrency(row.nilaiTransaksi),
                            style: new TextStyle(
                                fontFamily: "Arial",
                                fontSize: 16.0,
                                color: Colors.red),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        )),
  );
}

Widget rowDataVoucherLog2(VoucherLogModel row, BuildContext context) {
  return GestureDetector(
    onTap: () {},
    child: new Container(
        decoration: BoxDecoration(
            color: ColorPalette.grey,
            borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
        margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        padding: EdgeInsets.only(top: 2.0, bottom: 2.0, left: 5.0, right: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: IconButton(
                onPressed: () {},
                iconSize: 36,
                icon: Icon(Icons.exit_to_app),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                //color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'PENUKARAN VOUCHER',
                          overflow: TextOverflow.fade,
                        ),
                        Text(
                          "" +
                              row.kodeVoucher.substring(0, 3) +
                              "xxxxxxxxx" +
                              row.kodeVoucher
                                  .substring(row.kodeVoucher.length - 3),
                          overflow: TextOverflow.fade,
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          row.nak + " - " + row.nmAng,
                          overflow: TextOverflow.fade,
                        ),
                        Text(
                          "(" + row.nmPrsh + ")",
                          overflow: TextOverflow.fade,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                // "Tanggal Transaksi : " +
                                formatDate(row.insertedDate.toString(), true),
                                // row.insertedDate.toString(),
                                style: new TextStyle(
                                  fontFamily: "Arial",
                                  fontSize: 13.0,
                                )),
                          ],
                        ),
                        Text("Catatan: " + row.remark.toString(),
                            //formatDate(row.insertedDate.toString(), true),
                            style: new TextStyle(
                              fontFamily: "Arial",
                              fontSize: 13.0,
                            )),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '- ' + formatCurrency(row.nilaiTransaksi),
                            style: new TextStyle(
                                fontFamily: "Arial",
                                fontSize: 16.0,
                                color: Colors.red),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        )),
  );
}

Widget rowDataVoucherLog(VoucherLogModel row, BuildContext context) {
  return GestureDetector(
    onTap: () {},
    child: new Container(
        decoration: BoxDecoration(
            color: ColorPalette.grey,
            borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
        margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        padding: EdgeInsets.only(top: 2.0, bottom: 2.0, left: 5.0, right: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: IconButton(
                onPressed: () {},
                iconSize: 36,
                icon: Icon(Icons.exit_to_app),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                //color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'PENUKARAN VOUCHER',
                          overflow: TextOverflow.fade,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                //"Tanggal Transaksi : " +
                                formatDate(row.insertedDate.toString(), true),
                                style: new TextStyle(
                                  fontFamily: "Arial",
                                  fontSize: 13.0,
                                )),
                          ],
                        ),
                        Text("Catatan: " + row.remark.toString(),
                            //formatDate(row.insertedDate.toString(), true),
                            style: new TextStyle(
                              fontFamily: "Arial",
                              fontSize: 13.0,
                            )),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '- ' + formatCurrency(row.nilaiTransaksi),
                            style: new TextStyle(
                                fontFamily: "Arial",
                                fontSize: 16.0,
                                color: Colors.red),
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: <Widget>[
                        //     Text(
                        //       formatCurrency(row.nilaiTransaksi),
                        //       style: new TextStyle(
                        //           fontFamily: "NeoSansBold",
                        //           fontSize: 20.0,
                        //           color: ColorPalette.warnaCorporate),
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: <Widget>[
                        //     Text(
                        //       "Tanggal Transaksi: " + row.remark.toString() + "",
                        //       style:
                        //           new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: <Widget>[
                        //     Text(
                        //         //"Tanggal Transaksi : " +
                        //         formatDate(row.insertedDate.toString(), true),
                        //         style: new TextStyle(
                        //             fontFamily: "WorkSansMedium",
                        //             fontSize: 12.0,
                        //             fontWeight: FontWeight.bold)),
                        //   ],
                        // ),
                      ]),
                ),
              ),
            ),
            // Text('x')
          ],
        )),
  );
}

Widget rowDataSetoran2(SetoranModel row, BuildContext context) {
  return GestureDetector(
    onTap: () {
      // Navigator.push(...) bisa diaktifkan kalau perlu
    },
    child: Container(
      decoration: BoxDecoration(
        color: ColorPalette.grey,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      padding:
          const EdgeInsets.only(top: 5.0, bottom: 20.0, left: 5.0, right: 5.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "No referensi : ${row.id}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontFamily: "WorkSansMedium",
                      fontSize: 10.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Tanggal Setor : ${formatDate(row.tanggal)}",
                        style: const TextStyle(
                          fontFamily: "WorkSansMedium",
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              badge.Badge(
                showBadge: true,
                badgeStyle: badge.BadgeStyle(
                  badgeColor: row.kodeStatus.toString() == "submit"
                      ? Colors.blue.shade600
                      : (row.kodeStatus.toString() == "proses" ||
                              row.kodeStatus.toString() == "manual")
                          ? Colors.yellow.shade600
                          : row.kodeStatus.toString() == "Terverifikasi"
                              ? Colors.green.shade600
                              : Colors.red.shade600,
                  shape: badge.BadgeShape.square,
                  borderRadius: BorderRadius.circular(20),
                ),
                badgeAnimation: const badge.BadgeAnimation.fade(
                  toAnimate: false,
                ),
                badgeContent: Text(
                  row.status.toString(),
                  style: const TextStyle(
                    fontFamily: "WorkSansMedium",
                    fontSize: 10.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const <Widget>[
              Text(
                "Nilai : ",
                style: TextStyle(
                  fontFamily: "NeoSansBold",
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                formatCurrency(row.nominal),
                style: const TextStyle(
                  fontFamily: "NeoSansBold",
                  fontSize: 25.0,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Jangka ${row.jangka} bulan",
                style: const TextStyle(
                  fontFamily: "NeoSansBold",
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "No Rekening pengirim : ${row.rekening}",
                style: const TextStyle(
                  fontFamily: "NeoSans",
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Bank : ${row.bank}",
                style: const TextStyle(
                  fontFamily: "NeoSans",
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          // Kalau status = Decline, bisa ditampilkan alasan
          // if (row.kodeStatus.toString() == "Decline")
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: <Widget>[
          //       Text(
          //         "Alasan ditolak : ${row.keterangan}",
          //         style: const TextStyle(
          //           fontFamily: "NeoSans",
          //           fontSize: 12.0,
          //         ),
          //       ),
          //     ],
          //   ),
        ],
      ),
    ),
  );
}

Widget rowDataSimpanan2(Simpanan2Model row, BuildContext context, bool header) {
  return GestureDetector(
    onTap: () {
      header
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailSimpanan2(noSS2: row.noSs2)),
            )
          : print("tap");
    },
    child: new Container(
        decoration: BoxDecoration(
            color: ColorPalette.grey,
            borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
        margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
        padding: EdgeInsets.only(top: 5.0, bottom: 20.0, left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            if (header)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "No referensi : " + row.noSs2.toString(),
                    style: new TextStyle(
                        fontFamily: "WorkSansMedium", fontSize: 10.0),
                  ),
                ],
              ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Nilai : ",
                  style:
                      new TextStyle(fontFamily: "NeoSansBold", fontSize: 18.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  formatCurrency(row.jmlSimpanan),
                  style:
                      new TextStyle(fontFamily: "NeoSansBold", fontSize: 25.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Jangka Waktu : " + row.tempoBln.toString() + " bulan",
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
                Text(
                  "Margin : " + row.margin.toString() + " %",
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Tgl Mulai : \n" + formatDate(row.tglSimpan),
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
                Text(
                  "Jatuh Tempo : \n" + formatDate(row.tglJt),
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Status : ",
                  style:
                      new TextStyle(fontFamily: "NeoSansBold", fontSize: 12.0),
                ),
                Text(
                  row.status,
                  style: new TextStyle(
                      color: row.status == "DITARIK"
                          ? Colors.red
                          : row.status == "BARU"
                              ? Colors.blue
                              : Colors.green,
                      fontFamily: "NeoSansBold",
                      fontSize: 12.0),
                ),
              ],
            ),
            row.status == "DITARIK"
                ? Column(
                    children: <Widget>[
                      new Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Bunga terbayar : ",
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                    fontFamily: "NeoSans", fontSize: 12.0),
                              ),
                              Text(
                                "" + formatCurrency(row.jmlDebet),
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                    fontFamily: "NeoSans", fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Denda : ",
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                    fontFamily: "NeoSans", fontSize: 12.0),
                              ),
                              Text(
                                "" + formatCurrency(row.jmlDenda),
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                    fontFamily: "NeoSans", fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    height: 0.0,
                  ),
          ],
        )),
  );
}

Widget rowDataInspira(InspiraModel row, BuildContext context, bool header) {
  return GestureDetector(
    onTap: () {
      header
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailSimpananInspira(
                      noSertifikatInspira: row.noSertifikatInspira)),
            )
          : print("tap");
    },
    child: new Container(
        decoration: BoxDecoration(
            color: ColorPalette.grey,
            borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
        margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
        padding: EdgeInsets.only(top: 5.0, bottom: 20.0, left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            if (header)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "No referensi : " + row.noSertifikatInspira.toString(),
                    style: new TextStyle(
                        fontFamily: "WorkSansMedium", fontSize: 10.0),
                  ),
                ],
              ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Nilai : ",
                  style:
                      new TextStyle(fontFamily: "NeoSansBold", fontSize: 18.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  formatCurrency(row.jmlSimpanan),
                  style:
                      new TextStyle(fontFamily: "NeoSansBold", fontSize: 25.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Jangka Waktu : " + row.tempoBln.toString() + " bulan",
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
                Text(
                  "Margin : " + row.margin.toString() + " %",
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Jenis Pembayaran Margin: " +
                      row.jenisPembayaran.toString() +
                      " Periode",
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Tgl Mulai : \n" + formatDate(row.tglSimpan),
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
                Text(
                  "Jatuh Tempo : \n" + formatDate(row.tglJt),
                  style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Status : ",
                  style:
                      new TextStyle(fontFamily: "NeoSansBold", fontSize: 12.0),
                ),
                Text(
                  row.status,
                  style: new TextStyle(
                      color: row.status == "DITARIK"
                          ? Colors.red
                          : row.status == "BARU"
                              ? Colors.blue
                              : Colors.green,
                      fontFamily: "NeoSansBold",
                      fontSize: 12.0),
                ),
              ],
            ),
            row.status == "DITARIK"
                ? Column(
                    children: <Widget>[
                      new Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Bunga terbayar : ",
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                    fontFamily: "NeoSans", fontSize: 12.0),
                              ),
                              Text(
                                "" + formatCurrency(row.jmlDebet),
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                    fontFamily: "NeoSans", fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Denda : ",
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                    fontFamily: "NeoSans", fontSize: 12.0),
                              ),
                              Text(
                                "" + formatCurrency(row.jmlDenda),
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                    fontFamily: "NeoSans", fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    height: 0.0,
                  ),
          ],
        )),
  );
}

Widget dataKosong() {
  return new Container(
      decoration: BoxDecoration(
          color: ColorPalette.grey,
          borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "No referensi : ",
                style:
                    new TextStyle(fontFamily: "WorkSansMedium", fontSize: 8.0),
              ),
              SizedBox(),
              Text(
                "",
                style:
                    new TextStyle(fontFamily: "WorkSansMedium", fontSize: 8.0),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              Text(
                "",
                style: new TextStyle(fontFamily: "NeoSansBold", fontSize: 12.0),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "",
                style: new TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
              ),
              Text(
                "",
                style:
                    new TextStyle(fontFamily: "WorkSansMedium", fontSize: 12.0),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                "Saldo Akhir : ",
                style: new TextStyle(
                    fontFamily: "NeoSans", fontSize: 12.0, color: Colors.grey),
              ),
              Text(
                "",
                textAlign: TextAlign.left,
                style:
                    new TextStyle(fontFamily: "WorkSansMedium", fontSize: 12.0),
              ),
            ],
          ),
        ],
      ));
}

Widget rowDataPinjaman(PinjamanModel row, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PotonganScreen(
            noPinjam: row.noPinjam,
            nmPinjaman: row.nmPinjaman,
          ),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: ColorPalette.grey,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      padding:
          const EdgeInsets.only(top: 5.0, bottom: 20.0, left: 5.0, right: 5.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "No referensi : ${row.noPinjam}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontFamily: "WorkSansMedium",
                      fontSize: 10.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Tanggal Pinjam : ${formatDate(row.tglPinjam)}",
                        style: const TextStyle(
                          fontFamily: "WorkSansMedium",
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              badge.Badge(
                showBadge: true,
                badgeStyle: badge.BadgeStyle(
                  badgeColor: row.stsLunas.toString() == "Lunas"
                      ? Colors.green.shade600
                      : row.stsLunas.toString() == "Pengajuan"
                          ? Colors.blue.shade600
                          : row.stsLunas.toString() == "Ditolak"
                              ? Colors.red.shade600
                              : row.stsLunas.toString() == "Belum Lunas"
                                  ? Colors.yellow.shade600
                                  : Colors.blue.shade600, // default
                  shape: badge.BadgeShape.square,
                  borderRadius: BorderRadius.circular(20),
                ),
                badgeAnimation: const badge.BadgeAnimation.fade(
                  toAnimate: false,
                ),
                badgeContent: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      row.stsLunas.toString(),
                      style: const TextStyle(
                        fontFamily: "WorkSansMedium",
                        fontSize: 10.0,
                        color: Colors.white,
                      ),
                    ),
                    if (row.stsLunas.toString() == "Lunas")
                      Text(
                        formatDates("${row.blthLunas}-01"),
                        style: const TextStyle(
                          fontFamily: "WorkSansMedium",
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.black87),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const <Widget>[
              Text(
                "Jumlah Pinjaman : ",
                style: TextStyle(fontFamily: "NeoSansBold", fontSize: 18.0),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                formatCurrency(row.jmlPinjam),
                style: const TextStyle(
                  fontFamily: "NeoSansBold",
                  fontSize: 25.0,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Angsuran ${formatCurrency(row.angsuran)}",
                style: const TextStyle(
                  fontFamily: "NeoSansBold",
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Jangka Waktu : ${row.tempoBln} bulan",
                style: const TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
              ),
              Text(
                "Margin : ${row.margin} %",
                style: const TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Biaya Admin : \n${formatCurrency(row.jmlBiayaAdmin)}",
                style: const TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
              ),
              Text(
                "Jumlah Margin : \n${formatCurrency(row.jmlmargin)}",
                style: const TextStyle(fontFamily: "NeoSans", fontSize: 12.0),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          // Kondisi hanya tampil jika status "Ditolak"
          row.stsLunas.toString() == "Ditolak"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFCDD2), // background merah muda
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Alasan Ditolak : ${row.keterangan ?? '-'}",
                        style: const TextStyle(
                          fontFamily: "NeoSans",
                          fontSize: 12.0,
                          color: Color(0xFFB71C1C), // warna teks merah tua
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    ),
  );
}
