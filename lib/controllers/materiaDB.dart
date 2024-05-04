import '../models/materia.dart';
import 'conexion.dart';
import 'package:sqflite/sqflite.dart';

class MateriaDB {
  static Future<int> insertMateria(Materia m) async {
    final Database db = await Conexion.openDB();
    return await db.insert(
      'MATERIA',
      m.toJson(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  static Future<List<Materia>> getMaterias() async {
    final Database db = await Conexion.openDB();
    final List<Map<String, dynamic>> maps = await db.query('MATERIA');
    return List.generate(maps.length, (i) {
      return Materia(
        idMateria: maps[i]['IDMATERIA'],
        nombre: maps[i]['NOMBRE'],
        semestre: maps[i]['SEMESTRE'],
        docente: maps[i]['DOCENTE'],
      );
    });
  }

  static Future<int> updateMateria(Materia m) async {
    final Database db = await Conexion.openDB();
    return await db.update(
      'MATERIA',
      m.toJson(),
      where: 'IDMATERIA = ?',
      whereArgs: [m.idMateria],
    );
  }

  static Future<int> deleteMateria(String idMateria) async {
    final Database db = await Conexion.openDB();
    return await db.delete(
      'MATERIA',
      where: 'IDMATERIA = ?',
      whereArgs: [idMateria],
    );
  }
}
