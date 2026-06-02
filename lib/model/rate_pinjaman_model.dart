class RatePinjamanModel {
  final int id;
  final String jenis;
  final String tenor;
  final String margin;
  final int urut;

  RatePinjamanModel({
    this.id = 0,
    this.jenis = '',
    this.tenor = '',
    this.margin = '',
    this.urut = 0,
  });

  factory RatePinjamanModel.fromJson(Map<String, dynamic> json) {
    return RatePinjamanModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      jenis: json['jenis']?.toString() ?? '',
      tenor: json['tenor']?.toString() ?? '',
      margin: json['margin']?.toString() ?? '',
      urut: json['urut'] is int
          ? json['urut']
          : int.tryParse(json['urut']?.toString() ?? '0') ?? 0,
    );
  }
}
