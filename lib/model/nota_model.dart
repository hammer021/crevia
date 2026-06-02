// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:flutter/material.dart';

class KreditModel {
  final String id;
  final String noAng;
  final double nominal;
  final String cicilan;
  final String noTransaksi;
  final String usedDate;
  final String username;
  final String firstName;
  final String lastName;

  const KreditModel({
    required this.id,
    required this.noAng,
    required this.nominal,
    required this.cicilan,
    required this.noTransaksi,
    required this.usedDate,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  factory KreditModel.fromJson(Map<String, dynamic> json) {
    return KreditModel(
      id: json['id']?.toString() ?? '',
      noAng: json['no_ang']?.toString() ?? '',
      nominal: double.tryParse(json['nominal']?.toString() ?? '0') ?? 0,
      cicilan: json['cicilan']?.toString() ?? '',
      noTransaksi: json['notransaksi']?.toString() ?? '',
      usedDate: json['useddate']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
    );
  }
}

class NotaModel {
  final String id;
  final String noAng;
  final String tanggal;
  final String noNota;
  final double nominal;
  final String bukti;
  final String status;
  final String keterangan;
  final String updatedOn;
  final String periodeKlaim;
  final String kodeStatus;

  const NotaModel({
    required this.id,
    required this.noAng,
    required this.tanggal,
    required this.noNota,
    required this.nominal,
    required this.bukti,
    required this.status,
    required this.keterangan,
    required this.updatedOn,
    required this.periodeKlaim,
    required this.kodeStatus,
  });

  factory NotaModel.fromJson(Map<String, dynamic> json) {
    return NotaModel(
      id: json['id']?.toString() ?? '',
      noAng: json['no_ang']?.toString() ?? '',
      tanggal: json['tanggal']?.toString() ?? '',
      noNota: json['no_nota']?.toString() ?? '',
      nominal: double.tryParse(json['nominal']?.toString() ?? '0') ?? 0,
      bukti: json['bukti']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? '',
      updatedOn: json['updatedon']?.toString() ?? '',
      periodeKlaim: json['periode_klaim']?.toString() ?? '',
      kodeStatus: json['kode_status']?.toString() ?? '',
    );
  }
}

class NotaChartModel {
  final String id;
  final String kodeStatus;
  final String status;
  final double qty;
  final Color color;

  const NotaChartModel({
    required this.id,
    required this.kodeStatus,
    required this.status,
    required this.qty,
    required this.color,
  });

  factory NotaChartModel.fromJson(Map<String, dynamic> json) {
    final kode = json['kode_status']?.toString() ?? '';
    Color warna = Colors.blue;

    switch (kode.toLowerCase()) {
      case 'submit':
        // warna = charts.MaterialPalette.yellow.shadeDefault;
        break;
      case 'proses':
        // warna = charts.MaterialPalette.yellow.shadeDefault;
        break;
      case 'manual':
        warna = Colors.orange;
        break;
      case 'terverifikasi':
        warna = Colors.green;
        break;
      case 'decline':
        warna = Colors.red;
        break;
      default:
        warna = Colors.blue;
    }

    return NotaChartModel(
      id: json['id']?.toString() ?? '',
      kodeStatus: kode,
      status: json['status']?.toString() ?? '',
      qty: double.tryParse(json['qty']?.toString() ?? '0') ?? 0,
      color: warna,
    );
  }
}
