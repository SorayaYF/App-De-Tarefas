import 'package:app_de_tarefas/componentes/botao_acao.dart';
import 'package:app_de_tarefas/componentes/meu_tag.dart';
import 'package:app_de_tarefas/models/tarefa.dart';
import 'package:app_de_tarefas/providers/tarefa_provider.dart';
import 'package:app_de_tarefas/util/categorias.dart';
import 'package:app_de_tarefas/util/rotas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaDetalhes extends StatelessWidget {
  const TelaDetalhes({super.key});

  String _formataData(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _tempoRelativo(DateTime data) {
    final agora = DateTime.now();
    final hoje = DateTime(agora.year, agora.month, agora.day);
    final alvo = DateTime(data.year, data.month, data.day);
    final diff = alvo.difference(hoje).inDays;
    if (diff == 0) return 'Hoje';
    if (diff == 1) return 'Amanhã';
    if (diff > 1) return 'Em $diff dias';
    if (diff == -1) return 'Atrasada há 1 dia';
    return 'Atrasada há ${-diff} dias';
  }

  Widget _header(Tarefa tarefa) {
    final cor = Categorias.cor(tarefa.categoria);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.08),
        border: Border.all(color: cor.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MeuTag(texto: tarefa.categoria, cor: cor),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (tarefa.importante)
                const Padding(
                  padding: EdgeInsets.only(right: 8, top: 4),
                  child: Icon(
                    Icons.star_rounded,
                    color: Color(0xFFF59E0B),
                    size: 26,
                  ),
                ),
              Expanded(
                child: Text(
                  tarefa.titulo,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                    decoration: tarefa.realizada
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              MeuTag(
                texto: tarefa.realizada ? 'Realizada' : 'Pendente',
                cor: tarefa.realizada
                    ? const Color(0xFF10B981)
                    : const Color(0xFFF59E0B),
                icone: tarefa.realizada
                    ? Icons.check_circle_outline
                    : Icons.schedule,
              ),
              if (tarefa.atrasada)
                const MeuTag(
                  texto: 'Atrasada',
                  cor: Color(0xFFEF4444),
                  icone: Icons.warning_amber_rounded,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemInfo({
    required IconData icone,
    required String label,
    required Widget conteudo,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icone, color: const Color(0xFF2563EB), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                conteudo,
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final passada = ModalRoute.of(context)!.settings.arguments as Tarefa;
    final provider = Provider.of<TarefaProvider>(context);
    final tarefa = provider.tarefas.firstWhere(
      (t) => t.id == passada.id,
      orElse: () => passada,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhes',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _header(tarefa),
          const SizedBox(height: 14),
          _itemInfo(
            icone: Icons.tag,
            label: 'ID',
            conteudo: Text(
              '#${tarefa.id}',
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _itemInfo(
            icone: Icons.calendar_today_outlined,
            label: 'Data prevista',
            conteudo: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formataData(tarefa.dataPrevista),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _tempoRelativo(tarefa.dataPrevista),
                  style: TextStyle(
                    fontSize: 12,
                    color: tarefa.atrasada
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _itemInfo(
            icone: Icons.notes_rounded,
            label: 'Descrição',
            conteudo: Text(
              tarefa.descricao.isEmpty ? '(sem descrição)' : tarefa.descricao,
              style: TextStyle(
                fontSize: 15,
                color: tarefa.descricao.isEmpty
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF1F2937),
                fontStyle: tarefa.descricao.isEmpty
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!tarefa.realizada)
                SizedBox(
                  width: double.infinity,
                  child: BotaoAcao(
                    icone: Icons.check,
                    texto: 'Marcar como realizada',
                    cor: const Color(0xFF10B981),
                    aoPressionar: () {
                      provider.realizaTarefa(tarefa);
                      Navigator.pop(context);
                    },
                  ),
                ),
              if (!tarefa.realizada) const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: BotaoAcao(
                  icone: Icons.edit_outlined,
                  texto: 'Editar',
                  secundario: true,
                  aoPressionar: () => Navigator.pushNamed(
                    context,
                    Rotas.telaForm,
                    arguments: tarefa,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}