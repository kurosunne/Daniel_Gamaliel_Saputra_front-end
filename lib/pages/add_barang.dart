import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tes_coding/classes/Barang.dart';
import 'package:tes_coding/databases/barang_db.dart';
import 'package:tes_coding/databases/database_service.dart';
import 'package:tes_coding/extension/num_extension.dart';
import 'package:tes_coding/getx/barang_getx.dart';
import 'package:tes_coding/getx/kategori.getx.dart';
import 'package:tes_coding/widgets/custom_dropdown.dart';
import 'package:tes_coding/widgets/custom_textfield.dart';
import 'package:tes_coding/widgets/loading.dart';

class AddBarangPage extends StatefulWidget {
  static const String routeName = '/add_barang';
  const AddBarangPage({super.key});

  @override
  State<AddBarangPage> createState() => _AddBarangPageState();
}

class _AddBarangPageState extends State<AddBarangPage> {
  final TextEditingController _namaBarangController = TextEditingController();
  final TextEditingController _kategoriBarangController =
      TextEditingController();
  final TextEditingController _kelompokBarangController =
      TextEditingController();
  final TextEditingController _stokBarangController = TextEditingController();
  final TextEditingController _hargaBarangController = TextEditingController();

  int _selectedKategori = -1;
  num _hargaBarang = 0;

  final List<DropdownMenuEntry> _kelompokList = const [
    DropdownMenuEntry(value: "Mie", label: "Mie"),
    DropdownMenuEntry(value: "Snack", label: "Snack"),
    DropdownMenuEntry(value: "Minuman Segar", label: "Minuman Segar"),
    DropdownMenuEntry(value: "Kopi", label: "Kopi")
  ];

  late final Database db;

  bool _buttonPressed = false;
  bool _isLoading = false;

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
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tambah Barang"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextfield(
                      title: "Nama Barang",
                      controller: _namaBarangController,
                      keyboardType: TextInputType.text,
                      buttonPressed: _buttonPressed,
                      onChanged: (value) {},
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    GetBuilder<KategoriGetx>(
                      init: KategoriGetx(),
                      builder: (kategori) {
                        return CustomDropdown(
                            title: "Kategori Barang",
                            dropdownMenuEntries: kategori.kategori
                                .map((e) => DropdownMenuEntry(
                                    value: e.id, label: e.namaKategori))
                                .toList(),
                            controller: _kategoriBarangController,
                            onChange: (value) {
                              _selectedKategori = value;
                            },
                            buttonPressed: _buttonPressed);
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomDropdown(
                        title: "Kelompok Barang",
                        dropdownMenuEntries: _kelompokList,
                        controller: _kelompokBarangController,
                        onChange: (value) {},
                        buttonPressed: _buttonPressed),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextfield(
                      title: "Stok",
                      controller: _stokBarangController,
                      keyboardType: TextInputType.number,
                      buttonPressed: _buttonPressed,
                      onChanged: (value) {},
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextfield(
                      title: "Harga",
                      controller: _hargaBarangController,
                      keyboardType: TextInputType.number,
                      buttonPressed: _buttonPressed,
                      onChanged: (value) {
                        String temp = value;
                        if (temp.contains("Rp")) {
                          temp = temp.substring(3);
                        }

                        _hargaBarang =
                            num.parse(temp.replaceAll(RegExp('[^0-9]'), ''));

                        _hargaBarangController.text =
                            (_hargaBarang).formatIDR(0);
                      },
                    ),
                    const SizedBox(
                      height: 64,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: GetBuilder<BarangGetx>(
                      builder: (barang) {
                        return MaterialButton(
                          onPressed: () async {
                            setState(() {
                              _buttonPressed = true;
                            });

                            if (_namaBarangController.text.isEmpty ||
                                _kategoriBarangController.text.isEmpty ||
                                _kelompokBarangController.text.isEmpty ||
                                _stokBarangController.text.isEmpty ||
                                _hargaBarang <= 0) {
                              return;
                            }

                            await BarangDB().insert(
                              db,
                              namaBarang: _namaBarangController.text,
                              kategoriId: _selectedKategori,
                              stok: int.parse(_stokBarangController.text),
                              kelompokBarang: _kelompokBarangController.text,
                              harga: _hargaBarang,
                            );

                            Barang temp = await BarangDB().fetchLatest(db);
                            barang.addBarang(temp);

                            setState(() {
                              _isLoading = false;
                            });

                            if (!context.mounted) return;
                            Navigator.pop(context);
                          },
                          color: Theme.of(context).colorScheme.primary,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text("Tambah Barang"),
                        );
                      },
                    ),
                  ),
                ),
              ),
              _isLoading ? const Loading() : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
