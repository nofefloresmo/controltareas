import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Conexion {
  static Future<Database> openDB() async {
    Database db = await openDatabase(
      join(await getDatabasesPath(), 'practica1.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('PRAGMA foreign_keys = ON;');
        return await script(db);
      },
    );
    await db.execute('PRAGMA foreign_keys = ON;');
    return db;
  }

  static Future<void> script(Database db) async {
    await db.execute(
        'CREATE TABLE MATERIA (IDMATERIA TEXT PRIMARY KEY, NOMBRE TEXT NOT NULL, SEMESTRE TEXT NOT NULL, DOCENTE TEXT NOT NULL)');
    await db.execute(
        'CREATE TABLE TAREA (IDTAREA INTEGER PRIMARY KEY AUTOINCREMENT, IDMATERIA TEXT NOT NULL, FENTREGA TEXT NOT NULL, DESCRIPCION TEXT NOT NULL, FOREIGN KEY (IDMATERIA) REFERENCES MATERIA(IDMATERIA) ON DELETE CASCADE ON UPDATE CASCADE)');
  }

  static Future<void> closeDB(Database db) async {
    await db.close();
  }

  static Future<void> deleteDB() async {
    await deleteDatabase(join(await getDatabasesPath(), 'practica1.db'));
  }
}
