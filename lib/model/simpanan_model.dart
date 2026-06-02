class SimpananAngModel {
  final String noSimpan;
  final String tglSimpan;
  final int noAng;
  final String noPeg;
  final String nmAng;
  final String nmPrsh;
  final String nmJnsSimpanan;
  final String nmJnsTransaksi;
  final String kreditDebet;
  final String plus;
  final double saldo;
  final double jumlah;
  final String updatedOn;

  SimpananAngModel({
    this.noSimpan = '',
    this.plus = '',
    this.tglSimpan = '',
    this.noAng = 0,
    this.noPeg = '',
    this.saldo = 0,
    this.nmAng = '',
    this.nmPrsh = '',
    this.nmJnsSimpanan = '',
    this.nmJnsTransaksi = '',
    this.kreditDebet = '',
    this.jumlah = 0,
    this.updatedOn = '',
  });

  factory SimpananAngModel.fromJson(Map<String, dynamic> json) {
    return SimpananAngModel(
      noSimpan: json['no_simpan']?.toString() ?? '',
      tglSimpan: json['tgl_simpan']?.toString() ?? '',
      noAng: json['no_ang'] == null
          ? 0
          : int.tryParse(json['no_ang'].toString()) ?? 0,
      noPeg: json['no_peg']?.toString() ?? '',
      nmAng: json['nm_ang']?.toString() ?? '',
      nmPrsh: json['nm_prsh']?.toString() ?? '',
      nmJnsSimpanan: json['nm_jns_simpanan']?.toString() ?? '',
      nmJnsTransaksi: json['nm_jns_transaksi']?.toString() ?? '',
      kreditDebet: json['kredit_debet']?.toString() ?? '',
      plus: json['kredit_debet']?.toString() == 'K' ? '+' : '-',
      jumlah: json['jumlah'] == null
          ? 0
          : double.tryParse(json['jumlah'].toString()) ?? 0,
      saldo: json['saldo'] == null
          ? 0
          : double.tryParse(json['saldo'].toString()) ?? 0,
      updatedOn: json['tgl_update']?.toString() ?? '',
    );
  }
}

class Simpanan2Model {
  final int id;
  final String noSs2;
  final int noAng;
  final String noSimpan;
  final String tglSimpan;
  final double jmlSimpanan;
  final int tempoBln;
  final double margin;
  final double jmlMargin;
  final String tglJt;
  final String status;
  final String tglUpdate;
  final double jmlDebet;
  final double jmlDenda;

  Simpanan2Model({
    this.id = 0,
    this.noSs2 = '',
    this.noAng = 0,
    this.noSimpan = '',
    this.tglSimpan = '',
    this.jmlSimpanan = 0,
    this.tempoBln = 0,
    this.margin = 0,
    this.jmlMargin = 0,
    this.tglJt = '',
    this.status = '',
    this.tglUpdate = '',
    this.jmlDebet = 0,
    this.jmlDenda = 0,
  });

  factory Simpanan2Model.fromJson(Map<String, dynamic> json) {
    return Simpanan2Model(
      id: json['id'] == null ? 0 : int.tryParse(json['id'].toString()) ?? 0,
      noSs2: json['no_ss2']?.toString() ?? '',
      noAng: json['no_ang'] == null
          ? 0
          : int.tryParse(json['no_ang'].toString()) ?? 0,
      noSimpan: json['no_simpan']?.toString() ?? '',
      tglSimpan: json['tgl_simpan']?.toString() ?? '',
      jmlSimpanan: json['jml_simpanan'] == null
          ? 0
          : double.tryParse(json['jml_simpanan'].toString()) ?? 0,
      jmlDebet: json['jml_debet'] == null
          ? 0
          : double.tryParse(json['jml_debet'].toString()) ?? 0,
      jmlDenda: json['jml_denda'] == null
          ? 0
          : double.tryParse(json['jml_denda'].toString()) ?? 0,
      tempoBln: json['tempo_bln'] == null
          ? 0
          : int.tryParse(json['tempo_bln'].toString()) ?? 0,
      margin: json['margin'] == null
          ? 0
          : double.tryParse(json['margin'].toString()) ?? 0,
      jmlMargin: json['jml_margin'] == null
          ? 0
          : double.tryParse(json['jml_margin'].toString()) ?? 0,
      tglJt: json['tgl_jt']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      tglUpdate: json['tgl_update']?.toString() ?? '',
    );
  }
}

class InspiraModel {
  final int id;
  final String noSertifikatInspira;
  final int noAng;
  final String noSimpan;
  final String tglSimpan;
  final double jmlSimpanan;
  final int tempoBln;
  final double margin;
  final double jmlMargin;
  final String tglJt;
  final String status;
  final String jenisPembayaran;
  final String tglUpdate;
  final double jmlDebet;
  final double jmlDenda;

  InspiraModel({
    this.id = 0,
    this.noSertifikatInspira = '',
    this.noAng = 0,
    this.noSimpan = '',
    this.tglSimpan = '',
    this.jmlSimpanan = 0,
    this.tempoBln = 0,
    this.margin = 0,
    this.jmlMargin = 0,
    this.tglJt = '',
    this.status = '',
    this.jenisPembayaran = '',
    this.tglUpdate = '',
    this.jmlDebet = 0,
    this.jmlDenda = 0,
  });

  factory InspiraModel.fromJson(Map<String, dynamic> json) {
    return InspiraModel(
      id: json['id'] == null ? 0 : int.tryParse(json['id'].toString()) ?? 0,
      noSertifikatInspira: json['no_sertifikat_inspira']?.toString() ?? '',
      noAng: json['no_ang'] == null
          ? 0
          : int.tryParse(json['no_ang'].toString()) ?? 0,
      noSimpan: json['no_simpan']?.toString() ?? '',
      tglSimpan: json['tgl_simpan']?.toString() ?? '',
      jmlSimpanan: json['jml_simpanan'] == null
          ? 0
          : double.tryParse(json['jml_simpanan'].toString()) ?? 0,
      jmlDebet: json['jml_debet'] == null
          ? 0
          : double.tryParse(json['jml_debet'].toString()) ?? 0,
      jmlDenda: json['jml_denda'] == null
          ? 0
          : double.tryParse(json['jml_denda'].toString()) ?? 0,
      tempoBln: json['tempo_bln'] == null
          ? 0
          : int.tryParse(json['tempo_bln'].toString()) ?? 0,
      margin: json['margin'] == null
          ? 0
          : double.tryParse(json['margin'].toString()) ?? 0,
      jmlMargin: json['jml_margin'] == null
          ? 0
          : double.tryParse(json['jml_margin'].toString()) ?? 0,
      tglJt: json['tgl_jt']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      jenisPembayaran: json['jenis_pembayaran']?.toString() ?? '',
      tglUpdate: json['tgl_update']?.toString() ?? '',
    );
  }
}
