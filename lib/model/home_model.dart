import 'package:flutter/material.dart';
import 'package:html/parser.dart';

/// Helper untuk parse HTML ke plain text
String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);
  return parse(document.body?.text ?? "").documentElement?.text ?? "";
}

class K3PGService {
  final IconData image;
  final Color color;
  final String title;
  final String mode;

  K3PGService({
    required this.image,
    required this.title,
    required this.color,
    required this.mode,
  });
}

class Promo {
  final String id;
  final String title;
  final String content;
  final String image;
  final String image2;
  final String image3;
  final String image4;
  final String image5;
  final String button;

  Promo({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.image2,
    required this.image3,
    required this.image4,
    required this.image5,
    required this.button,
  });

  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content'] != null ? _parseHtmlString(json['content']) : '',
      image: json['image_path']?.toString() ?? '',
      image2: json['image2_path']?.toString() ?? '',
      image3: json['image3_path']?.toString() ?? '',
      image4: json['image4_path']?.toString() ?? '',
      image5: json['image5_path']?.toString() ?? '',
      button: 'Selengkapnya',
    );
  }
}

class Notif {
  final String idNotif;
  final String idUser;
  final String type;
  final String tgl;
  final String message;
  final String open;
  final String reff;

  Notif({
    required this.idNotif,
    required this.idUser,
    required this.type,
    required this.tgl,
    required this.message,
    required this.open,
    required this.reff,
  });

  factory Notif.fromJson(Map<String, dynamic> json) {
    return Notif(
      idNotif: json['id_notif']?.toString() ?? '',
      idUser: json['id_user']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      reff: json['reff']?.toString() ?? '',
      open: json['open']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      tgl: json['tgl']?.toString() ?? '',
    );
  }
}

class CountNotif {
  final String nak;
  final int unreadCount;

  CountNotif({
    required this.nak,
    required this.unreadCount,
  });

  factory CountNotif.fromJson(Map<String, dynamic> jsons) {
    final Map<String, dynamic> json = jsons['data'] ?? {};
    return CountNotif(
      nak: json['nak']?.toString() ?? '',
      unreadCount: int.tryParse(json['unread_count']?.toString() ?? '0') ?? 0,
    );
  }
}
