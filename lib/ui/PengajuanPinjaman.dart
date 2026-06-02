import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmob/common/functions/format.dart';
import 'package:kmob/common/functions/future.dart';
import 'package:kmob/common/functions/ui.dart';
import 'package:kmob/common/platform/platformScaffold.dart';
import 'package:kmob/common/widgets/widget.dart';
import 'package:kmob/utils/constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:signature/signature.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:camera/camera.dart';
import 'package:kmob/ui/fragment/Pinjaman/PinjamanFragment.dart';

import 'fragment/Voucher/pin_input_modal.dart';

class PengajuanPinjaman extends StatefulWidget {
  PengajuanPinjaman({Key? key}) : super(key: key);

  @override
  _PengajuanPinjamanState createState() => _PengajuanPinjamanState();
}

class _PengajuanPinjamanState extends State<PengajuanPinjaman> {
  bool _loading = false;

  String? nak;

  bool isPG = false;

  String? username;

  BuildContext? _context;

  String jangkaController = '';
  String? _errorJangka;

  List<DropdownMenuItem> listTenorDefault = [
    const DropdownMenuItem(
      child: Text('[-pilih-]'),
      value: '',
    ),
  ];

  List<DropdownMenuItem> listTenor = [];

  TextEditingController txJmlPinjam = TextEditingController();
  TextEditingController txNoRek = TextEditingController();
  String? _errorTextJmlPinjam;
  String? _errorTextNoRek;
  String formattedJmlPinjam = 'Rp. 0';

  TextEditingController txJmlAngsuran = TextEditingController(text: '0');

  String formattedAngsuran = 'Rp. 0';

  final _debouncer = Debouncer(milliseconds: 1000);

  File? fotoKtpFile;
  String? fotoKtpController = '';
  String? fotoKtpError = '';

  File? fotoSelfieFile;
  String? fotoSelfieController = '';
  String? fotoSelfieError = '';

  File? fotoBuktiPotongFile;
  String? fotoBuktiPotongController = '';
  String? fotoBuktiPotongError = '';

  File? fotoSlipGajiFile;
  String? fotoSlipGajiController = '';
  String? fotoSlipGajiError = '';

  File? fotoMemoFile;
  String? fotoMemoController = '';
  String? fotoMemoError = '';

  // Variabel untuk tanda tangan istri
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  bool _errorTandaTanganIstri = false;

  // Variabel untuk tanda tangan suami
  final SignatureController _signatureControllerSuami = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  bool _errorTandaTanganSuami = false;

  @override
  void dispose() {
    _signatureController.dispose();
    _signatureControllerSuami.dispose();
    _debouncer.cancel();
    super.dispose();
  }

  bool _isUpdating = false;
  void formatJmlPinjam(String value) {
    if (_isUpdating) return;
    // try {
    double jumlahPinjam =
        double.parse(value.replaceAll(RegExp(r'[^0-9]'), '')); // Hanya angka

    if (jumlahPinjam > 20000000) {
      jumlahPinjam = 20000000; // Set ke 20 juta jika lebih dari 20 juta
      _errorTextJmlPinjam = "Maksimal pinjaman 20jt";
    } else {
      _errorTextJmlPinjam = null;
    }

    formattedJmlPinjam = formatCurrency(jumlahPinjam, 0);

    _debouncer.run(() {
      debugPrint('Input jumlah selesai');
      getAngsuran();
    });
    _isUpdating = true;
    setState(() {
      txJmlPinjam.text =
          jumlahPinjam.toInt().toString(); // Update TextFormField
      txJmlPinjam.selection = TextSelection.fromPosition(
        TextPosition(offset: txJmlPinjam.text.length),
      );
    });
    _isUpdating = false;
    // } catch (e) {
    //   setState(() {
    //     _errorTextJmlPinjam = "Diisi dengan angka saja";
    //   });
    // }
  }

  void formatJmlAngsuran(String value) {
    try {
      formattedAngsuran = formatCurrency(double.parse(value), 0);
      // if (value.length < 5) {
      //   _errorTextJmlPinjam = "minimal 5 karakter";
      // } else {
      // if (value == '') {
      //   value = '0';
      // }
      // _errorTextJmlPinjam = null;

      // _debouncer.run(() {
      //   debugPrint('Input jumlah selesai');

      //   getAngsuran();
      // });
      // }

      setState(() {});
    } catch (e) {
      setState(() {
        // _errorTextJmlAngsuran = "Diisi dengan angka saja";
      });
    }
  }

  getTenor() async {
    listTenor = listTenorDefault;

    String url =
        APIConstant.urlBase + APIConstant.serverApi + "pinjaman/tenor_reguler";

    try {
      Response response = await executeRequest(url);

      if (response.statusCode == 200) {
        List<dynamic> dataTenor = jsonDecode(response.body);

        for (var element in dataTenor) {
          listTenor.add(DropdownMenuItem(
            child: Text(element['tahun']),
            value: element['tempo_bln'],
          ));
        }

        debugPrint(listTenor.toString());

        if (mounted) {
          setState(() {});
        }
      } else {
        if (mounted) {
          showInfoDialog(_context!,
              title: 'Network Error', content: Text('Hubungi Adminstrator'));
        }
      }
    } catch (e) {
      if (mounted) {
        showInfoDialog(_context!, title: 'Error', content: Text(e.toString()));
      }
    }
  }

  getAngsuran() async {
    if (txJmlPinjam.text == '' || jangkaController == '') {
      return false;
    }

    setState(() {
      formattedAngsuran = 'menghitung ...';
    });

    String url = APIConstant.urlBase +
        APIConstant.serverApi +
        "pinjaman/hitung_angsuran_reguler";

    Map dataPost = {
      "tempo_bln": jangkaController,
      "jml_pinjam": txJmlPinjam.text,
    };

    try {
      Response response =
          await executeRequest(url, method: RequestMethod.POST, body: dataPost);

      if (response.statusCode == 200) {
        var dataResponse = response.body;

        txJmlAngsuran.text = double.parse(dataResponse).round().toString();
        formatJmlAngsuran(dataResponse);

        if (mounted) {
          setState(() {});
        }
      } else {
        if (mounted) {
          showInfoDialog(_context!,
              title: 'Network Error', content: Text('Hubungi Adminstrator'));
        }
      }
    } catch (e) {
      if (mounted) {
        showInfoDialog(_context!, title: 'Error', content: Text(e.toString()));
      }
    }
  }

