import '../model/imc.dart';
import '../services/sql_data_base.dart';

class ImcRepository {
  Future<List<ImcModel>> getImc() async {
    List<ImcModel> imcList = [];
    var db = await SQLiteDataBase().getDataBase();
    var result = await db.rawQuery('SELECT id, description, imc FROM imcList');
    for (var element in result) {
      imcList.add(ImcModel(id: int.parse( element["id"].toString()), description: element["description"].toString(), imc: element["imc"].toString()));
    }
    return imcList;
  }

  Future<void> addImc(ImcModel imcModel) async {
    var db = await SQLiteDataBase().getDataBase();
    await db.rawInsert(
      'INSERT INTO imcList (description, imc) values(?,?)',
      [imcModel.description, imcModel.imc],
    );
  }

  Future<void> removeImc(String id) async {
    var db = await SQLiteDataBase().getDataBase();
    await db.rawInsert('DELETE FROM imcList WHERE id = ?', [id]);
  }
}
