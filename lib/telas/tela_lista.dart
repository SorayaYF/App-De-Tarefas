import 'package:app_de_tarefas/componentes/card_tarefa.dart';
import 'package:app_de_tarefas/models/tarefa.dart';
import 'package:app_de_tarefas/providers/tarefa_provider.dart';
import 'package:app_de_tarefas/util/rotas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
  int _filtroAtivo = 0;

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

  Widget _chipFiltro({
    required int indice,
    required String label,
    required IconData icone,
    required Color cor,
    required int contagem,
  }) {
    final ativo = _filtroAtivo == indice;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => _filtroAtivo = indice),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: ativo ? cor : Colors.white,
          border: Border.all(color: ativo ? cor : const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 15, color: ativo ? Colors.white : cor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ativo ? Colors.white : const Color(0xFF374151),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: ativo
                    ? Colors.white.withValues(alpha: 0.25)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$contagem',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: ativo ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listaSimples(List<Tarefa> tarefas, TarefaProvider provider) {
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

  Widget _listaReordenavel(List<Tarefa> tarefas, TarefaProvider provider) {
    if (tarefas.isEmpty) {
      return _vazio('Nenhuma tarefa. Toque em + para criar.');
    }
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

    final filtros = [
      provider.tarefas,
      provider.importantes,
      provider.realizadas,
      provider.atrasadas,
    ];
    final atual = filtros[_filtroAtivo];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tarefas',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _chipFiltro(
                    indice: 0,
                    label: 'Todas',
                    icone: Icons.list_rounded,
                    cor: const Color(0xFF2563EB),
                    contagem: provider.tarefas.length,
                  ),
                  const SizedBox(width: 8),
                  _chipFiltro(
                    indice: 1,
                    label: 'Importantes',
                    icone: Icons.star_outline_rounded,
                    cor: const Color(0xFFF59E0B),
                    contagem: provider.importantes.length,
                  ),
                  const SizedBox(width: 8),
                  _chipFiltro(
                    indice: 2,
                    label: 'Realizadas',
                    icone: Icons.check_circle_outline,
                    cor: const Color(0xFF10B981),
                    contagem: provider.realizadas.length,
                  ),
                  const SizedBox(width: 8),
                  _chipFiltro(
                    indice: 3,
                    label: 'Atrasadas',
                    icone: Icons.schedule,
                    cor: const Color(0xFFEF4444),
                    contagem: provider.atrasadas.length,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Expanded(
            child: _filtroAtivo == 0
                ? _listaReordenavel(atual, provider)
                : _listaSimples(atual, provider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Rotas.telaForm),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 2,
        child: const Icon(Icons.add),
      ),
    );
  }
}