  Future<void> _optionsDialogBox(BuildContext context, field) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _getImage("camera", field);
                    },
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: BoxDecoration(
                          border: Border(
                              right:
                                  BorderSide(width: 1.0, color: Colors.blue))),
                      child: Icon(Icons.camera_alt, color: Colors.blue),
                    ),
                    title: Text('Ambil Foto', style: TextStyle(fontSize: 18.0)),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _getImage("gallery", field);
                    },
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: BoxDecoration(
                          border: Border(
                              right:
                                  BorderSide(width: 1.0, color: Colors.blue))),
                      child: Icon(Icons.image, color: Colors.blue),
                    ),
                    title: Text('Pilih Dari Media/Gallery',
                        style: TextStyle(fontSize: 18.0)),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> _optionsDialogBoxnew(BuildContext context, field) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _getImage("camera", field);
                    },
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: BoxDecoration(
                          border: Border(
                              right:
                                  BorderSide(width: 1.0, color: Colors.blue))),
                      child: Icon(Icons.camera_alt, color: Colors.blue),
                    ),
                    title: Text('Ambil Foto', style: TextStyle(fontSize: 18.0)),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future _getImage(String mode, String field) async {
    try {
      File? imageFile;

      XFile? ximageFile;

      setState(() {
        _loading = false;
      });

      ImagePicker imagePicker = ImagePicker();
      switch (mode) {
        case 'camera':
          ximageFile = await imagePicker.pickImage(
              // source: ImageSource.camera, maxHeight: 450.0, maxWidth: 450.0);
              source: ImageSource.camera);
          break;
        case 'gallery':
          PermissionStatus status = await Permission.photos.request();

          debugPrint(status.toString());

          if (status.isGranted) {
            debugPrint('permission granted');
          }

          if (status.isPermanentlyDenied) {
            debugPrint('permanen disable');
            openAppSettings();
          }

          ximageFile = await imagePicker.pickImage(
              // source: ImageSource.gallery, maxHeight: 450.0, maxWidth: 450.0);
              source: ImageSource.gallery);

          break;
        default:
      }

      if (ximageFile == null) {
        return false;
      }

      imageFile = File(ximageFile.path);

      final prefs = await SharedPreferences.getInstance();

      username = prefs.getString('LastUser') ?? '';

      var controller = username! + "_" + basename(imageFile.path);
      // var file = imageFile;
      // var error = '';

      setState(() {
        switch (field) {
          case 'fotoktp':
            fotoKtpFile = imageFile;
            fotoKtpController = controller;
            fotoKtpError = '';
            break;
          case 'fotoselfie':
            fotoSelfieFile = imageFile;
            fotoSelfieController = controller;
            fotoSelfieError = '';
            break;
          case 'fotobuktipotong':
            fotoBuktiPotongFile = imageFile;
            fotoBuktiPotongController = controller;
            fotoBuktiPotongError = '';
            break;
          case 'fotoslipgaji':
            fotoSlipGajiFile = imageFile;
            fotoSlipGajiController = controller;
            fotoSlipGajiError = '';
            break;
          case 'fotomemo':
            fotoMemoFile = imageFile;
            fotoMemoController = controller;
            fotoMemoError = '';
            break;
          default:
        }

        _loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      switch (field) {
        case 'fotoktp':
          fotoKtpFile = null;
          fotoKtpController = '';
          fotoKtpError = e.toString();
          break;
        case 'fotoselfie':
          fotoSelfieFile = null;
          fotoSelfieController = '';
          fotoSelfieError = e.toString();
          break;
        case 'fotobuktipotong':
          fotoBuktiPotongFile = null;
          fotoBuktiPotongController = '';
          fotoBuktiPotongError = e.toString();
          break;
        case 'fotoslipgaji':
          fotoSlipGajiFile = null;
          fotoSlipGajiController = '';
          fotoSlipGajiError = e.toString();
          break;
        case 'fotomemo':
          fotoMemoFile = null;
          fotoMemoController = '';
          fotoMemoError = e.toString();
          break;
        default:
      }

      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _kirimData() async {
    if (_loading) {
      return;
    }

    setState(() {
      _loading = true;
    });

    // Validasi input
    if (jangkaController.isEmpty) {
      _errorJangka = 'Jangka harus dipilih';
    } else {
      _errorJangka = null;
    }
    if (txNoRek.text.isEmpty) {
      _errorTextNoRek = 'No Rekening Penerima Wajib diisi';
    } else {
      _errorTextNoRek = null;
    }
    if (txJmlPinjam.text.isEmpty) {
      _errorTextJmlPinjam = 'Jumlah pinjaman harus diisi';
    } else if (txJmlPinjam.text.length < 5) {
      _errorTextJmlPinjam = 'Minimal 5 karakter';
    } else {
      _errorTextJmlPinjam = null;
    }

    if (fotoKtpFile == null) {
      fotoKtpError = 'Foto KTP harus diupload';
    } else {
      fotoKtpError = null;
    }

    if (fotoSelfieFile == null) {
      fotoSelfieError = 'Foto Selfie harus diupload';
    } else {
      fotoSelfieError = null;
    }

    if (fotoBuktiPotongFile == null) {
      fotoBuktiPotongError = 'Foto Bukti Potong harus diupload';
    } else {
      fotoBuktiPotongError = null;
    }

    if (fotoSlipGajiFile == null) {
      fotoSlipGajiError = 'Foto Slip Gaji harus diupload';
    } else {
      fotoSlipGajiError = null;
    }

    // Validasi memo berdasarkan kondisi isPG
    if (isPG) {
      fotoMemoError = null;
    } else {
      if (fotoMemoFile == null) {
        fotoMemoError = 'Foto Memo harus diupload';
      } else {
        fotoMemoError = null;
      }
    }

    // Validasi tanda tangan
    if (_signatureController.isEmpty) {
      showInfoDialog(_context!,
          title: 'Validasi Input',
          content: const Text('Tanda tangan istri harus diisi.'));
      setState(() {
        _loading = false;
      });
      return;
    }

    if (_signatureControllerSuami.isEmpty) {
      showInfoDialog(_context!,
          title: 'Validasi Input',
          content: const Text('Tanda tangan suami harus diisi.'));
      setState(() {
        _loading = false;
      });
      return;
    }

    // Cek apakah ada error dalam validasi
    if (_errorTextJmlPinjam != null ||
        _errorJangka != null ||
        fotoKtpError != null ||
        fotoSelfieError != null ||
        fotoBuktiPotongError != null ||
        fotoSlipGajiError != null ||
        fotoMemoError != null) {
      showInfoDialog(_context!,
          title: 'Validasi Input',
          content: const Text(
              'Ada kesalahan dalam pengisian form. Silakan periksa kembali.'));

      setState(() {
        _loading = false;
      });
      return;
    }

    // Konfirmasi dari user
    bool konfirmasi = await confirmDialog(_context!,
        title: 'Konfirmasi', content: const Text('Input sudah sesuai?'));

    if (!konfirmasi) {
      setState(() {
        _loading = false;
      });
      return;
    }

    // Validasi PIN
    bool isPinCorrect = await showPinInputModal(_context!) ?? false;

    if (!isPinCorrect) {
      setState(() {
        _loading = false;
      });
      return;
    }

    try {
      // Upload semua file ke Firebase Storage dengan API yang baru
      String fotoKtpUrl = await _uploadFileToStorage(fotoKtpFile!, 'ktp');
      String fotoSelfieUrl =
          await _uploadFileToStorage(fotoSelfieFile!, 'selfie');
      String fotoSlipGajiUrl =
          await _uploadFileToStorage(fotoSlipGajiFile!, 'slip_gaji');
      String fotoBuktiPotongUrl =
          await _uploadFileToStorage(fotoBuktiPotongFile!, 'bukti_potong');

      String fotoMemoUrl = '';
      if (!isPG && fotoMemoFile != null) {
        fotoMemoUrl = await _uploadFileToStorage(fotoMemoFile!, 'memo');
      }

      // Upload tanda tangan istri
      String tandaTanganIstriUrl = await _uploadSignatureToStorage(
          _signatureController, 'tanda_tangan_istri');

      // Upload tanda tangan suami
      String tandaTanganSuamiUrl = await _uploadSignatureToStorage(
          _signatureControllerSuami, 'tanda_tangan_suami');

      // Prepare data untuk API
      var dataHttp = {
        'tempo_bln': jangkaController,
        'jml_pinjam': txJmlPinjam.text,
        'no_rekening': txNoRek.text,
        'no_ang': nak,
        'foto_ktp': fotoKtpUrl,
        'foto_selfie': fotoSelfieUrl,
        'foto_bukti_potong': fotoBuktiPotongUrl,
        'foto_slip_gaji': fotoSlipGajiUrl,
        'foto_memo': fotoMemoUrl,
        'ttd_istri': tandaTanganIstriUrl,
        'ttd_suami': tandaTanganSuamiUrl,
      };

      // Kirim data ke server
      String url = APIConstant.urlBase +
          APIConstant.serverApi +
          "pinjaman/add_pinj_reguler";

      var response =
          await executeRequest(url, body: dataHttp, method: RequestMethod.POST);

      if (response.statusCode == 200) {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _loading = false;
          });

          var responseData = jsonDecode(response.body);

          if (!responseData['status']) {
            showInfoDialog(
              _context!,
              title: 'Error',
              content: Text(responseData['msg']),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(_context!).pop();
                    },
                    child: const Text('Ok'))
              ],
            );
          } else {
            showInfoDialog(
              _context!,
              title: 'Sukses',
              content: const Text(
                  'Pengajuan berhasil dikirim dan segera kami proses.'),
              actions: [
                TextButton(
                    onPressed: () {
                      _resetInput();
                      Navigator.of(_context!).pop();
                      Navigator.of(_context!).pop();
                    },
                    child: const Text('Ok'))
              ],
            );
          }
        });
      } else if (response.statusCode == 401) {
        Navigator.of(_context!).pushReplacementNamed('/LoginScreen');
      } else {
        setState(() {
          _loading = false;
        });

        showInfoDialog(
          _context!,
          title: 'Gagal',
          content:
              const Text('Terjadi kesalahan teknis, hubungi administrator.'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(_context!).pop();
                  _resetInput();
                },
                child: const Text('Ok'))
          ],
        );
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });

      showInfoDialog(
        _context!,
        title: 'Gagal',
        content: const Text('Terjadi kesalahan teknis, hubungi administrator.'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(_context!).pop();
                _resetInput();
              },
              child: const Text('Ok'))
        ],
      );
    }
  }

