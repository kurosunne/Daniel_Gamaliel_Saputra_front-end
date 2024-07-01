import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tes_coding/classes/Barang.dart';
import 'package:tes_coding/databases/barang_db.dart';
import 'package:tes_coding/databases/database_service.dart';

class BarangGetx extends GetxController {
  late final Database db;
  List<Barang> barang = [];

  @override
  void onInit() async {
    super.onInit();
    db = await DatabaseService.database;
    fetchLocalBarang();
  }

  void addMultipleBarang(List<Barang> barang) {
    barang.forEach((element) {
      this.barang.add(element);
    });
    update();
  }

  void addBarang(Barang barang) {
    this.barang.add(barang);
    update();
  }

  void fetchLocalBarang() async {
    BarangDB().fetchAll(db).then((value) {
      barang = value;
      update();
    });
  }

  void deleteBarang(int id) {
    barang.removeWhere((element) => element.id == id);
    update();
  }

  void updateBarang(Barang barang) {
    final temp = this.barang.indexWhere((element) => element.id == barang.id);
    this.barang[temp] = barang;
    update();
  }
}
