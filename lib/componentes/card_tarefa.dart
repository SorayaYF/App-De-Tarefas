import 'package:app_de_tarefas/componentes/meu_tag.dart';
import 'package:app_de_tarefas/models/tarefa.dart';
import 'package:app_de_tarefas/util/categorias.dart';
import 'package:flutter/material.dart';

class CardTarefa extends StatelessWidget {
  final Tarefa tarefa;
  final VoidCallback aoTocar;
  final VoidCallback aoRemover;
  final int? indiceDrag;

  const CardTarefa({
    super.key,
    required this.tarefa,
    required this.aoTocar,
    required this.aoRemover,
    this.indiceDrag,
  });

  String _formataData(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: aoTocar,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
            child: Row(
              children: [
                if (indiceDrag != null)
                  ReorderableDragStartListener(
                    index: indiceDrag!,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.drag_indicator,
                        color: Color(0xFF9CA3AF),
                        size: 22,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (tarefa.importante)
                            const Padding(
                              padding: EdgeInsets.only(right: 6),
                              child: Icon(
                                Icons.star,
                                size: 16,
                                color: Color(0xFFF59E0B),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              tarefa.titulo,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1F2937),
                                decoration: tarefa.realizada
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          MeuTag(
                            texto: tarefa.categoria,
                            cor: Categorias.cor(tarefa.categoria),
                          ),
                          if (tarefa.realizada)
                            const MeuTag(
                              texto: 'Realizada',
                              cor: Color(0xFF10B981),
                              icone: Icons.check,
                            ),
                          if (tarefa.atrasada)
                            const MeuTag(
                              texto: 'Atrasada',
                              cor: Color(0xFFEF4444),
                              icone: Icons.schedule,
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formataData(tarefa.dataPrevista),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFEF4444),
                    size: 20,
                  ),
                  onPressed: aoRemover,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
