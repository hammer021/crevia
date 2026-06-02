class TokenKreditModel {
  final int id;
  final String noAng;
  final String expired;
  final String updatedon;
  final String token;
  final double nominal;
  final String notransaksi;
  final String updatedby;
  final String useddate;
  final String cicilan;

  TokenKreditModel({
    this.id = 0,
    this.noAng = '',
    this.cicilan = '',
    this.expired = '',
    this.updatedon = '',
    this.token = '',
    this.nominal = 0.0,
    this.notransaksi = '',
    this.updatedby = '',
    this.useddate = '',
  });

  factory TokenKreditModel.fromJson(Map<String, dynamic> json) {
    return TokenKreditModel(
      id: json['id'] == null ? 0 : int.tryParse(json['id'].toString()) ?? 0,
      noAng: json['noAng']?.toString() ?? '',
      expired: json['expired']?.toString() ?? '',
      updatedon: json['updatedon']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      nominal: json['nominal'] == null
          ? 0.0
          : double.tryParse(json['nominal'].toString()) ?? 0.0,
      notransaksi: json['notransaksi']?.toString() ?? '',
      updatedby: json['updatedby']?.toString() ?? '',
      useddate: json['useddate']?.toString() ?? '',
      cicilan: json['cicilan']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "noAng": noAng,
      "expired": expired,
      "updatedon": updatedon,
      "token": token,
      "nominal": nominal,
      "notransaksi": notransaksi,
      "updatedby": updatedby,
      "useddate": useddate,
      "cicilan": cicilan,
    };
  }
}
