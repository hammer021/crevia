class TransaksiModel {
  final String fcode;
  final String flokasi;
  final String fcustkey;
  final String fcustname;
  final double fgrandtotal;
  final String fdate;
  final String ftime;
  final double pointkmob;

  TransaksiModel({
    this.fcode = '',
    this.flokasi = '',
    this.fcustkey = '',
    this.fcustname = '',
    this.fgrandtotal = 0.0,
    this.fdate = '',
    this.ftime = '',
    this.pointkmob = 0.0,
  });

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    return TransaksiModel(
      fcode: json['fcode']?.toString() ?? '',
      flokasi: json['flokasi']?.toString() ?? '',
      fcustkey: json['fcustkey']?.toString() ?? '',
      fcustname: json['fcustname']?.toString() ?? '',
      fgrandtotal: json['fgrand_total'] == null
          ? 0.0
          : double.tryParse(json['fgrand_total'].toString()) ?? 0.0,
      pointkmob: json['pointkmob'] == null
          ? 0.0
          : double.tryParse(json['pointkmob'].toString()) ?? 0.0,
      fdate: json['fdate']?.toString() ?? '',
      ftime: json['ftime']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fcode": fcode,
      "flokasi": flokasi,
      "fcustkey": fcustkey,
      "fcustname": fcustname,
      "fgrand_total": fgrandtotal,
      "pointkmob": pointkmob,
      "fdate": fdate,
      "ftime": ftime,
    };
  }
}
