import 'package:app_de_tarefas/models/tarefa.dart';
import 'package:app_de_tarefas/util/db.dart';
import 'package:flutter/material.dart';

class TarefaProvider with ChangeNotifier {
  List<Tarefa> _tarefas = [];

  List<Tarefa> get tarefas => _tarefas;

  List<Tarefa> get importantes =>
      _tarefas.where((t) => t.importante).toList();

  List<Tarefa> get realizadas =>
      _tarefas.where((t) => t.realizada).toList();

  List<Tarefa> get atrasadas =>
      _tarefas.where((t) => t.atrasada).toList();

  Tarefa? get proxima {
    final pendentes = _tarefas.where((t) => !t.realizada).toList()
      ..sort((a, b) => a.dataPrevista.compareTo(b.dataPrevista));
    return pendentes.isEmpty ? null : pendentes.first;
  }

  Future<void> carregaTarefas() async {
    final dados = await DBUtil.list('Tarefa');
    _tarefas = dados.map((m) => Tarefa.fromMap(m)).toList();
    notifyListeners();
  }

  Future<void> addTarefa(Tarefa tarefa) async {
    tarefa.ordem = _tarefas.length;
    await DBUtil.insert(tarefa);
    _tarefas.add(tarefa);
    notifyListeners();
  }

  Future<void> atualizaTarefa(Tarefa tarefa) async {
    await DBUtil.update(tarefa);
    final i = _tarefas.indexWhere((t) => t.id == tarefa.id);
    if (i >= 0) _tarefas[i] = tarefa;
    notifyListeners();
  }

  Future<void> removeTarefa(int id) async {
    await DBUtil.delete('Tarefa', id);
    _tarefas.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future<void> realizaTarefa(Tarefa tarefa) async {
    tarefa.realizada = true;
    await atualizaTarefa(tarefa);
  }

  Future<void> reordena(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    final movida = _tarefas.removeAt(oldIndex);
    _tarefas.insert(newIndex, movida);
    for (var i = 0; i < _tarefas.length; i++) {
      _tarefas[i].ordem = i;
      await DBUtil.update(_tarefas[i]);
    }
    notifyListeners();
  }
}
