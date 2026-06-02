class RateSimpananModel {
  final int id;
  final String simpanan;
  final String tenor;
  final String sukubunga;
  final String nominal;
  final int urut;

  RateSimpananModel({
    this.id = 0,
    this.simpanan = '',
    this.tenor = '',
    this.sukubunga = '',
    this.nominal = '',
    this.urut = 0,
  });

  factory RateSimpananModel.fromJson(Map<String, dynamic> json) {
    return RateSimpananModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      simpanan: json['simpanan']?.toString() ?? '',
      tenor: json['tenor']?.toString() ?? '',
      sukubunga: json['sukubunga']?.toString() ?? '',
      nominal: json['nominal']?.toString() ?? '',
      urut: json['urut'] is int
          ? json['urut']
          : int.tryParse(json['urut']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'simpanan': simpanan,
      'tenor': tenor,
      'sukubunga': sukubunga,
      'nominal': nominal,
      'urut': urut,
    };
  }
}
