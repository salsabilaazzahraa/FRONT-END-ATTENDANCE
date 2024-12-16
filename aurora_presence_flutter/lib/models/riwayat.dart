// models/riwayat_model.dart
import 'package:flutter/material.dart';

class Riwayat {
  final String tanggal;
  final String sampaiTanggal;
  final String deskripsi;
  final IconData icon;
  final Color iconColor;

  Riwayat({
    required this.tanggal,
    required this.sampaiTanggal,
    required this.deskripsi,
    required this.icon,
    required this.iconColor,
  });

  // Convert Riwayat to Map
  Map<String, dynamic> toMap() {
    return {
      'tanggal': tanggal,
      'sampaiTanggal': sampaiTanggal,
      'deskripsi': deskripsi,
      'icon': {
        'codePoint': icon.codePoint,
        'fontFamily': icon.fontFamily,
      },
      'iconColor': iconColor.value,
    };
  }

  // Convert Map to Riwayat
  factory Riwayat.fromMap(Map<String, dynamic> map) {
    return Riwayat(
      tanggal: map['tanggal'],
      sampaiTanggal: map['sampaiTanggal'],
      deskripsi: map['deskripsi'],
      icon: IconData(map['icon']['codePoint'], fontFamily: map['icon']['fontFamily']),
      iconColor: Color(map['iconColor']),
    );
  }
}
