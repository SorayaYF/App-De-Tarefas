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

  Widget _bloco({required String label, required Widget conteudo}) {
    return Column(
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
        const SizedBox(height: 6),
        conteudo,
      ],
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID #${tarefa.id}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (tarefa.importante)
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.star,
                            color: Color(0xFFF59E0B),
                            size: 22,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          tarefa.titulo,
                          style: TextStyle(
                            fontSize: 22,
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
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      MeuTag(
                        texto: tarefa.categoria,
                        cor: Categorias.cor(tarefa.categoria),
                      ),
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
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bloco(
                    label: 'Descrição',
                    conteudo: Text(
                      tarefa.descricao.isEmpty
                          ? '(sem descrição)'
                          : tarefa.descricao,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _bloco(
                    label: 'Data prevista',
                    conteudo: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formataData(tarefa.dataPrevista),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
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
            const SizedBox(height: 10),
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
    );
  }
}
