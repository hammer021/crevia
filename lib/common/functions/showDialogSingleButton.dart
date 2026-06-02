import 'package:flutter/material.dart';

void showDialogSingleButtonWithAction(BuildContext context, String title,
    String message, String buttonLabel, String nav) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new TextButton(
            child: new Text(buttonLabel),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(nav);
            },
          ),
        ],
      );
    },
  );
}

void showDialogSingleButton(
    BuildContext context, String title, String message, String buttonLabel) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new TextButton(
            child: new Text(buttonLabel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showDialogSingleButtonss(BuildContext context, String title, String content, String buttonText, {VoidCallback onOkPressed = _defaultOnOkPressed}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Mencegah dialog ditutup dengan menekan di luar
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text(buttonText),
            onPressed: () {
              // Panggil callback dan tutup dialog
              onOkPressed(); // Panggil callback
              Navigator.of(context).pop(); // Tutup dialog
            },
          ),
        ],
      );
    },
  );
}

void showDialogSingleButtons(BuildContext context, String title, String content, String buttonText, {VoidCallback onOkPressed = _defaultOnOkPressed}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Mencegah dialog ditutup dengan menekan di luar
    builder: (BuildContext context) {
      return AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min, // Supaya tidak terlalu besar
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green, // Warna hijau untuk success
                size: 50, // Ukuran ikon
              ),
              SizedBox(height: 10), // Spasi antara ikon dan teks
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text(buttonText),
            onPressed: () {
              // Panggil callback dan tutup dialog
              onOkPressed(); // Panggil callback
              // Navigator.of(context).pop(); // Tutup dialog
            },
          ),
        ],
      );
    },
  );
}


// Fungsi default jika tidak ada onOkPressed yang diberikan
void _defaultOnOkPressed() {}

