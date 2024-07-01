import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tes_coding/databases/database_service.dart';
import 'package:tes_coding/extension/num_extension.dart';
import 'package:tes_coding/getx/barang_getx.dart';
import 'package:tes_coding/getx/kategori.getx.dart';
import 'package:tes_coding/widgets/detail_bottom_sheet.dart';

class SearchListBarangPage extends StatefulWidget {
  static const String routeName = '/search_list_barang';
  const SearchListBarangPage({super.key});

  @override
  State<SearchListBarangPage> createState() => _SearchListBarangPageState();
}

class _SearchListBarangPageState extends State<SearchListBarangPage> {
  late final Database db;
  final TextEditingController _searchController = TextEditingController();

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: SizedBox(
              height: 40,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchController.text = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Cari barang",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${barang.barang.length} data ditampilkan",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 4),
                            GetBuilder<KategoriGetx>(
                              init: KategoriGetx(),
                              builder: (kategori) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 250,
                                  child: ListView.builder(
                                    itemCount: barang.barang.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      if (_searchController.text.isNotEmpty) {
                                        if (!barang.barang[index].namaBarang
                                            .toLowerCase()
                                            .contains(_searchController.text
                                                .toLowerCase())) {
                                          return const SizedBox();
                                        }
                                      }

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
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(kategori.kategori
                                                      .where((element) =>
                                                          element.id ==
                                                          barang.barang[index]
                                                              .kategoriId)
                                                      .first
                                                      .namaKategori),
                                                  Text(barang.barang[index]
                                                      .kelompokBarang),
                                                ],
                                              ),
                                              trailing: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Stok : ${barang.barang[index].stok}",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    barang.barang[index].harga
                                                        .formatIDR(2),
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
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
                                Icon(Icons.refresh, color: Colors.blue),
                                SizedBox(width: 4),
                                Text("Refresh untuk melihat data lainya",
                                    style: TextStyle(color: Colors.blue)),
                              ],
                            ),
                          ],
                        );
                      }),
                );
              },
            ),
          )),
    );
  }
}
