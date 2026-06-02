String kodeVoucherGlobal = '';

class VoucherModel {
  final String kodeVoucher;
  final String nak;
  final int idTipe;
  final String batch;
  final String keterangan;
  final int splittable;
  final double nominal;
  final double nominalTerpakai;
  final String validFrom;
  final String validTo;
  final int idStatus;
  final String insertedDate;
  final String insertedFrom;
  final String insertedBy;
  final String tipe;
  final String voucherstatus;

  const VoucherModel({
    required this.kodeVoucher,
    required this.nak,
    required this.idTipe,
    required this.batch,
    required this.keterangan,
    required this.splittable,
    required this.nominal,
    required this.nominalTerpakai,
    required this.validFrom,
    required this.validTo,
    required this.idStatus,
    required this.insertedDate,
    required this.insertedFrom,
    required this.insertedBy,
    required this.tipe,
    required this.voucherstatus,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      kodeVoucher: json['kode_voucher']?.toString() ?? '',
      nak: json['nak']?.toString() ?? '',
      idTipe: int.tryParse(json['id_tipe']?.toString() ?? '') ?? 0,
      batch: json['batch']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? '',
      splittable: int.tryParse(json['splittable']?.toString() ?? '') ?? 0,
      nominal: double.tryParse(json['nominal']?.toString() ?? '') ?? 0.0,
      nominalTerpakai:
          double.tryParse(json['nominal_terpakai']?.toString() ?? '') ?? 0.0,
      validFrom: json['valid_from']?.toString() ?? '',
      validTo: json['valid_to']?.toString() ?? '',
      idStatus: int.tryParse(json['id_status']?.toString() ?? '') ?? 0,
      insertedDate: json['Inserted_date']?.toString() ??
          json['inserted_date']?.toString() ??
          '',
      insertedFrom: json['Inserted_from']?.toString() ??
          json['inserted_from']?.toString() ??
          '',
      insertedBy: json['Inserted_by']?.toString() ??
          json['inserted_by']?.toString() ??
          '',
      tipe: json['tipe']?.toString() ?? '',
      voucherstatus: json['status']?.toString() ?? '',
    );
  }
}

class VoucherLogModel {
  final String kodeVoucher;
  final String nak;
  final int idTipe;
  final double nilaiTransaksi;
  final String insertedDate;
  final String insertedFrom;
  final String insertedBy;
  final int id;
  final String remark;
  final String tipe;
  final String nmPrsh;
  final String statusCancel;
  final String nmAng;

  const VoucherLogModel({
    required this.kodeVoucher,
    required this.nak,
    required this.idTipe,
    required this.nilaiTransaksi,
    required this.insertedDate,
    required this.insertedFrom,
    required this.insertedBy,
    required this.id,
    required this.remark,
    required this.nmPrsh,
    required this.statusCancel,
    required this.nmAng,
    required this.tipe,
  });

  factory VoucherLogModel.fromJson(Map<String, dynamic> json) {
    return VoucherLogModel(
      kodeVoucher: json['kode_voucher']?.toString() ?? '',
      nak: json['nak']?.toString() ?? '',
      tipe: json['tipe']?.toString() ?? '',
      remark: json['remark']?.toString() ?? '',
      idTipe: int.tryParse(json['id_tipe']?.toString() ?? '') ?? 0,
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      nilaiTransaksi:
          double.tryParse(json['nilai_transaksi']?.toString() ?? '') ?? 0.0,
      insertedDate: json['Inserted_date']?.toString() ??
          json['inserted_date']?.toString() ??
          '',
      insertedFrom: json['Inserted_from']?.toString() ??
          json['inserted_from']?.toString() ??
          '',
      insertedBy: json['Inserted_by']?.toString() ??
          json['inserted_by']?.toString() ??
          '',
      nmPrsh: json['nm_prsh']?.toString() ?? '',
      statusCancel: json['status_cancel']?.toString() ?? '',
      nmAng: json['nm_ang']?.toString() ?? '',
    );
  }
}

class CouponModel {
  final String kodeCoupon;
  final int idTipe;
  final double nominal;
  final double nominalTerpakai;
  final String insertedDate;
  final String insertedFrom;
  final String insertedBy;
  final String keterangan;
  final String tipe;
  final String validFrom;
  final String validTo;
  final int idStatus;
  final String voucherstatus;
  final String redeemFrom;
  final String redeemDate;
  final int splittable;

  const CouponModel({
    required this.kodeCoupon,
    required this.idTipe,
    required this.nominal,
    required this.nominalTerpakai,
    required this.insertedDate,
    required this.insertedFrom,
    required this.insertedBy,
    required this.keterangan,
    required this.tipe,
    required this.validFrom,
    required this.validTo,
    required this.idStatus,
    required this.voucherstatus,
    required this.redeemFrom,
    required this.redeemDate,
    required this.splittable,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      kodeCoupon: json['kode_coupon']?.toString() ?? '',
      idTipe: int.tryParse(json['id_tipe']?.toString() ?? '') ?? 0,
      splittable: int.tryParse(json['splittable']?.toString() ??
              json['splitable']?.toString() ??
              '') ??
          0,
      nominal: double.tryParse(json['nominal']?.toString() ?? '') ?? 0.0,
      nominalTerpakai:
          double.tryParse(json['nominal_terpakai']?.toString() ?? '') ?? 0.0,
      insertedDate: json['Inserted_date']?.toString() ??
          json['inserted_date']?.toString() ??
          '',
      insertedFrom: json['Inserted_from']?.toString() ??
          json['inserted_from']?.toString() ??
          '',
      insertedBy: json['Inserted_by']?.toString() ??
          json['inserted_by']?.toString() ??
          '',
      keterangan: json['keterangan']?.toString() ?? '',
      tipe: json['tipe']?.toString() ?? '',
      validFrom: json['valid_from']?.toString() ?? '',
      validTo: json['valid_to']?.toString() ?? '',
      voucherstatus: json['status']?.toString() ?? '',
      redeemFrom: json['redeem_from']?.toString() ?? '',
      redeemDate: json['redeem_date']?.toString() ?? '',
      idStatus: int.tryParse(json['id_status']?.toString() ?? '') ?? 0,
    );
  }
}

class CouponLogModel {
  final String kodeCoupon;
  final String tipe;
  final int idTipe;
  final double nilaiTransaksi;
  final String insertedDate;
  final String insertedFrom;
  final String insertedBy;
  final String remark;
  final String statusCancel;

  const CouponLogModel({
    required this.kodeCoupon,
    required this.idTipe,
    required this.nilaiTransaksi,
    required this.insertedDate,
    required this.insertedFrom,
    required this.insertedBy,
    required this.remark,
    required this.tipe,
    required this.statusCancel,
  });

  factory CouponLogModel.fromJson(Map<String, dynamic> json) {
    return CouponLogModel(
      kodeCoupon: json['kode_coupon']?.toString() ?? '',
      idTipe: int.tryParse(json['id_tipe']?.toString() ?? '') ?? 0,
      nilaiTransaksi:
          double.tryParse(json['nilai_transaksi']?.toString() ?? '') ?? 0.0,
      insertedDate: json['Inserted_date']?.toString() ??
          json['inserted_date']?.toString() ??
          '',
      insertedFrom: json['Inserted_from']?.toString() ??
          json['inserted_from']?.toString() ??
          '',
      insertedBy: json['Inserted_by']?.toString() ??
          json['inserted_by']?.toString() ??
          '',
      remark: json['remark']?.toString() ?? '',
      tipe: json['tipe']?.toString() ?? '',
      statusCancel: json['status_cancel']?.toString() ?? '',
    );
  }
}
