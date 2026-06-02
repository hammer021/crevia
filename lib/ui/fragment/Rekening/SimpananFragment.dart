import 'package:flutter/material.dart';
import 'package:kmob/ui/fragment/Rekening/TabSimpananSukarela1.dart';
import 'package:kmob/ui/fragment/Rekening/TabSimpananSukarela2.dart';
import 'package:kmob/ui/fragment/Rekening/TabSimpananInspira.dart';
import 'package:kmob/utils/constant.dart';

class SimpananFragment extends StatefulWidget {
  @override
  _SimpananFragmentState createState() => _SimpananFragmentState();
}

class _SimpananFragmentState extends State<SimpananFragment>
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
    Tab(text: 'Tabungan'),
    Tab(text: 'Deposito'),
    // Tab(text: 'Inspira'),
    // Tab(text: 'Syariah'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
            new TabSimpananSukarela1(),
            new TabSimpananSukarela2(),
            // new TabSimpananInspira(),
          ],
        ),
      ),
    );
  }
}
