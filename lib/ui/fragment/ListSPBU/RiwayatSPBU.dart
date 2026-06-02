import 'package:flutter/material.dart';
import 'package:kmob/ui/fragment/ListSPBU/ChartKlaimSPBU.dart';
import 'package:kmob/ui/fragment/ListSPBU/ListKlaimSPBU.dart';
import 'package:kmob/utils/constant.dart';

class RiwayatSPBU extends StatefulWidget {
  @override
  _RiwayatSPBUState createState() => _RiwayatSPBUState();
}

class _RiwayatSPBUState extends State<RiwayatSPBU>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  @override
  void initState() {
    controller = new TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Riwayat Klaim'),
    Tab(text: 'Diagram'),
    // Tab(text: 'Syariah'),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        backgroundColor: Colors.white54,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: ColorPalette.warnaCorporate,
            bottom: TabBar(
              tabs: myTabs,
              labelColor: Colors.yellow, // TAB AKTIF
              unselectedLabelColor: Colors.white, // TAB TIDAK AKTIF
              indicatorColor: Colors.yellow, // garis bawah tab aktif
              labelStyle: TextStyle(
                fontSize: 14.0,
                fontFamily: "WorkSans",
                // fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            new ListKlaimSPBU(),
            new ChartKlaimSPBU(),
          ],
        ),
      ),
    );
  }
}
