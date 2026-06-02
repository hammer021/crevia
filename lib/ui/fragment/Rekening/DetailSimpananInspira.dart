import 'package:flutter/material.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'package:kmob/utils/constant.dart';

class DetailSimpananInspira extends StatefulWidget {
  final String? noSertifikatInspira;

  const DetailSimpananInspira({Key? key, this.noSertifikatInspira})
      : super(key: key);
  @override
  _DetailSimpananInspiraState createState() => _DetailSimpananInspiraState();
}

class _DetailSimpananInspiraState extends State<DetailSimpananInspira> {
  String? noSertifikatInspira;

  Card headerArea() => Card(
        margin: EdgeInsets.all(10.0),
        elevation: 1.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0))),
        child: Container(
            decoration: BoxDecoration(
                color: ColorPalette.warnaCorporate,
                borderRadius: new BorderRadius.all(new Radius.circular(20.0))),
            padding: EdgeInsets.all(5.0),
            // color: Color(0xFF015FFF),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("No Referensi :",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontFamily: "NeoSansBold")),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(noSertifikatInspira ?? "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontFamily: "NeoSans")),
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            )),
      );
  @override
  Widget build(BuildContext context) {
    noSertifikatInspira = widget.noSertifikatInspira;
    var listdeposito = Container(
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              headerArea(),
              new Container(
                margin: EdgeInsets.all(10.0),
                child: Column(children: <Widget>[
                  FutureBuilder(
                    future: getDataInspira(context, false, noSertifikatInspira),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        int i = 0;
                        return new Column(
                            children: snapshot.data!.map<Widget>((data) {
                          i = i++;
                          return rowDataInspira(data, context, false);
                        }).toList());
                      }
                      return Center(
                        child: SizedBox(
                            width: 40.0,
                            height: 40.0,
                            child: const CircularProgressIndicator()),
                      );
                    },
                  ),
                ]),
              )
            ]));

    return SafeArea(
      child: PlatformScaffold(
        // appBar: new MyAppBar(_selectedDrawerIndex),
        appBar: appBarDetail(context, "Riwayat Simpanan Inspira")
            as PreferredSizeWidget,
        backgroundColor: Colors.white,
        body: Container(
          child: new ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              new Container(
                  // padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      listdeposito,
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
