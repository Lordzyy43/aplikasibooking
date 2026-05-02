import 'package:flutter/material.dart';

class CategoryModel {
  final int id;
  final String name;
  final IconData icon;
  final Color color;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    this.color = const Color(0xFF6366F1), // Warna default (Indigo)
  });

  // Opsional: Jika data nanti datang dari API Laravel kamu
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      // Logika konversi string ke IconData bisa ditambahkan di sini
      icon: Icons.sports_soccer,
    );
  }
}
