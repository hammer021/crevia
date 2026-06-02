import 'package:flutter/material.dart';
import 'package:kmob/ui/fragment/Pinjaman/TabPinjamanKKB.dart';
import 'package:kmob/ui/fragment/Pinjaman/TabPinjamanReguler.dart';
import 'package:kmob/utils/constant.dart';

class PinjamanFragment extends StatefulWidget {
  @override
  _PinjamanFragmentState createState() => _PinjamanFragmentState();
}

class _PinjamanFragmentState extends State<PinjamanFragment> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Tunai'),
    // Tab(text: 'KKB'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(137, 255, 255, 255),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: ColorPalette.warnaCorporate,
            bottom: TabBar(
              tabs: myTabs,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            new TabPinjamanReguler(),
            // new TabPinjamanKKB(),
          ],
        ),
      ),
    );
  }
}
