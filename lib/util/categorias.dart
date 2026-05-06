import 'package:flutter/material.dart';

class Categorias {
  static Color cor(String categoria) {
    switch (categoria) {
      case 'Pessoal':
        return const Color(0xFF3B82F6);
      case 'Trabalho':
        return const Color(0xFF1E40AF);
      case 'Estudos':
        return const Color(0xFF0EA5E9);
      case 'Saúde':
        return const Color(0xFF06B6D4);
      default:
        return const Color(0xFF64748B);
    }
  }
}
