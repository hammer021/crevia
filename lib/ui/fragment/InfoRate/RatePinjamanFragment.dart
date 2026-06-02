import 'package:flutter/material.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';

class RatePinjamanFragment extends StatefulWidget {
  @override
  _RatePinjamanFragmentState createState() => _RatePinjamanFragmentState();
}

class _RatePinjamanFragmentState extends State<RatePinjamanFragment> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 20),
        child: FutureBuilder(
          future: getDataRatePinjaman(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Table(
                    border: TableBorder.all(color: Colors.black54, width: 1),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FixedColumnWidth(120),
                      1: FixedColumnWidth(120),
                      2: FixedColumnWidth(100),
                    },
                    children: [
                      // Header
                      TableRow(
                        decoration: BoxDecoration(color: Colors.yellow),
                        children: [
                          tableHeader("Jenis"),
                          tableHeader("Tenor"),
                          tableHeader("Margin"),
                        ],
                      ),
                      // Data
                      ...data.map<TableRow>((row) {
                        return TableRow(
                          children: [
                            tableCell(row.jenis),
                            tableCell(row.tenor),
                            tableCell(row.margin),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            }

            return Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "NeoSans",
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "NeoSans",
          fontSize: 14.0,
        ),
      ),
    );
  }
}
