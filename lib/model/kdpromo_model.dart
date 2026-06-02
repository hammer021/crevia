class KdPromoModel {
  final String kodePromo;
  final int idTipe;
  final String batch;
  final String keterangan;
  final double nominal;
  final double maxNominal;
  final double minNominal;
  final double prosentase;
  final double sisaNominal;
  final String validFrom;
  final String validTo;
  final int idStatus;
  final String insertedDate;
  final String insertedBy;
  final String voucherStatus;

  const KdPromoModel({
    required this.kodePromo,
    required this.idTipe,
    required this.batch,
    required this.keterangan,
    required this.nominal,
    required this.maxNominal,
    required this.minNominal,
    required this.prosentase,
    required this.sisaNominal,
    required this.validFrom,
    required this.validTo,
    required this.idStatus,
    required this.insertedDate,
    required this.insertedBy,
    required this.voucherStatus,
  });

  factory KdPromoModel.fromJson(Map<String, dynamic> json) {
    return KdPromoModel(
      kodePromo: json['kode_promo']?.toString() ?? '',
      idTipe: int.tryParse(json['id_tipe']?.toString() ?? '0') ?? 0,
      batch: json['batch']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? '',
      nominal: double.tryParse(json['nominal']?.toString() ?? '0') ?? 0,
      prosentase: double.tryParse(json['prosentase']?.toString() ?? '0') ?? 0,
      sisaNominal:
          double.tryParse(json['sisa_nominal']?.toString() ?? '0') ?? 0,
      minNominal: double.tryParse(json['min_nominal']?.toString() ?? '0') ?? 0,
      maxNominal: double.tryParse(json['max_nominal']?.toString() ?? '0') ?? 0,
      validFrom: json['valid_from']?.toString() ?? '',
      validTo: json['valid_to']?.toString() ?? '',
      idStatus: int.tryParse(json['id_status']?.toString() ?? '0') ?? 0,
      insertedDate: json['insert_date']?.toString() ?? '',
      insertedBy: json['insert_by']?.toString() ?? '',
      voucherStatus: json['status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode_promo': kodePromo,
      'id_tipe': idTipe,
      'batch': batch,
      'keterangan': keterangan,
      'nominal': nominal,
      'prosentase': prosentase,
      'sisa_nominal': sisaNominal,
      'min_nominal': minNominal,
      'max_nominal': maxNominal,
      'valid_from': validFrom,
      'valid_to': validTo,
      'id_status': idStatus,
      'insert_date': insertedDate,
      'insert_by': insertedBy,
      'status': voucherStatus,
    };
  }
}
