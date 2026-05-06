import 'package:flutter/material.dart';

class BotaoAcao extends StatelessWidget {
  final IconData? icone;
  final String texto;
  final Color? cor;
  final bool secundario;
  final VoidCallback aoPressionar;

  const BotaoAcao({
    super.key,
    required this.texto,
    required this.aoPressionar,
    this.icone,
    this.cor,
    this.secundario = false,
  });

  @override
  Widget build(BuildContext context) {
    final corBase = cor ?? Theme.of(context).colorScheme.primary;
    final estilo = ElevatedButton.styleFrom(
      backgroundColor: secundario ? Colors.white : corBase,
      foregroundColor: secundario ? corBase : Colors.white,
      elevation: 0,
      side: secundario ? BorderSide(color: corBase) : null,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    );

    if (icone == null) {
      return ElevatedButton(
        style: estilo,
        onPressed: aoPressionar,
        child: Text(texto),
      );
    }

    return ElevatedButton.icon(
      style: estilo,
      onPressed: aoPressionar,
      icon: Icon(icone, size: 18),
      label: Text(texto),
    );
  }
}
