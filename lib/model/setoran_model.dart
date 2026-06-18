class SetoranModel {
  final String id;
  final String tanggal;
  final String bank;
  final String rekening;
  final String nama;
  final double nominal;
  final String bukti;
  final String status;
  final String jangka;
  final String kodeStatus;
  final String keterangan;
  final String no_pinjam;

  SetoranModel({
    this.id = '',
    this.tanggal = '',
    this.bank = '',
    this.rekening = '',
    this.nama = '',
    this.nominal = 0,
    this.bukti = '',
    this.status = '',
    this.jangka = '',
    this.kodeStatus = '',
    this.keterangan = '',
    this.no_pinjam = '',
  });

  factory SetoranModel.fromJson(Map<String, dynamic> json) {
    return SetoranModel(
      id: json['id']?.toString() ?? '',
      tanggal: json['tanggal']?.toString() ?? '',
      bank: json['bank']?.toString() ?? '',
      rekening: json['rekening']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      nominal: json['nominal'] == null
          ? 0
          : double.tryParse(json['nominal'].toString()) ?? 0,
      bukti: json['bukti']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      jangka: json['jangka']?.toString() ?? '',
      kodeStatus: json['kode_status']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? '',
      no_pinjam: json['no_pinjam']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': tanggal,
      'bank': bank,
      'rekening': rekening,
      'nama': nama,
      'nominal': nominal,
      'bukti': bukti,
      'status': status,
      'jangka': jangka,
      'kode_status': kodeStatus,
      'keterangan': keterangan,
      'no_pinjam': no_pinjam,
    };
  }
}
