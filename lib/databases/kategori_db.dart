import 'package:sqflite/sqflite.dart';
import 'package:tes_coding/classes/Kategori.dart';
import 'package:tes_coding/databases/database_service.dart';

class KategoriDB {
  final tableName = 'kategori';

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "nama_kategori" TEXT,
        "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s','now') as int)),
        "updated_at" INTEGER
      );
    ''');
  }

  Future<void> insert(Database db, {required String namaKategori}) async {
    await db.insert(tableName, {
      'nama_kategori': namaKategori,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Kategori>> fetchAll(Database db) async {
    final result = await db.query(tableName, orderBy: 'created_at DESC');
    return result.map((e) => Kategori.fromSqfliteDatabase(e)).toList();
  }
}
