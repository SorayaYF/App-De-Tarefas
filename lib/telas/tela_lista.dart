import 'package:app_de_tarefas/componentes/card_tarefa.dart';
import 'package:app_de_tarefas/models/tarefa.dart';
import 'package:app_de_tarefas/providers/tarefa_provider.dart';
import 'package:app_de_tarefas/util/rotas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaLista extends StatelessWidget {
  const TelaLista({super.key});

  Widget _vazio(String texto) => Center(
        child: Text(
          texto,
          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
        ),
      );

  Future<void> _confirmaRemocao(
    BuildContext context,
    Tarefa tarefa,
    TarefaProvider provider,
  ) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Excluir tarefa',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Text('Deseja realmente excluir "${tarefa.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
            ),
            child: const Text(
              'Excluir',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
    if (confirmou == true) {
      await provider.removeTarefa(tarefa.id!);
    }
  }

  Widget _listaSimples(
    BuildContext context,
    List<Tarefa> tarefas,
    TarefaProvider provider,
  ) {
    if (tarefas.isEmpty) return _vazio('Nenhuma tarefa.');
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: tarefas.length,
      itemBuilder: (_, i) {
        final t = tarefas[i];
        return CardTarefa(
          key: ValueKey(t.id),
          tarefa: t,
          aoTocar: () => Navigator.pushNamed(
            context,
            Rotas.telaDetalhes,
            arguments: t,
          ),
          aoRemover: () => _confirmaRemocao(context, t, provider),
        );
      },
    );
  }

  Widget _listaReordenavel(
    BuildContext context,
    List<Tarefa> tarefas,
    TarefaProvider provider,
  ) {
    if (tarefas.isEmpty) return _vazio('Nenhuma tarefa. Toque em + para criar.');
    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      buildDefaultDragHandles: false,
      itemCount: tarefas.length,
      onReorder: provider.reordena,
      itemBuilder: (_, i) {
        final t = tarefas[i];
        return CardTarefa(
          key: ValueKey(t.id),
          tarefa: t,
          indiceDrag: i,
          aoTocar: () => Navigator.pushNamed(
            context,
            Rotas.telaDetalhes,
            arguments: t,
          ),
          aoRemover: () => _confirmaRemocao(context, t, provider),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarefaProvider>(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tarefas',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: Color(0xFF2563EB),
            unselectedLabelColor: Color(0xFF6B7280),
            indicatorColor: Color(0xFF2563EB),
            labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            tabs: [
              Tab(text: 'Todas'),
              Tab(text: 'Importantes'),
              Tab(text: 'Realizadas'),
              Tab(text: 'Atrasadas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _listaReordenavel(context, provider.tarefas, provider),
            _listaSimples(context, provider.importantes, provider),
            _listaSimples(context, provider.realizadas, provider),
            _listaSimples(context, provider.atrasadas, provider),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, Rotas.telaForm),
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          elevation: 2,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}