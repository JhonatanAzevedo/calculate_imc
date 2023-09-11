import 'package:flutter/cupertino.dart';

class Imc {
  final String _id = UniqueKey().toString();
  final String descricao;
  final String imc;

  Imc(this.descricao, this.imc);

  String get id => _id;
}
