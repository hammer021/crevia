class ProfileModel {
  final int id;
  final String email;
  final bool emailConfirm;
  final bool phoneConfirm;
  final String hp;
  final String ktp;
  final String badge;
  final String pathKtp;
  final String pathSelfie;
  final String pathFoto;
  final String perusahaan;
  final String pathBadge;
  final String nak;
  final String pathBuktiPotong;
  final String confirm;
  final String anggota;
  final String va;
  final String namaVa;
  final String ewalletId;
  final String ewalletName;
  final String ewalletUsername;
  final String ewalletMsisdn;
  final String ewalletEmail;
  final double ewalletSaldo;
  final double maxSpbu;
  final double point;
  final double redeem;
  final double yourpoint;
  final double total_simpanan_wajib;
  final String noPeg;
  final String nmAng;
  final String almRmh;
  final String tlpHp;
  final String kdPrsh;
  final String nmPrsh;
  final String nmDep;
  final String nmBagian;
  final double plafon;
  final double plafonPakai;
  final double plafonSisa;
  final DateTime tglMsk;
  final DateTime? tglUpdate; // bisa null

  const ProfileModel({
    required this.id,
    required this.email,
    required this.emailConfirm,
    required this.phoneConfirm,
    required this.hp,
    required this.ktp,
    required this.badge,
    required this.pathKtp,
    required this.pathSelfie,
    required this.pathFoto,
    required this.perusahaan,
    required this.pathBadge,
    required this.nak,
    required this.pathBuktiPotong,
    required this.confirm,
    required this.anggota,
    required this.va,
    required this.namaVa,
    required this.ewalletId,
    required this.ewalletName,
    required this.ewalletUsername,
    required this.ewalletMsisdn,
    required this.ewalletEmail,
    required this.ewalletSaldo,
    required this.maxSpbu,
    required this.point,
    required this.redeem,
    required this.yourpoint,
    required this.total_simpanan_wajib,
    required this.noPeg,
    required this.nmAng,
    required this.almRmh,
    required this.tlpHp,
    required this.kdPrsh,
    required this.nmPrsh,
    required this.nmDep,
    required this.nmBagian,
    required this.plafon,
    required this.plafonPakai,
    required this.plafonSisa,
    required this.tglMsk,
    this.tglUpdate,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> jsons) {
    final json = jsons['akun'] ?? {};
    final ang = jsons['ang'] ?? {};

    return ProfileModel(
      point: double.tryParse(jsons['point']?.toString() ?? '') ?? 0,
      redeem: double.tryParse(jsons['redeem']?.toString() ?? '') ?? 0,
      yourpoint: double.tryParse(jsons['yourpoint']?.toString() ?? '') ?? 0,
      total_simpanan_wajib:
          double.tryParse(jsons['total_simpanan_wajib']?.toString() ?? '') ?? 0,
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      email: json['email']?.toString() ?? '',
      emailConfirm: json['email_confirm']?.toString() == '1',
      phoneConfirm: json['phone_confirm']?.toString() == '1',
      hp: json['hp']?.toString() ?? '',
      ewalletId: json['ewallet_id']?.toString() ?? '',
      ewalletName: json['ewallet_name']?.toString() ?? '',
      ewalletEmail: json['ewallet_email']?.toString() ?? '',
      ewalletUsername: json['ewallet_username']?.toString() ?? '',
      ewalletMsisdn: json['ewallet_msisdn']?.toString() ?? '',
      ewalletSaldo:
          double.tryParse(json['ewallet_saldo']?.toString() ?? '') ?? 0,
      ktp: json['ktp']?.toString() ?? '',
      badge: json['badge']?.toString() ?? '',
      pathKtp: json['path_ktp']?.toString() ?? '',
      pathFoto: json['path_foto']?.toString() ?? '',
      pathSelfie: json['path_selfie']?.toString() ?? '',
      perusahaan: json['perusahaan']?.toString() ?? '',
      pathBadge: json['path_badge']?.toString() ?? '',
      nak: json['nak']?.toString() ?? '',
      maxSpbu: double.tryParse(json['max_spbu']?.toString() ?? '') ?? 0,
      pathBuktiPotong: json['path_buktipotong']?.toString() ?? '',
      confirm: json['confirm']?.toString() ?? '',
      va: json['va']?.toString() ?? '',
      namaVa: json['nama_va']?.toString() ?? '',
      anggota: json['anggota']?.toString() ?? '',
      noPeg: ang['no_peg']?.toString() ?? '',
      nmAng: ang['nm_ang']?.toString() ?? '',
      almRmh: ang['alm_rmh']?.toString() ?? '',
      tlpHp: ang['tlp_hp']?.toString() ?? '',
      kdPrsh: ang['kd_prsh']?.toString() ?? '',
      nmPrsh: ang['nm_prsh']?.toString() ?? '',
      nmDep: ang['nm_dep']?.toString() ?? '',
      nmBagian: ang['nm_bagian']?.toString() ?? '',
      tglMsk: ang['tgl_msk'] != null
          ? DateTime.tryParse(ang['tgl_msk'].toString()) ??
              DateTime.utc(1993, 2, 10)
          : DateTime.utc(1993, 2, 10),
      plafon: double.tryParse(ang['plafon']?.toString() ?? '') ?? 0,
      plafonPakai: double.tryParse(ang['plafon_pakai']?.toString() ?? '') ?? 0,
      plafonSisa: (double.tryParse(ang['plafon']?.toString() ?? '') ?? 0) -
          (double.tryParse(ang['plafon_pakai']?.toString() ?? '') ?? 0),
      tglUpdate: ang['tgl_msk'] != null
          ? DateTime.tryParse(ang['tgl_msk'].toString())
          : null,
    );
  }
}
