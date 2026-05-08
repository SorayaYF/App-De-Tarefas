import 'package:app_de_tarefas/providers/tarefa_provider.dart';
import 'package:app_de_tarefas/telas/tela_boas_vindas.dart';
import 'package:app_de_tarefas/telas/tela_detalhes.dart';
import 'package:app_de_tarefas/telas/tela_form.dart';
import 'package:app_de_tarefas/telas/tela_lista.dart';
import 'package:app_de_tarefas/util/rotas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaria = Color(0xFF2563EB);
    const borda = Color(0xFFE5E7EB);

    return ChangeNotifierProvider(
      create: (_) => TarefaProvider()..carregaTarefas(),
      child: MaterialApp(
        title: 'Tarefas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: primaria),
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF1F2937),
            elevation: 0,
            scrolledUnderElevation: 0,
            shape: Border(bottom: BorderSide(color: borda)),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: borda),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: borda),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: primaria, width: 1.5),
            ),
          ),
        ),
        initialRoute: Rotas.telaBoasVindas,
        routes: {
          Rotas.telaBoasVindas: (_) => const TelaBoasVindas(),
          Rotas.telaLista: (_) => const TelaLista(),
          Rotas.telaForm: (_) => const TelaForm(),
          Rotas.telaDetalhes: (_) => const TelaDetalhes(),
        },
      ),
    );
  }
}
