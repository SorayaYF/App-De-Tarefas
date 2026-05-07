import 'package:app_de_tarefas/componentes/botao_acao.dart';
import 'package:app_de_tarefas/componentes/meu_tag.dart';
import 'package:app_de_tarefas/providers/tarefa_provider.dart';
import 'package:app_de_tarefas/util/categorias.dart';
import 'package:app_de_tarefas/util/rotas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaBoasVindas extends StatelessWidget {
  const TelaBoasVindas({super.key});

  static const _dias = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo',
  ];

  static const _meses = [
    'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
    'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
  ];

  String _saudacao() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bom dia';
    if (h < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  String _dataExtenso() {
    final hoje = DateTime.now();
    return '${_dias[hoje.weekday - 1]}, ${hoje.day} de ${_meses[hoje.month - 1]}';
  }

  String _formataData(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Widget _stat({
    required IconData icone,
    required String numero,
    required String label,
    required Color cor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icone, color: cor, size: 20),
            const SizedBox(height: 8),
            Text(
              numero,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progresso(int realizadas, int total) {
    final pct = total == 0 ? 0.0 : realizadas / total;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progresso',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              Text(
                '$realizadas de $total · ${(pct * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: const Color(0xFFE5E7EB),
              color: const Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TarefaProvider>(context);
    final tarefas = provider.tarefas;
    final pendentes = tarefas.where((t) => !t.realizada).length;
    final realizadas = tarefas.where((t) => t.realizada).length;
    final atrasadas = provider.atrasadas.length;
    final proxima = provider.proxima;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _saudacao(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _dataExtenso(),
                style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _stat(
                    icone: Icons.pending_actions,
                    numero: '$pendentes',
                    label: 'Pendentes',
                    cor: const Color(0xFF2563EB),
                  ),
                  const SizedBox(width: 10),
                  _stat(
                    icone: Icons.check_circle_outline,
                    numero: '$realizadas',
                    label: 'Realizadas',
                    cor: const Color(0xFF10B981),
                  ),
                  const SizedBox(width: 10),
                  _stat(
                    icone: Icons.schedule,
                    numero: '$atrasadas',
                    label: 'Atrasadas',
                    cor: const Color(0xFFEF4444),
                  ),
                ],
              ),
              if (tarefas.isNotEmpty) ...[
                const SizedBox(height: 14),
                _progresso(realizadas, tarefas.length),
              ],
              const SizedBox(height: 24),
              const Text(
                'Próxima tarefa',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 8),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: proxima == null
                      ? null
                      : () => Navigator.pushNamed(
                            context,
                            Rotas.telaDetalhes,
                            arguments: proxima,
                          ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: proxima == null
                        ? const Row(
                            children: [
                              Icon(
                                Icons.celebration_outlined,
                                color: Color(0xFF10B981),
                                size: 28,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Tudo em dia! Nenhuma tarefa pendente.',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      proxima.titulo,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: [
                                  MeuTag(
                                    texto: proxima.categoria,
                                    cor: Categorias.cor(proxima.categoria),
                                  ),
                                  MeuTag(
                                    texto: _formataData(proxima.dataPrevista),
                                    cor: const Color(0xFF6B7280),
                                    icone: Icons.calendar_today_outlined,
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: BotaoAcao(
                  icone: Icons.list_alt_rounded,
                  texto: 'Ver todas as tarefas',
                  aoPressionar: () =>
                      Navigator.pushNamed(context, Rotas.telaLista),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}