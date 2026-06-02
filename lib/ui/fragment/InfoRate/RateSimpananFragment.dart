import 'package:flutter/material.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';

class RateSimpananFragment extends StatefulWidget {
  @override
  _RateSimpananFragmentState createState() => _RateSimpananFragmentState();
}

class _RateSimpananFragmentState extends State<RateSimpananFragment> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 20),
        child: FutureBuilder(
          future: getDataRateSimpanan(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;

              return SingleChildScrollView(
                // hanya scroll vertical
                scrollDirection: Axis.vertical,
                child: Table(
                  border: TableBorder.all(color: Colors.black54, width: 1),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: FractionColumnWidth(0.20), // 20% layar
                    1: FractionColumnWidth(0.20),
                    2: FractionColumnWidth(0.40),
                    3: FractionColumnWidth(0.20),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.yellow),
                      children: [
                        tableHeader("Jenis"),
                        tableHeader("Tenor"),
                        tableHeader("Nominal"),
                        tableHeader("Suku Bunga"),
                      ],
                    ),
                    ...data.map<TableRow>((row) {
                      return TableRow(
                        children: [
                          tableCell(row.simpanan),
                          tableCell(row.tenor),
                          tableCell(row.nominal),
                          tableCell(row.sukubunga),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        softWrap: true,
        style: TextStyle(
          fontFamily: "NeoSans",
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        softWrap: true,
        style: TextStyle(
          fontFamily: "NeoSans",
          fontSize: 13.0,
        ),
      ),
    );
  }
}
