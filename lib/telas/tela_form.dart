import 'package:app_de_tarefas/componentes/botao_acao.dart';
import 'package:app_de_tarefas/models/tarefa.dart';
import 'package:app_de_tarefas/providers/tarefa_provider.dart';
import 'package:app_de_tarefas/util/categorias.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaForm extends StatefulWidget {
  const TelaForm({super.key});

  @override
  State<TelaForm> createState() => _TelaFormState();
}

class _TelaFormState extends State<TelaForm> {
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  DateTime _data = DateTime.now();
  bool _importante = false;
  String _categoria = 'Outros';
  Tarefa? _emEdicao;
  bool _carregado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_carregado) return;
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is Tarefa) {
      _emEdicao = arg;
      _tituloController.text = arg.titulo;
      _descricaoController.text = arg.descricao;
      _data = arg.dataPrevista;
      _importante = arg.importante;
      _categoria = arg.categoria;
    }
    _carregado = true;
  }

  Future<void> _selecionaData() async {
    final escolhida = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (escolhida != null) setState(() => _data = escolhida);
  }

  Future<void> _salva() async {
    if (_tituloController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um título')),
      );
      return;
    }

    final provider = Provider.of<TarefaProvider>(context, listen: false);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      if (_emEdicao != null) {
        _emEdicao!.titulo = _tituloController.text.trim();
        _emEdicao!.descricao = _descricaoController.text.trim();
        _emEdicao!.dataPrevista = _data;
        _emEdicao!.importante = _importante;
        _emEdicao!.categoria = _categoria;
        await provider.atualizaTarefa(_emEdicao!);
      } else {
        await provider.addTarefa(Tarefa(
          titulo: _tituloController.text.trim(),
          descricao: _descricaoController.text.trim(),
          dataPrevista: _data,
          importante: _importante,
          categoria: _categoria,
        ));
      }
      navigator.pop();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  String _formataData(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Widget _label(String texto) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final editando = _emEdicao != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editando ? 'Editar tarefa' : 'Nova tarefa',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Título'),
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                hintText: 'Ex: Estudar Flutter',
              ),
            ),
            const SizedBox(height: 16),
            _label('Descrição'),
            TextField(
              controller: _descricaoController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Detalhes da tarefa',
              ),
            ),
            const SizedBox(height: 16),
            _label('Categoria'),
            DropdownButtonFormField<String>(
              value: _categoria,
              items: Tarefa.categorias
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Categorias.cor(c),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(c),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _categoria = v ?? 'Outros'),
            ),
            const SizedBox(height: 16),
            _label('Data prevista'),
            InkWell(
              onTap: _selecionaData,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _formataData(_data),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Alterar',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Marcar como importante',
                  style: TextStyle(fontSize: 15),
                ),
                value: _importante,
                activeColor: const Color(0xFF2563EB),
                onChanged: (v) => setState(() => _importante = v),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: BotaoAcao(
                icone: Icons.check,
                texto: editando ? 'Salvar alterações' : 'Adicionar tarefa',
                aoPressionar: _salva,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
