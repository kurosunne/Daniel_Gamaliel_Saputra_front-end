import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:tes_coding/databases/database_service.dart';
import 'package:tes_coding/pages/add_barang.dart';
import 'package:tes_coding/pages/edit_barang.dart';
import 'package:tes_coding/pages/list_barang.dart';
import 'package:tes_coding/pages/search_list_barang.dart';

void main() async {
  runApp(const MyApp());
  final Database db = await DatabaseService.database;
  db.database;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Siscom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF001767),
            background: Colors.white,
            error: Colors.red.shade600),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
        useMaterial3: true,
      ),
      initialRoute: ListBarangPage.routeName,
      routes: {
        ListBarangPage.routeName: (context) => const ListBarangPage(),
        SearchListBarangPage.routeName: (context) =>
            const SearchListBarangPage(),
        AddBarangPage.routeName: (context) => const AddBarangPage(),
        EditBarangPage.routeName: (context) => EditBarangPage(
              args: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>,
            ),
      },
    );
  }
}
