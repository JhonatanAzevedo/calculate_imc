import 'dart:convert';
import 'dart:io';

class People {
  String name;
  double height;
  double weight;
  People({
    this.name = '',
    this.height = 0.0,
    this.weight = 0.0,
  });

  _calculateImc() {
    if (weight <= 0 || height <= 0) {
      return print('Valores invalidos');
    }
    double imc = double.parse((weight / (height * height)).toStringAsFixed(1));

    if (imc < 16) {
      return print('$name o seu IMC e: $imc, Magreza grave');
    } else if (imc < 17) {
      return print('$name o seu IMC e: $imc, Magreza moderada');
    } else if (imc < 18.5) {
      return print('$name o seu IMC e: $imc, Magreza leve');
    } else if (imc < 25) {
      return print('$name o seu IMC e: $imc, Saudavel');
    } else if (imc < 30) {
      return print('$name o seu IMC e: $imc, Sobrepeso');
    } else if (imc < 35) {
      return print('$name o seu IMC e: $imc, Obesidade Grau I');
    } else if (imc < 40) {
      return print('$name o seu IMC e: $imc, Obesidade Grau II (severa)');
    } else if (imc >= 40) {
      return print('$name o seu IMC e: $imc, Obesidade Grau III (morbida)');
    }
  }

  void readUserData() {
    print("Digite seu nome:");
    name = stdin.readLineSync(encoding: utf8) ?? '';

    print("Digite sua altura:");
    String heightInput = stdin.readLineSync(encoding: utf8) ?? '0';
    if (heightInput.contains('.')) {
      height = double.tryParse(heightInput) ?? 0.0;
    } else {
      height = (double.tryParse(heightInput) ?? 0.0) / 100.0;
    }

    print("Digite seu peso:");
    weight = double.tryParse(stdin.readLineSync(encoding: utf8) ?? '0') ?? 0;

    _calculateImc();
  }
}
