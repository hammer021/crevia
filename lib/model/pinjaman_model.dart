class PinjamanModel {
  final String noPinjam;
  final String tglPinjam;
  final double jmlPinjam;
  final int tempoBln;
  final double margin;
  final double jmlmargin;
  final double angsuran;
  final double jmlBiayaAdmin;
  final String nmPinjaman;
  final String stsLunas;
  final String blthLunas;
  final String keterangan;

  const PinjamanModel({
    required this.noPinjam,
    required this.tglPinjam,
    required this.jmlPinjam,
    required this.tempoBln,
    required this.margin,
    required this.jmlmargin,
    required this.angsuran,
    required this.jmlBiayaAdmin,
    required this.nmPinjaman,
    required this.stsLunas,
    required this.blthLunas,
    required this.keterangan,
  });

  factory PinjamanModel.fromJson(Map<String, dynamic> json) {
    return PinjamanModel(
      noPinjam: json['no_pinjam']?.toString() ?? '',
      tglPinjam: json['tgl_pinjam']?.toString() ?? '',
      stsLunas: () {
        final v = json['sts_lunas']?.toString();
        switch (v) {
          case "0":
            return "Belum Lunas";
          case "2":
            return "Ditolak";
          case "3":
            return "Pengajuan";
          case "1":
            return "Lunas";
          default:
            return "";
        }
      }(),
      blthLunas: json['blth_lunas']?.toString() ?? '',
      nmPinjaman: json['nm_pinjaman']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? '',
      jmlPinjam: double.tryParse(json['jml_pinjam']?.toString() ?? '') ?? 0,
      tempoBln: int.tryParse(json['tempo_bln']?.toString() ?? '') ?? 0,
      margin: double.tryParse(json['margin']?.toString() ?? '') ?? 0,
      angsuran: double.tryParse(json['angsuran']?.toString() ?? '') ?? 0,
      jmlmargin: double.tryParse(json['jml_margin']?.toString() ?? '') ?? 0,
      jmlBiayaAdmin:
          double.tryParse(json['jml_biaya_admin']?.toString() ?? '') ?? 0,
    );
  }
}
