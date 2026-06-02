class PotonganModel {
  final String buktiPotga;
  final String tglPotga;
  final String nmPotga;
  final String nmPinjaman;
  final String noRefBukti;
  final int angsKe;
  final int tempoBln;
  final double jmlPokok;
  final int angsuran;
  final double jumlah;
  final String ket;
  final double saldoAkhir;

  const PotonganModel({
    required this.buktiPotga,
    required this.tglPotga,
    required this.nmPotga,
    required this.nmPinjaman,
    required this.noRefBukti,
    required this.angsKe,
    required this.tempoBln,
    required this.jmlPokok,
    required this.angsuran,
    required this.jumlah,
    required this.ket,
    required this.saldoAkhir,
  });

  factory PotonganModel.fromJson(Map<String, dynamic> json) {
    return PotonganModel(
      buktiPotga: json['bukti_potga']?.toString() ?? '',
      tglPotga: json['tgl_potga']?.toString() ?? '',
      nmPotga: json['nm_potga']?.toString() ?? '',
      nmPinjaman: json['nm_pinjaman']?.toString() ?? '',
      noRefBukti: json['no_ref_bukti']?.toString() ?? '',
      angsKe: int.tryParse(json['angs_ke']?.toString() ?? '') ?? 0,
      tempoBln: int.tryParse(json['tempo_bln']?.toString() ?? '') ?? 0,
      jmlPokok: double.tryParse(json['jml_pokok']?.toString() ?? '') ?? 0,
      angsuran: int.tryParse(json['angsuran']?.toString() ?? '') ?? 0,
      jumlah: double.tryParse(json['jumlah']?.toString() ?? '') ?? 0,
      ket: json['ket']?.toString() ?? '',
      saldoAkhir: double.tryParse(json['saldo_akhir']?.toString() ?? '') ?? 0,
    );
  }
}
