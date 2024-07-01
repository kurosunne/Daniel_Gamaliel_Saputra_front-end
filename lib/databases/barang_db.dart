import 'package:sqflite/sqflite.dart';
import 'package:tes_coding/classes/Barang.dart';
import 'package:tes_coding/databases/database_service.dart';

class BarangDB {
  final tableName = 'barang';

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "nama_barang" TEXT,
        "kategori_id" INTEGER,
        "stok" INTEGER,
        "kelompok_barang" TEXT,
        "harga" REAL,
        "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s','now') as int)),
        "updated_at" INTEGER
      );
    ''');
  }

  Future<void> insert(Database db,
      {required String namaBarang,
      required int kategoriId,
      required int stok,
      required String kelompokBarang,
      required num harga}) async {
    await db.insert(tableName, {
      'nama_barang': namaBarang,
      'kategori_id': kategoriId,
      'stok': stok,
      'kelompok_barang': kelompokBarang,
      'harga': harga,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Barang>> fetchAll(Database db) async {
    final result = await db.query(tableName, orderBy: 'created_at asc');
    return result.map((e) => Barang.fromSqfliteDatabase(e)).toList();
  }

  Future<Barang> fetchLatest(Database db) async {
    final result = await db.query(tableName, orderBy: 'id DESC', limit: 1);
    return Barang.fromSqfliteDatabase(result.first);
  }

  Future<void> delete(Database db, int id) async {
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> update(Database db,
      {required int id,
      required String namaBarang,
      required int kategoriId,
      required int stok,
      required String kelompokBarang,
      required num harga}) async {
    await db.update(
        tableName,
        {
          'nama_barang': namaBarang,
          'kategori_id': kategoriId,
          'stok': stok,
          'kelompok_barang': kelompokBarang,
          'harga': harga,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [id]);
  }
}
