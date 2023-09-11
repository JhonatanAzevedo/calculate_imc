

import '../model/imc.dart';

class ImcRepository {
  final List<Imc> _imc = [];

  Future<void> addImc(Imc tarefa) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _imc.add(tarefa);
  }

  Future<void> removeImc(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _imc.remove(_imc.where((tarefa) => tarefa.id == id).first);
  }

  Future<List<Imc>> getImc() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _imc;
  }

}