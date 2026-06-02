// import 'package:flutter/material.dart';
import 'package:html/parser.dart';

String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);
  String parsedString =
      parse(document.body?.text ?? "").documentElement?.text ?? "";
  return parsedString;
}

class Produk {
  final String produkId;
  final String namaProduk;
  final String kategoriProdukId;
  final String kategoriProduk;
  final String dateCreated;
  final String status;
  final String content;
  final String type;
  final String tglPublish;
  final List<Attachment> attachment;
  final List<WaAdmin> waAdmin;

  const Produk({
    required this.produkId,
    required this.namaProduk,
    required this.kategoriProdukId,
    required this.kategoriProduk,
    required this.dateCreated,
    required this.status,
    required this.content,
    required this.type,
    required this.tglPublish,
    required this.attachment,
    required this.waAdmin,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      produkId: json['produk_id']?.toString() ?? '',
      namaProduk: json['nama_produk']?.toString() ?? '',
      kategoriProdukId: json['kategori_produk_id']?.toString() ?? '',
      kategoriProduk: json['kategori_produk']?.toString() ?? '',
      dateCreated: json['date_created']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      content: json['content'] != null ? _parseHtmlString(json['content']) : '',
      type: json['type']?.toString() ?? '',
      tglPublish: json['tgl_publish']?.toString() ?? '',
      attachment: (json['attachment'] as List<dynamic>?)
              ?.map((item) => Attachment.fromJson(item))
              .toList() ??
          [],
      waAdmin: (json['wa_admin'] as List<dynamic>?)
              ?.map((item1) => WaAdmin.fromJson(item1))
              .toList() ??
          [],
    );
  }
}

class Attachment {
  final String attachProdukId;
  final String produkId;
  final String imagePath;
  final String dateCreated;

  const Attachment({
    required this.attachProdukId,
    required this.produkId,
    required this.imagePath,
    required this.dateCreated,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      attachProdukId: json['attach_produk_id']?.toString() ?? '',
      produkId: json['produk_id']?.toString() ?? '',
      imagePath: json['image_path']?.toString() ?? '',
      dateCreated: json['date_created']?.toString() ?? '',
    );
  }
}

class WaAdmin {
  final String waId;
  final String note;
  final String phone;
  final String dateCreated;

  const WaAdmin({
    required this.waId,
    required this.note,
    required this.phone,
    required this.dateCreated,
  });

  factory WaAdmin.fromJson(Map<String, dynamic> json) {
    return WaAdmin(
      waId: json['wa_id']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      dateCreated: json['created_at']?.toString() ?? '',
    );
  }
}

class KategoriProduk {
  final String kategoriProdukId;
  final String kategoriProduk;
  final String dateCreated;
  final String kodeKategori;

  const KategoriProduk({
    required this.kategoriProdukId,
    required this.kategoriProduk,
    required this.dateCreated,
    required this.kodeKategori,
  });

  factory KategoriProduk.fromJson(Map<String, dynamic> json) {
    return KategoriProduk(
      kategoriProdukId: json['kategori_produk_id']?.toString() ?? '',
      kategoriProduk: json['kategori_produk']?.toString() ?? '',
      dateCreated: json['date_created']?.toString() ?? '',
      kodeKategori: json['kode_kategori']?.toString() ?? '',
    );
  }
}
