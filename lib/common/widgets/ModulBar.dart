import 'package:flutter/material.dart';

class ModulBar extends StatelessWidget {
  final double height;

  const ModulBar({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue,
                Colors.blue[600] ?? Colors.blue, // kasih fallback
              ],
            ),
          ),
          height: height,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              "Masukkan nominal setoran anda",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: "NeoSansLight",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
