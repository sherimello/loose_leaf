import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Database? _database;

  initDB() async {
    var db = openDatabase(join(await getDatabasesPath(), "notes.db"),
        onCreate: (db, version) async{
      await db.rawQuery(
          "CREATE TABLE IF NOT EXISTS notes (id INTEGER PRIMARY KEY, title TEXT, note TEXT)");
    }, version: 1);

    _database = await db;
  }

  Database get database => _database!;

  insertData(Database database, String title, String note) async{
    // await initDB();
    await database.rawQuery("INSERT INTO notes (title, note) VALUES(?,?)", [title, note]);

  }

  fetchNotes(Database database) async{
    List<Map<String, Object?>>? data = await database.rawQuery("SELECT * FROM notes");
    print(data);
    return data;
  }
  
  deleteNote(Database database, int id) async{
    database.rawDelete("DELETE FROM notes WHERE id = ?", [id]);
  }

}
