import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:kmob/utils/constant.dart';
import 'package:kmob/common/widgets/MyAppBar.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

class BuktiPotongFragment extends StatefulWidget {
  @override
  _BuktiPotongFragmentState createState() => _BuktiPotongFragmentState();
}

class _BuktiPotongFragmentState extends State<BuktiPotongFragment> {
  bool isLoading = false;
  String? selectedBulan;
  int? selectedTahun;
  AndroidDeviceInfo? androidInfo;
  File? _lastFetchedFile; // Tambahan: cache file terakhir di-fetch

  final List<String> bulanList = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  final List<int> tahunList =
      List.generate(6, (index) => DateTime.now().year - index);

  String _convertBulanKeAngka(String bulan) {
    const bulanMap = {
      'Januari': '01',
      'Februari': '02',
      'Maret': '03',
      'April': '04',
      'Mei': '05',
      'Juni': '06',
      'Juli': '07',
      'Agustus': '08',
      'September': '09',
      'Oktober': '10',
      'November': '11',
      'Desember': '12',
    };
    return bulanMap[bulan] ?? '01';
  }

  void _initDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    androidInfo = await deviceInfo.androidInfo;
  }

  Future<File?> fetchSlip(String bulan, int tahun, String fileName) async {
    final url = Uri.parse(APIConstant.urlBase +
        APIConstant.serverApi +
        "potongan/cetak_slip_potga");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('LastToken') ?? '';

    final body = {
      "tahun": tahun.toString(),
      "bulan": _convertBulanKeAngka(bulan),
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        print('Sukses fetch slip: ${response.statusCode}');
        return file;
      } else {
        print('Gagal fetch slip: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetchSlip: $e');
    }
    print('Return null: $fileName');
    return null;
  }

  Future<void> _loadPDF(File file) async {
    setState(() => isLoading = true);
    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PDFViewerScreen(filePath: file.path)),
      );
    } catch (e) {
      print('Gagal tampilkan PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menampilkan PDF')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> requestStoragePermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    int sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      await Permission.manageExternalStorage.request();
    } else {
      await Permission.storage.request();
    }
  }

  Future<void> _downloadPDF({
    required File sourceFile,
    required String fileName,
  }) async {
    try {
      if (sourceFile == null) {
        print("Source file kosong!");
        return;
      }

      Uint8List fileBytes = await sourceFile.readAsBytes();

      final params = SaveFileDialogParams(
        sourceFilePath: sourceFile.path,
        fileName: fileName,
      );

      final savedPath = await FlutterFileDialog.saveFile(params: params);

      if (savedPath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF berhasil disimpan ke: $savedPath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan PDF')),
        );
      }
    } catch (e) {
      print('❌ Gagal menyimpan PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan PDF: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initDeviceInfo();
    final now = DateTime.now();
    selectedBulan = bulanList[now.month - 1];
    selectedTahun = now.year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pilih Bulan", style: TextStyle(fontSize: 16)),
            DropdownButtonFormField<String>(
              value: selectedBulan,
              items: bulanList.map((bulan) {
                return DropdownMenuItem(
                  value: bulan,
                  child: Text(bulan),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedBulan = value;
                    _lastFetchedFile = null; // reset file kalau bulan berubah
                  });
                }
              },
            ),
            SizedBox(height: 16),
            Text("Pilih Tahun", style: TextStyle(fontSize: 16)),
            DropdownButtonFormField<int>(
              value: selectedTahun,
              items: tahunList.map((tahun) {
                return DropdownMenuItem(
                    value: tahun, child: Text(tahun.toString()));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedTahun = value;
                    _lastFetchedFile = null; // reset file kalau tahun berubah
                  });
                }
              },
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final fileName =
                        'Potongan_${selectedBulan}_$selectedTahun.pdf';
                    final file = await fetchSlip(
                        selectedBulan!, selectedTahun!, fileName);
                    if (file != null) {
                      _lastFetchedFile = file;
                      _loadPDF(file);
                    }
                  },
                  icon: Icon(Icons.picture_as_pdf),
                  label: Text('View'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final fileName =
                        'Potongan_${selectedBulan}_$selectedTahun.pdf';
                    File? file = _lastFetchedFile;

                    if (file == null) {
                      file = await fetchSlip(
                          selectedBulan!, selectedTahun!, fileName);
                      if (file != null) {
                        _lastFetchedFile = file;
                      }
                    }

                    if (file != null) {
                      await _downloadPDF(sourceFile: file, fileName: fileName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal mengunduh file PDF')),
                      );
                    }
                  },
                  icon: Icon(Icons.download),
                  label: Text('Download'),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
            if (isLoading)
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              )),
          ],
        ),
      ),
    );
  }
}

// class PDFViewerScreen extends StatelessWidget {
//   final String? filePath;
//   PDFViewerScreen({this.filePath});

//   @override
//   Widget build(BuildContext context) {
//     // final fileName = filePath.split('/').last;
//     final fileName =
//         filePath != null ? filePath!.split('/').last : 'Unknown.pdf';

//     return Scaffold(
//       // appBar: AppBar(title: Text(fileName)),
//       appBar: appBarDetail(context, fileName) as PreferredSizeWidget,
//       body: PDFView(
//         filePath: filePath,
//         enableSwipe: true,
//         swipeHorizontal: false,
//         autoSpacing: true,
//         pageFling: true,
//       ),
//     );
//   }
// }
class PDFViewerScreen extends StatelessWidget {
  final String filePath;

  const PDFViewerScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    final fileName = filePath.split('/').last;

    return Scaffold(
      appBar: appBarDetail(context, fileName) as PreferredSizeWidget,
      body: SfPdfViewer.file(
        File(filePath),
        canShowPaginationDialog: true,
        canShowScrollHead: true,
        enableDoubleTapZooming: true,
      ),
    );
  }
}
