import 'package:app_de_tarefas/models/model.dart';

class Tarefa implements Model {
  int? _id;
  String titulo;
  String descricao;
  DateTime dataPrevista;
  bool importante;
  bool realizada;
  int ordem;

  Tarefa({
    required this.titulo,
    required this.descricao,
    required this.dataPrevista,
    this.importante = false,
    this.realizada = false,
    this.ordem = 0,
  });

  @override
  set id(int id) => _id = id;

  @override
  int? get id => _id;

  bool get atrasada {
    if (realizada) return false;
    final hoje = DateTime.now();
    final inicioHoje = DateTime(hoje.year, hoje.month, hoje.day);
    final diaPrevisto = DateTime(
      dataPrevista.year,
      dataPrevista.month,
      dataPrevista.day,
    );
    return diaPrevisto.isBefore(inicioHoje);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'titulo': titulo,
      'descricao': descricao,
      'dataPrevista': dataPrevista.toIso8601String(),
      'importante': importante ? 1 : 0,
      'realizada': realizada ? 1 : 0,
      'ordem': ordem,
    };
  }

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    var tarefa = Tarefa(
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      dataPrevista: DateTime.parse(map['dataPrevista'] as String),
      importante: map['importante'] == 1,
      realizada: map['realizada'] == 1,
      ordem: map['ordem'] as int,
    );
    tarefa.id = map['id'] as int;
    return tarefa;
  }
}
