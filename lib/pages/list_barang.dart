import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tes_coding/databases/barang_db.dart';
import 'package:tes_coding/databases/database_service.dart';
import 'package:tes_coding/extension/num_extension.dart';
import 'package:tes_coding/getx/barang_getx.dart';
import 'package:tes_coding/getx/kategori.getx.dart';
import 'package:tes_coding/pages/add_barang.dart';
import 'package:tes_coding/pages/search_list_barang.dart';
import 'package:tes_coding/widgets/detail_bottom_sheet.dart';

class ListBarangPage extends StatefulWidget {
  static const String routeName = '/list_barang';
  const ListBarangPage({super.key});

  @override
  State<ListBarangPage> createState() => _ListBarangPageState();
}

class _ListBarangPageState extends State<ListBarangPage> {
  late final Database db;
  bool _isEdit = false;
  List<bool> _isCheck = [];
  bool _isCheckedAll = false;

  @override
  void initState() {
    super.initState();
    initDB();
  }

  void initDB() async {
    db = await DatabaseService.database;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("List Stok Barang"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, SearchListBarangPage.routeName);
                },
                icon: const Icon(
                  Icons.search,
                  size: 30,
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GetBuilder<BarangGetx>(
            init: BarangGetx(),
            builder: (barang) {
              return LiquidPullToRefresh(
                animSpeedFactor: 3,
                onRefresh: () async {
                  barang.fetchLocalBarang();
                },
                child: ListView.builder(
                    itemCount: 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${barang.barang.length} data ditampilkan",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEdit = !_isEdit;
                                      _isCheck = List.generate(
                                          barang.barang.length,
                                          (index) => false);
                                      _isCheckedAll = false;
                                    });
                                  },
                                  child: Text(
                                    !_isEdit ? "Edit Data" : "Kembali",
                                    style: const TextStyle(color: Colors.blue),
                                  )),
                            ],
                          ),
                          const SizedBox(height: 4),
                          GetBuilder<KategoriGetx>(
                            init: KategoriGetx(),
                            builder: (kategori) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 260,
                                child: ListView.builder(
                                  itemCount: barang.barang.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return MaterialButton(
                                      onPressed: () {
                                        showModalBottomSheet<dynamic>(
                                            context: context,
                                            isScrollControlled: true,
                                            useSafeArea: true,
                                            builder: (context) {
                                              return DetailBottomSheet(
                                                barang: barang.barang[index],
                                                kategori: kategori.kategori
                                                    .where((element) =>
                                                        element.id ==
                                                        barang.barang[index]
                                                            .kategoriId)
                                                    .first,
                                                db: db,
                                              );
                                            });
                                      },
                                      child: Column(
                                        children: [
                                          ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              title: Text(barang
                                                  .barang[index].namaBarang),
                                              subtitle: Text(
                                                  "Stok: ${barang.barang[index].stok.toString()}"),
                                              trailing: Text(
                                                barang.barang[index].harga
                                                    .formatIDR(2),
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              leading: _isEdit
                                                  ? Checkbox(
                                                      value: _isCheck[index],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _isCheck[index] =
                                                              value!;
                                                          if (!_isCheck
                                                              .contains(
                                                                  false)) {
                                                            _isCheckedAll =
                                                                true;
                                                          } else {
                                                            _isCheckedAll =
                                                                false;
                                                          }
                                                        });
                                                      },
                                                    )
                                                  : null),
                                          const Divider(
                                            height: 1,
                                            thickness: 1,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_upward),
                              SizedBox(width: 4),
                              Text("Tarik untuk memuat data lainya"),
                            ],
                          ),
                        ],
                      );
                    }),
              );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              _isEdit
                  ? Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          Checkbox(
                              value: _isCheckedAll,
                              onChanged: (value) {
                                setState(() {
                                  _isCheckedAll = value!;
                                  _isCheck = List.generate(
                                      _isCheck.length, (index) => value);
                                });
                              }),
                          const Text("Pilih Semua")
                        ],
                      ),
                    )
                  : const SizedBox(),
              _isEdit
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: GetBuilder<BarangGetx>(
                            init: BarangGetx(),
                            builder: (barang) {
                              return MaterialButton(
                                onPressed: () async {
                                  _isCheck
                                      .asMap()
                                      .forEach((index, value) async {
                                    if (value) {
                                      if (_isCheck[index]) {
                                        await BarangDB().delete(
                                            db, barang.barang[index].id);
                                        barang.deleteBarang(
                                            barang.barang[index].id);
                                        barang.fetchLocalBarang();
                                      }
                                    }
                                  });

                                  setState(() {
                                    _isEdit = false;
                                    _isCheckedAll = false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error)),
                                child: Text("Hapus Barang",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error)),
                              );
                            }),
                      ),
                    )
                  : const SizedBox(),
              !_isEdit
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: 110,
                        height: 50,
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, AddBarangPage.routeName);
                          },
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add),
                              SizedBox(width: 4),
                              Text("Barang",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ));
  }
}
