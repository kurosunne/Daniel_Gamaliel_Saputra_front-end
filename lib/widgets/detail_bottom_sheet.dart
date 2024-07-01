import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tes_coding/classes/Barang.dart';
import 'package:tes_coding/classes/Kategori.dart';
import 'package:tes_coding/databases/barang_db.dart';
import 'package:tes_coding/extension/num_extension.dart';
import 'package:tes_coding/getx/barang_getx.dart';
import 'package:tes_coding/pages/edit_barang.dart';

class DetailBottomSheet extends StatefulWidget {
  final Barang barang;
  final Kategori kategori;
  final Database db;
  const DetailBottomSheet(
      {super.key,
      required this.barang,
      required this.kategori,
      required this.db});

  @override
  State<DetailBottomSheet> createState() => _DetailBottomSheetState();
}

class _DetailBottomSheetState extends State<DetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 6,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(15)),
                ),
                const SizedBox(
                  height: 10,
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'asset/placeholder.jpg',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Nama barang",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              widget.barang.namaBarang,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Kategori",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              widget.kategori.namaKategori,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Kelompok",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              widget.barang.kelompokBarang,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Stok",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              widget.barang.stok.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blueGrey.shade50,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Harga",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          widget.barang.harga.formatIDR(2),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: GetBuilder<BarangGetx>(
                        init: BarangGetx(),
                        builder: (barang) {
                          return MaterialButton(
                              onPressed: () async {
                                await BarangDB()
                                    .delete(widget.db, widget.barang.id);
                                barang.deleteBarang(widget.barang.id);
                                barang.fetchLocalBarang();

                                if (!context.mounted) return;
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.error)),
                              textColor: Theme.of(context).colorScheme.error,
                              child: const Text("Hapus Barang"));
                        }),
                  ),
                  SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: MaterialButton(
                        onPressed: () {
                          Map<String, dynamic> args = {
                            "barang": widget.barang,
                            "kategori": widget.kategori,
                          };

                          Navigator.pop(context);
                          Navigator.pushNamed(context, EditBarangPage.routeName,
                              arguments: args);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.background,
                        child: const Text("Edit Barang")),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
