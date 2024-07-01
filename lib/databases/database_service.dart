import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tes_coding/databases/barang_db.dart';
import 'package:tes_coding/databases/kategori_db.dart';

class DatabaseService {
  static Database? _database;
  static final KategoriDB _kategoriDB = KategoriDB();
  static final BarangDB _barangDB = BarangDB();

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  static Future<String> get fullPath async {
    return join(await getDatabasesPath(), 'siscom.db');
  }

  static Future<Database> _initialize() async {
    final path = await fullPath;
    return openDatabase(path,
        version: 1, onCreate: _create, singleInstance: true);
  }

  static Future<void> _create(Database db, int version) async {
    await _kategoriDB.createTable(db);
    await _barangDB.createTable(db);
    await _kategoriDB.insert(db, namaKategori: 'Makanan');
    await _kategoriDB.insert(db, namaKategori: 'Minuman');
    await _barangDB.insert(db,
        namaBarang: "Mie Instan Goreng",
        kategoriId: 1,
        stok: 10,
        kelompokBarang: "Mie",
        harga: 4000);
    await _barangDB.insert(db,
        namaBarang: "Keripik Kentang",
        kategoriId: 1,
        stok: 4,
        kelompokBarang: "Snack",
        harga: 12000);
    await _barangDB.insert(db,
        namaBarang: "Es Buah",
        kategoriId: 2,
        stok: 5,
        kelompokBarang: "Minuman Segar",
        harga: 8000);
    await _barangDB.insert(db,
        namaBarang: "Americano",
        kategoriId: 2,
        stok: 5,
        kelompokBarang: "Kopi",
        harga: 10000);
  }
}
