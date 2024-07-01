import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tes_coding/classes/Kategori.dart';
import 'package:tes_coding/databases/database_service.dart';
import 'package:tes_coding/databases/kategori_db.dart';

class KategoriGetx extends GetxController {
  late final Database db;
  List<Kategori> kategori = [];

  @override
  void onInit() async {
    super.onInit();
    db = await DatabaseService.database;
    KategoriDB().fetchAll(db).then((value) {
      addMultipleKategori(value);
    });
  }

  void addMultipleKategori(List<Kategori> kategori) {
    kategori.forEach((element) {
      this.kategori.add(element);
    });
    update();
  }

  void addKategori(Kategori kategori) {
    this.kategori.add(kategori);
    update();
  }
}
