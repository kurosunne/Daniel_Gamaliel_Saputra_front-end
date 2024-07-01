class Barang {
  final int id;
  String namaBarang;
  int kategoriId;
  int stok;
  String kelompokBarang;
  num harga;

  final String createdAt;
  final String? updatedAt;

  Barang({
    required this.id,
    required this.namaBarang,
    required this.kategoriId,
    required this.stok,
    required this.kelompokBarang,
    required this.harga,
    required this.createdAt,
    this.updatedAt,
  });

  factory Barang.fromSqfliteDatabase(Map<String, dynamic> map) => Barang(
        id: map['id'] as int,
        namaBarang: map['nama_barang'] as String,
        kategoriId: map['kategori_id'] as int,
        stok: map['stok'] as int,
        kelompokBarang: map['kelompok_barang'] as String,
        harga: map['harga'] as num,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
            .toIso8601String(),
        updatedAt: map['updated_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int)
                .toIso8601String(),
      );
}
