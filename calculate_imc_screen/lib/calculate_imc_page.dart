import 'package:flutter/material.dart';

import 'model/imc.dart';
import 'repositories/imc_repository.dart';

class CalculateImcPage extends StatefulWidget {
  const CalculateImcPage({Key? key}) : super(key: key);

  @override
  State<CalculateImcPage> createState() => _CalculateImcPageState();
}

class _CalculateImcPageState extends State<CalculateImcPage> {
  final TextEditingController heightController = TextEditingController(text: "");
  final TextEditingController weightController = TextEditingController(text: "");
  final FocusNode heightFocusNode = FocusNode();
  final FocusNode weightFocusNode = FocusNode();
  final ImcRepository imcRepository = ImcRepository();
  List<Imc> imc = [];

  @override
  void initState() {
    super.initState();
    getImcs();
  }

  void getImcs() async {
    imc = await imcRepository.getImc();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Calcule seu IMC",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      const Text(
                        'Digite sua Altura:',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                      ),
                      const Spacer(),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            focusNode: heightFocusNode,
                            keyboardType: TextInputType.number,
                            controller: heightController,
                            onChanged: (value) {
                              setState(() {});
                            },
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(top: 0, left: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      const Text(
                        'Digite seu peso:',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                      ),
                      const Spacer(),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            focusNode: weightFocusNode,
                            keyboardType: TextInputType.number,
                            controller: weightController,
                            onChanged: (value) {
                              setState(() {});
                            },
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(top: 0, left: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: heightController.text.trim().isNotEmpty && weightController.text.trim().isNotEmpty
                          ? () {
                              calculateImc(height: heightController.text, weight: weightController.text);
                              weightFocusNode.unfocus();
                              heightFocusNode.unfocus();
                              heightController.clear();
                              weightController.clear();
                            }
                          : null,
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        backgroundColor: MaterialStateProperty.all(heightController.text.trim().isNotEmpty && weightController.text.trim().isNotEmpty
                            ? const Color.fromARGB(255, 141, 79, 151)
                            : Colors.grey),
                      ),
                      child: const Text(
                        "CALCULAR",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount: imc.length,
                    itemBuilder: (context, index) {
                      var imcValue = imc[index];
                      return Dismissible(
                        onDismissed: (DismissDirection dismissDirection) async {
                          await imcRepository.removeImc(imcValue.id);
                        },
                        key: Key(imcValue.id),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(imcValue.descricao),
                              subtitle: Text('IMC: ${imcValue.imc}'),
                              titleTextStyle: const TextStyle(fontSize: 26, color: Colors.black),
                              subtitleTextStyle: const TextStyle(fontSize: 26, color: Colors.black),
                            ),
                            const Divider(
                              thickness: 2,
                              color: Colors.black,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> calculateImc({required String weight, required String height}) async {
    double weightValue;
    double heightValue;
    String descricao = '';

    weightValue = double.tryParse(weight) ?? 0;

    if (height.contains('.')) {
      heightValue = double.tryParse(height) ?? 0.0;
    } else {
      heightValue = (double.tryParse(height) ?? 0.0) / 100.0;
    }

    if (weightValue <= 0 || heightValue <= 0) {
      return print('Valores invalidos');
    }
    double imc = double.parse((weightValue / (heightValue * heightValue)).toStringAsFixed(1));

    if (imc < 16) {
      descricao = 'Magreza grave';
    } else if (imc < 17) {
      descricao = 'Magreza moderada';
    } else if (imc < 18.5) {
      descricao = 'Magreza leve';
    } else if (imc < 25) {
      descricao = 'Saudavel';
    } else if (imc < 30) {
      descricao = 'Sobrepeso';
    } else if (imc < 35) {
      descricao = 'Obesidade Grau I';
    } else if (imc < 40) {
      descricao = 'Obesidade Grau II (severa)';
    } else if (imc >= 40) {
      descricao = 'Obesidade Grau III (morbida)';
    }
    await imcRepository.addImc(Imc(descricao, imc.toString()));
    setState(() {});
  }
}