// Helper method untuk upload file ke Firebase Storage
  Future<String> _uploadFileToStorage(File file, String category) async {
    try {
      final Reference storageRef = FirebaseStorage.instance.ref().child(
          'uploads/$category/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');

      final UploadTask uploadTask = storageRef.putFile(file);

      // Monitor upload progress (optional)
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        debugPrint(
            'Upload $category progress: ${(progress * 100).toStringAsFixed(2)}%');
      });

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading file $category: $e');
      throw Exception('Gagal mengupload file $category');
    }
  }

// Helper method untuk upload signature ke Firebase Storage
  Future<String> _uploadSignatureToStorage(
      dynamic signatureController, String fileName) async {
    try {
      if (signatureController.isEmpty) {
        return '';
      }

      final Uint8List? data = await signatureController.toPngBytes();
      if (data == null) {
        return '';
      }

      final Reference storageRef = FirebaseStorage.instance.ref().child(
          'signatures/${fileName}_${DateTime.now().millisecondsSinceEpoch}.png');

      final UploadTask uploadTask = storageRef.putData(data);

      // Monitor upload progress (optional)
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        debugPrint(
            'Upload $fileName progress: ${(progress * 100).toStringAsFixed(2)}%');
      });

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading signature $fileName: $e');
      throw Exception('Gagal mengupload tanda tangan');
    }
  }
  // Future<void> _kirimData() async {
  //   if (_loading) {
  //     return;
  //   }

  //   setState(() {
  //     _loading = true;
  //   });

  //   if (jangkaController.isEmpty) {
  //     // Jika namaController kosong, tampilkan pesan kesalahan
  //     _errorJangka = 'Jangka harus dipilih';
  //   } else {
  //     // Reset pesan kesalahan jika namaController terisi
  //     _errorJangka = null;
  //   }

  //   if (txJmlPinjam.text.isEmpty) {
  //     // Jika namaController kosong, tampilkan pesan kesalahan
  //     _errorTextJmlPinjam = 'Nama harus diisi';
  //   } else if (txJmlPinjam.text.length < 5) {
  //     // Jika namaController kosong, tampilkan pesan kesalahan
  //     _errorTextJmlPinjam = 'minimal 5 karakter';
  //   } else {
  //     // Reset pesan kesalahan jika namaController terisi
  //     _errorTextJmlPinjam = null;
  //   }

  //   if (fotoKtpFile == null) {
  //     fotoKtpError = 'Foto KTP harus diupload';
  //   } else {
  //     fotoKtpError = null;
  //   }

  //   if (fotoSelfieFile == null) {
  //     fotoSelfieError = 'Foto Selfie harus diupload';
  //   } else {
  //     fotoSelfieError = null;
  //   }

  //   // Validasi fotobuktipotong
  //   if (fotoBuktiPotongFile == null) {
  //     fotoBuktiPotongError = 'Foto Bukti Potong harus diupload';
  //   } else {
  //     fotoBuktiPotongError = null;
  //   }

  //   // Validasi fotoSlipGaji
  //   if (fotoSlipGajiFile == null) {
  //     fotoSlipGajiError = 'Foto Slip Gaji harus diupload';
  //   } else {
  //     fotoSlipGajiError = null;
  //   }

  //   // Validasi memo
  //   if (isPG) {
  //     fotoMemoError = null;
  //   } else {
  //     if (fotoMemoFile == null) {
  //       fotoMemoError = 'Foto Memo harus diupload';
  //     } else {
  //       fotoMemoError = null;
  //     }
  //   }

  //   if (_signatureController.isEmpty) {
  //     showInfoDialog(_context!,
  //         title: 'Validasi Input',
  //         content: Text('Tanda tangan istri harus diisi.'));
  //     setState(() {
  //       _loading = false;
  //     });
  //     return;
  //   }

  //   if (_signatureControllerSuami.isEmpty) {
  //     showInfoDialog(_context!,
  //         title: 'Validasi Input',
  //         content: Text('Tanda tangan Suami harus diisi.'));
  //     setState(() {
  //       _loading = false;
  //     });
  //     return;
  //   }

  //   var tandaTanganUrl;
  //   if (!_signatureController.isEmpty) {
  //     var data = await _signatureController.toPngBytes();
  //     if (data != null) {
  //       final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
  //           'tanda_tangan_istri_${DateTime.now().millisecondsSinceEpoch}.png');
  //       final UploadTask task = firebaseStorageRef.putData(data);
  //       task.snapshotEvents.listen((TaskSnapshot snapshot) {
  //         double progress = snapshot.bytesTransferred / snapshot.totalBytes;
  //         print('Upload progress: ${(progress * 100).toStringAsFixed(2)}%');
  //       });
  //       final TaskSnapshot snapshot = await task;
  //       final String downloadUrl = await snapshot.ref.getDownloadURL();
  //       var downUrl = await (await task.onComplete).ref.getDownloadURL();
  //       tandaTanganUrl = downUrl.toString();
  //     }
  //   }

  //   var tandaTanganSuamiUrl;
  //   if (!_signatureControllerSuami.isEmpty) {
  //     var data = await _signatureControllerSuami.toPngBytes();
  //     if (data != null) {
  //       StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(
  //           'tanda_tangan_suami_${DateTime.now().millisecondsSinceEpoch}.png');
  //       StorageUploadTask task = firebaseStorageRef.putData(data);
  //       var downUrl = await (await task.onComplete).ref.getDownloadURL();
  //       tandaTanganSuamiUrl = downUrl.toString();
  //     }
  //   }

  //   if (_errorTextJmlPinjam != null ||
  //       _errorJangka != null ||
  //       fotoKtpError != null ||
  //       fotoSelfieError != null ||
  //       fotoBuktiPotongError != null ||
  //       fotoSlipGajiError != null ||
  //       fotoMemoError != null) {
  //     showInfoDialog(_context!,
  //         title: 'Validasi Input',
  //         content: Text(
  //             'Ada kesalahan dalam pengisian form. Silakan periksa kembali.'));

  //     setState(() {
  //       _loading = false;
  //     });
  //   } else {
  //     bool konfirmasi = await confirmDialog(_context!,
  //         title: 'Konfirmasi', content: Text('Input sudah sesuai?'));

  //     if (!konfirmasi) {
  //       setState(() {
  //         _loading = false;
  //       });
  //       return;
  //     }

  //     bool isPinCorrect = await showPinInputModal(_context!) ?? false;

  //     if (!isPinCorrect) {
  //       setState(() {
  //         _loading = false;
  //       });
  //       return; // Hentikan proses jika PIN salah
  //     }

  //     StorageReference firebaseStorageRef;
  //     StorageUploadTask task;
  //     var downUrl;

  //     // foto ktp
  //     firebaseStorageRef =
  //         FirebaseStorage.instance.ref().child(fotoKtpController);
  //     task = firebaseStorageRef.putFile(fotoKtpFile);
  //     downUrl = await (await task.onComplete).ref.getDownloadURL();
  //     fotoKtpController = downUrl.toString();

  //     // foto selfie
  //     firebaseStorageRef =
  //         FirebaseStorage.instance.ref().child(fotoSelfieController);
  //     task = firebaseStorageRef.putFile(fotoSelfieFile);
  //     downUrl = await (await task.onComplete).ref.getDownloadURL();
  //     fotoSelfieController = downUrl.toString();
  //     // print("URL Foto Selfie: $fotoSelfieController");

  //     // foto slipgaji
  //     firebaseStorageRef =
  //         FirebaseStorage.instance.ref().child(fotoSlipGajiController);
  //     task = firebaseStorageRef.putFile(fotoSlipGajiFile);
  //     downUrl = await (await task.onComplete).ref.getDownloadURL();
  //     fotoSlipGajiController = downUrl.toString();
  //     // fotoSlipGajiController = '';

  //     // foto bukti potong
  //     firebaseStorageRef =
  //         FirebaseStorage.instance.ref().child(fotoBuktiPotongController);
  //     task = firebaseStorageRef.putFile(fotoBuktiPotongFile);
  //     downUrl = await (await task.onComplete).ref.getDownloadURL();
  //     fotoBuktiPotongController = downUrl.toString();
  //     // fotoBuktiPotongController = '';

  //     if (isPG == false) {
  //       // foto memo
  //       firebaseStorageRef =
  //           FirebaseStorage.instance.ref().child(fotoMemoController);
  //       task = firebaseStorageRef.putFile(fotoMemoFile);
  //       downUrl = await (await task.onComplete).ref.getDownloadURL();
  //       fotoMemoController = downUrl.toString();

  //       // fotoMemoController = '';
  //     } else {
  //       fotoMemoController = '';
  //     }

  //     String tandaTanganIstriUrl = '';
  //     String tandaTanganSuamiUrl = '';

  //     if (!_signatureController.isEmpty) {
  //       var data = await _signatureController.toPngBytes();
  //       if (data != null) {
  //         StorageReference firebaseStorageRef = FirebaseStorage.instance
  //             .ref()
  //             .child(
  //                 'tanda_tangan_istri_${DateTime.now().millisecondsSinceEpoch}.png');
  //         StorageUploadTask task = firebaseStorageRef.putData(data);
  //         var taskSnapshot = await task.onComplete;
  //         tandaTanganIstriUrl = await taskSnapshot.ref.getDownloadURL();
  //       }
  //     }

  //     if (!_signatureControllerSuami.isEmpty) {
  //       var datasuami = await _signatureControllerSuami.toPngBytes();
  //       if (datasuami != null) {
  //         StorageReference firebaseStorageRef = FirebaseStorage.instance
  //             .ref()
  //             .child(
  //                 'tanda_tangan_suami_${DateTime.now().millisecondsSinceEpoch}.png');
  //         StorageUploadTask task = firebaseStorageRef.putData(datasuami);
  //         var taskSnapshot = await task.onComplete;
  //         tandaTanganSuamiUrl = await taskSnapshot.ref.getDownloadURL();
  //       }
  //     }

  //     var dataHttp = {
  //       'tempo_bln': jangkaController,
  //       'jml_pinjam': txJmlPinjam.text,
  //       'no_ang': nak,
  //       'foto_ktp': fotoKtpController,
  //       'foto_selfie': fotoSelfieController,
  //       'foto_bukti_potong': fotoBuktiPotongController,
  //       'foto_slip_gaji': fotoSlipGajiController,
  //       'foto_memo': fotoMemoController,
  //       'ttd_istri': tandaTanganIstriUrl,
  //       'ttd_suami': tandaTanganSuamiUrl,
  //       // 'angsuran': txJmlAngsuran.text,
  //     };

  //     String url = APIConstant.urlBase +
  //         APIConstant.serverApi +
  //         "pinjaman/add_pinj_reguler";

  //     try {
  //       var response = await executeRequest(url,
  //           body: dataHttp, method: RequestMethod.POST);

  //       if (response.statusCode == 200) {
  //         Future.delayed(Duration(seconds: 1), () {
  //           setState(() {
  //             _loading = false;
  //           });

  //           var responseData = jsonDecode(response.body);

  //           debugPrint(responseData['status'].toString());

  //           if (!responseData['status']) {
  //             showInfoDialog(
  //               _context,
  //               title: 'Error',
  //               content: Text(responseData['msg']),
  //               actions: [
  //                 TextButton(
  //                     onPressed: () {
  //                       Navigator.of(_context).pop();
  //                     },
  //                     child: Text('Ok'))
  //               ],
  //             );

  //             // return;
  //           } else {
  //             showInfoDialog(
  //               _context,
  //               title: 'Sukses',
  //               content:
  //                   Text('Pengajuan berhasil dikirim dan segera kami proses.'),
  //               actions: [
  //                 TextButton(
  //                     onPressed: () {
  //                       _resetInput();

  //                       Navigator.of(_context).pop();
  //                       Navigator.of(_context).pop();
  //                     },
  //                     child: Text('Ok'))
  //               ],
  //             );
  //           }
  //         });
  //       } else if (response.statusCode == 401) {
  //         Navigator.of(_context).pushReplacementNamed('/LoginScreen');
  //       } else {
  //         setState(() {
  //           _loading = false;
  //         });

  //         showInfoDialog(
  //           _context,
  //           title: 'Gagal',
  //           content: Text('Terjadi kesalahan teknis, hubungi administrator.'),
  //           actions: [
  //             TextButton(
  //                 onPressed: () {
  //                   Navigator.of(_context).pop();

  //                   _resetInput();
  //                 },
  //                 child: Text('Ok'))
  //           ],
  //         );
  //       }
  //     } catch (e) {
  //       setState(() {
  //         _loading = false;
  //       });

  //       showInfoDialog(
  //         _context,
  //         title: 'Gagal',
  //         content: Text('Terjadi kesalahan teknis, hubungi administrator.'),
  //         actions: [
  //           TextButton(
  //               onPressed: () {
  //                 Navigator.of(_context).pop();

  //                 _resetInput();
  //               },
  //               child: Text('Ok'))
  //         ],
  //       );
  //     }
  //   }
  // }

  // Future<void> _saveSignature() async {
  //   try {
  //     // Pastikan tanda tangan tidak kosong
  //     if (_signatureController.isEmpty) {
  //       setState(() {
  //         _errorTandaTanganIstri = true;
  //       });
  //       return;
  //     }

  //     setState(() {
  //       _errorTandaTanganIstri = false;
  //     });

  //     // Mengambil data tanda tangan sebagai gambar PNG
  //     var signatureData = await _signatureController.toPngBytes();
  //     if (signatureData != null) {
  //       // Unggah ke Firebase Storage
  //       StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(
  //           'tanda_tangan_istri_${DateTime.now().millisecondsSinceEpoch}.png');

  //       StorageUploadTask uploadTask =
  //           firebaseStorageRef.putData(signatureData);
  //       var taskSnapshot = await uploadTask.onComplete;

  //       // Ambil URL dari gambar yang telah diunggah
  //       var tandaTanganUrl = await taskSnapshot.ref.getDownloadURL();

  //       // Lakukan sesuatu dengan URL tanda tangan, misalnya menyimpan URL ini di variabel
  //       print('Tanda tangan berhasil diunggah: $tandaTanganUrl');

  //       // Tampilkan notifikasi sukses
  //       showInfoDialog(_context,
  //           title: 'Sukses', content: Text('Tanda tangan berhasil disimpan.'));
  //     }
  //   } catch (e) {
  //     // Tangani error jika terjadi kegagalan
  //     showInfoDialog(_context,
  //         title: 'Error',
  //         content: Text('Gagal menyimpan tanda tangan, silakan coba lagi.'));
  //   }
  // }

  // Future<void> _saveSignatureSuami() async {
  //   try {
  //     // Pastikan tanda tangan tidak kosong
  //     if (_signatureControllerSuami.isEmpty) {
  //       setState(() {
  //         _errorTandaTanganSuami = true;
  //       });
  //       return;
  //     }

  //     setState(() {
  //       _errorTandaTanganSuami = false;
  //     });

  //     // Mengambil data tanda tangan sebagai gambar PNG
  //     var signatureData = await _signatureControllerSuami.toPngBytes();
  //     if (signatureData != null) {
  //       // Unggah ke Firebase Storage
  //       StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(
  //           'tanda_tangan_suami_${DateTime.now().millisecondsSinceEpoch}.png');

  //       StorageUploadTask uploadTask =
  //           firebaseStorageRef.putData(signatureData);
  //       var taskSnapshot = await uploadTask.onComplete;

  //       // Ambil URL dari gambar yang telah diunggah
  //       var tandaTanganSuamiUrl = await taskSnapshot.ref.getDownloadURL();

  //       // Lakukan sesuatu dengan URL tanda tangan, misalnya menyimpan URL ini di variabel
  //       print('Tanda tangan berhasil diunggah: $tandaTanganSuamiUrl');

  //       // Tampilkan notifikasi sukses
  //       showInfoDialog(_context,
  //           title: 'Sukses', content: Text('Tanda tangan berhasil disimpan.'));
  //     }
  //   } catch (e) {
  //     // Tangani error jika terjadi kegagalan
  //     showInfoDialog(_context,
  //         title: 'Error',
  //         content: Text('Gagal menyimpan tanda tangan, silakan coba lagi.'));
  //   }
  // }
  Future<void> _saveSignature() async {
    try {
      // Pastikan tanda tangan tidak kosong
      if (_signatureController.isEmpty) {
        setState(() {
          _errorTandaTanganIstri = true;
        });
        return;
      }

      setState(() {
        _errorTandaTanganIstri = false;
      });

      // Mengambil data tanda tangan sebagai gambar PNG
      Uint8List? signatureData = await _signatureController.toPngBytes();
      if (signatureData != null) {
        // Unggah ke Firebase Storage dengan API yang baru
        Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
            'signatures/tanda_tangan_istri_${DateTime.now().millisecondsSinceEpoch}.png');

        UploadTask uploadTask = firebaseStorageRef.putData(signatureData);

        // Monitor upload progress (opsional)
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          double progress = snapshot.bytesTransferred / snapshot.totalBytes;
          debugPrint(
              'Upload tanda tangan istri progress: ${(progress * 100).toStringAsFixed(2)}%');
        });

        TaskSnapshot taskSnapshot = await uploadTask;

        // Ambil URL dari gambar yang telah diunggah
        String tandaTanganUrl = await taskSnapshot.ref.getDownloadURL();

        // Lakukan sesuatu dengan URL tanda tangan, misalnya menyimpan URL ini di variabel
        debugPrint('Tanda tangan istri berhasil diunggah: $tandaTanganUrl');

        // Tampilkan notifikasi sukses
        showInfoDialog(_context!,
            title: 'Sukses',
            content: const Text('Tanda tangan istri berhasil disimpan.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(_context!).pop(),
                  child: const Text('OK'))
            ]);
      }
    } catch (e) {
      // Tangani error jika terjadi kegagalan
      debugPrint('Error saving signature istri: $e');
      showInfoDialog(_context!,
          title: 'Error',
          content: const Text(
              'Gagal menyimpan tanda tangan istri, silakan coba lagi.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(_context!).pop(),
                child: const Text('OK'))
          ]);
    }
  }

  Future<void> _saveSignatureSuami() async {
    try {
      // Pastikan tanda tangan tidak kosong
      if (_signatureControllerSuami.isEmpty) {
        setState(() {
          _errorTandaTanganSuami = true;
        });
        return;
      }

      setState(() {
        _errorTandaTanganSuami = false;
      });

      // Mengambil data tanda tangan sebagai gambar PNG
      Uint8List? signatureData = await _signatureControllerSuami.toPngBytes();
      if (signatureData != null) {
        // Unggah ke Firebase Storage dengan API yang baru
        Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
            'signatures/tanda_tangan_suami_${DateTime.now().millisecondsSinceEpoch}.png');

        UploadTask uploadTask = firebaseStorageRef.putData(signatureData);

        // Monitor upload progress (opsional)
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          double progress = snapshot.bytesTransferred / snapshot.totalBytes;
          debugPrint(
              'Upload tanda tangan suami progress: ${(progress * 100).toStringAsFixed(2)}%');
        });

        TaskSnapshot taskSnapshot = await uploadTask;

        // Ambil URL dari gambar yang telah diunggah
        String tandaTanganSuamiUrl = await taskSnapshot.ref.getDownloadURL();

        // Lakukan sesuatu dengan URL tanda tangan, misalnya menyimpan URL ini di variabel
        debugPrint(
            'Tanda tangan suami berhasil diunggah: $tandaTanganSuamiUrl');

        // Tampilkan notifikasi sukses
        showInfoDialog(_context!,
            title: 'Sukses',
            content: const Text('Tanda tangan suami berhasil disimpan.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(_context!).pop(),
                  child: const Text('OK'))
            ]);
      }
    } catch (e) {
      // Tangani error jika terjadi kegagalan
      debugPrint('Error saving signature suami: $e');
      showInfoDialog(_context!,
          title: 'Error',
          content: const Text(
              'Gagal menyimpan tanda tangan suami, silakan coba lagi.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(_context!).pop(),
                child: const Text('OK'))
          ]);
    }
  }

