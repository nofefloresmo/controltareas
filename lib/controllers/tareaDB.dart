import '../models/tarea.dart';
import 'conexion.dart';
import 'package:sqflite/sqflite.dart';

class TareaDB {
  static Future<int> insertTarea(Tarea t) async {
    final Database db = await Conexion.openDB();
    return await db.insert(
      'TAREA',
      t.toJson(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  static Future<List<Tarea>> getTareas() async {
    final Database db = await Conexion.openDB();
    final List<Map<String, dynamic>> maps = await db.query('TAREA');
    return List.generate(maps.length, (i) {
      return Tarea(
        idTarea: maps[i]['IDTAREA'],
        idMateria: maps[i]['IDMATERIA'],
        fEntrega: maps[i]['F_ENTREGA'],
        descripcion: maps[i]['DESCRIPCION'],
      );
    });
  }

  static Future<List<Tarea>> getTareasByMateria(String idMateria) async {
    final Database db = await Conexion.openDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'TAREA',
      where: 'IDMATERIA = ?',
      whereArgs: [idMateria],
    );
    return List.generate(maps.length, (i) {
      return Tarea(
        idTarea: maps[i]['IDTAREA'],
        idMateria: maps[i]['IDMATERIA'],
        fEntrega: maps[i]['F_ENTREGA'],
        descripcion: maps[i]['DESCRIPCION'],
      );
    });
  }

  static Future<int> updateTarea(Tarea t) async {
    final Database db = await Conexion.openDB();
    return await db.update(
      'TAREA',
      t.toJson(),
      where: 'IDTAREA = ?',
      whereArgs: [t.idTarea],
    );
  }

  static Future<int> deleteTarea(int idTarea) async {
    final Database db = await Conexion.openDB();
    return await db.delete(
      'TAREA',
      where: 'IDTAREA = ?',
      whereArgs: [idTarea],
    );
  }
}