// Helper method untuk upload signature (bisa digunakan untuk mengurangi duplikasi kode)
  Future<String?> _uploadSignatureToFirebase(
      dynamic signatureController, String fileName) async {
    try {
      if (signatureController.isEmpty) {
        return null;
      }

      Uint8List? signatureData = await signatureController.toPngBytes();
      if (signatureData == null) {
        return null;
      }

      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
          'signatures/${fileName}_${DateTime.now().millisecondsSinceEpoch}.png');

      UploadTask uploadTask = firebaseStorageRef.putData(signatureData);

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        debugPrint(
            'Upload $fileName progress: ${(progress * 100).toStringAsFixed(2)}%');
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      debugPrint('$fileName berhasil diunggah: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading $fileName: $e');
      return null;
    }
  }

  void _resetInput() {
    jangkaController = '';
    _errorJangka = null;

    txJmlPinjam.text = "";
    formattedJmlPinjam = 'Rp. 0';
    _errorTextJmlPinjam = null;

    txJmlAngsuran.text = "0";
    formattedAngsuran = 'Rp. 0';

    fotoKtpFile = null;
    fotoSelfieFile = null;
    fotoBuktiPotongFile = null;
    fotoSlipGajiFile = null;
    fotoMemoFile = null;

    fotoKtpController = '';
    fotoSelfieController = '';
    fotoBuktiPotongController = '';
    fotoSlipGajiController = '';
    fotoMemoController = '';

    fotoKtpError = '';
    fotoSelfieError = '';
    fotoBuktiPotongError = '';
    fotoSlipGajiError = '';
    fotoMemoError = '';

    setState(() {});
  }

  getProfile() async {
    String url = APIConstant.urlBase + APIConstant.serverApi + "profile";

    try {
      var response = await executeRequest(
        url,
      );

      var responseData = json.decode(response.body);

      nak = responseData['akun']['nak'];
      // String kd_prsh = "P01";
      String kd_prsh = responseData['ang']['kd_prsh'];

      if (kd_prsh == 'P01') {
        isPG = false;
      }

      debugPrint('nak=' + nak!);

      if (mounted) {
        setState(() {});
      }
    } catch (e) {}
  }

  startState() async {
    final prefs = await SharedPreferences.getInstance();

    username = prefs.getString('LastUser') ?? '';

    // await Permission.storage.isGranted;
    // await Permission.photos.status.isGranted;
    var permission = await Permission.storage.request();

    debugPrint(permission.toString());

    getProfile();

    getTenor();

    // namaController.text = "John Doe";
    // emailController.text = "john.doe@example.com";
    // tglLahirController.text = "1990-01-01";
    // tempatLahirController.text = "City";
    // pendidikanController.text = "Bachelor's Degree";
    // noBadgeController.text = "123456";
    // statusPegawaiController.text = "Active";
    // jabatanController.text = "Software Engineer";
    // departemenController.text = "Engineering";
    // perusahaanController.text = "ABC Company";
    // hpController.text = "1234567890";
    // alamatController.text = "123 Main St, City, Country";
    // byrSimpPokokController.text = 'Februari';
    // byrSimpWajibController = true;
  }

  @override
  void initState() {
    super.initState();

    startState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return PlatformScaffold(
      appBar: AppBar(
        title: Text('Pengajuan Pinjaman Reguler'),
        backgroundColor: ColorPalette.warnaCorporate,
      ),
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    children: [
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Row(
                        children: [
                          Text('Simulasi Angsuran'),
                        ],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Jumlah Pinjam : ",
                          icon: Icon(FontAwesomeIcons.moneyBill,
                              color: Colors.blue),
                          errorText: _errorTextJmlPinjam,
                          counterText: formattedJmlPinjam,
                        ),
                        keyboardType: TextInputType.number,
                        controller: txJmlPinjam,
                        onChanged: (value) {
                          formatJmlPinjam(value);
                        },
                      ),
                      DropdownButtonFormField(
                        value: jangkaController,
                        onChanged: (value) {
                          setState(() {
                            jangkaController = value;
                          });

                          if (value != '') {
                            getAngsuran();
                          }
                        },
                        items: listTenor,
                        decoration: InputDecoration(
                          labelText: 'Jangka Waktu',
                          icon: Icon(Icons.calendar_month, color: Colors.blue),
                          errorText: _errorJangka,
                        ),
                      ),
                      TextFormField(
                        controller: txJmlAngsuran,
                        decoration: InputDecoration(
                          labelText: "Jumlah Angsuran Per Bulan : ",
                          icon: Icon(FontAwesomeIcons.moneyBill,
                              color: Colors.blue),
                          // errorText: _errorTextJmlPinjam,
                          counterText: formattedAngsuran,
                        ),
                        readOnly: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "No Rekening Penerima : ",
                          icon: Icon(FontAwesomeIcons.moneyCheck,
                              color: Colors.blue),
                          errorText: _errorTextNoRek,
                          counterText: "No Rekening Harus BNI",
                          counterStyle: TextStyle(
                            color: Colors.red, // warna merah
                            fontWeight:
                                FontWeight.bold, // opsional biar lebih tegas
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        controller: txNoRek,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (isPG == false)
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Text('Foto Memo Perusahaan:'),
                              Row(
                                children: [
                                  tombolIjo(
                                    onPressed: () async {
                                      const url =
                                          'http://35.197.136.216/asset/MEMO_PINJAMAN_ONLINE.pdf'; // ganti dengan URL file Anda
                                      if (await canLaunchUrl(Uri.parse(url))) {
                                        await launchUrl(
                                          Uri.parse(url),
                                          mode: LaunchMode.externalApplication,
                                        );
                                      } else {
                                        throw 'Tidak bisa membuka $url';
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.download,
                                          color: Colors.white,
                                          size: 15.0,
                                        ),
                                        SizedBox(width: 5),
                                        Text('Download File'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  tombol(
                                    onPressed: () {
                                      _optionsDialogBox(_context!, 'fotomemo');
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.upload,
                                          color: Colors.white,
                                          size: 15.0,
                                        ),
                                        SizedBox(width: 5),
                                        Text('Upload Foto'),
                                      ],
                                    ),
                                  ),
                                  // jarak antara tombol
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: fotoMemoFile != null
                                    ? Image.file(fotoMemoFile!)
                                    : Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100]),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              fotoMemoError ??
                                                  'silahkan upload foto',
                                              style: TextStyle(
                                                color: fotoMemoError != ''
                                                    ? Colors.red
                                                    : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text('Foto Slip Gaji:'),
                            tombol(
                              // backgroundColor: Colors.green,
                              onPressed: () {
                                _optionsDialogBox(_context!, 'fotoslipgaji');
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.upload,
                                    color: Colors.white,
                                    size: 15.0,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Upload Foto'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: fotoSlipGajiFile != null
                                  ? Image.file(fotoSlipGajiFile!)
                                  : Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            fotoSlipGajiError ??
                                                'silahkan upload foto',
                                            style: TextStyle(
                                                color: fotoSlipGajiError != ''
                                                    ? Colors.red
                                                    : Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text('Foto Bukti Potong:'),
                            tombol(
                              // backgroundColor: Colors.green,
                              onPressed: () {
                                _optionsDialogBox(_context!, 'fotobuktipotong');
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.upload,
                                    color: Colors.white,
                                    size: 15.0,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Upload Foto'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: fotoBuktiPotongFile != null
                                  ? Image.file(fotoBuktiPotongFile!)
                                  : Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            fotoBuktiPotongError ??
                                                'silahkan upload foto',
                                            style: TextStyle(
                                                color:
                                                    fotoBuktiPotongError != ''
                                                        ? Colors.red
                                                        : Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text('Foto KTP Anda:'),
                            tombol(
                              // backgroundColor: Colors.green,
                              onPressed: () {
                                _optionsDialogBox(_context!, 'fotoktp');
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.upload,
                                    color: Colors.white,
                                    size: 15.0,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Upload Foto'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: fotoKtpFile != null
                                  ? Image.file(fotoKtpFile!)
                                  : Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            fotoKtpError ??
                                                'silahkan upload foto',
                                            style: TextStyle(
                                                color: fotoKtpError != ''
                                                    ? Colors.red
                                                    : Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text('Foto Selfie dengan KTP Anda:'),
                            tombol(
                              // backgroundColor: Colors.green,
                              onPressed: () {
                                _optionsDialogBoxnew(_context!, 'fotoselfie');
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.upload,
                                    color: Colors.white,
                                    size: 15.0,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Upload Foto'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: fotoSelfieFile != null
                                  ? Image.file(fotoSelfieFile!)
                                  : Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            fotoSelfieError ??
                                                'silahkan upload foto',
                                            style: TextStyle(
                                                color: fotoSelfieError != ''
                                                    ? Colors.red
                                                    : Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Text('Tanda Tangan Istri:'),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: _errorTandaTanganIstri
                                  ? Colors.red
                                  : Colors.grey),
                        ),
                        height: 150,
                        child: Signature(
                          controller: _signatureController,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      if (_errorTandaTanganIstri)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            'Tanda tangan diperlukan',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _signatureController.clear();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Clear'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _saveSignature();
                            },
                            child: Text('Simpan Tanda Tangan'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text('Tanda Tangan Suami:'),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: _errorTandaTanganSuami
                                  ? Colors.red
                                  : Colors.grey),
                        ),
                        height: 150,
                        child: Signature(
                          controller: _signatureControllerSuami,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      if (_errorTandaTanganSuami)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            'Tanda tangan diperlukan',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _signatureControllerSuami.clear();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Clear'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _saveSignatureSuami(); // Fungsi untuk menyimpan tanda tangan suami
                            },
                            child: Text('Simpan Tanda Tangan'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: tombol(
                            child: Text('Ajukan Pinjaman'),
                            onPressed: () {
                              _kirimData();
                              // _resetInput();
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_loading) loadingView(),
        ],
      ),
    );
  }
}
