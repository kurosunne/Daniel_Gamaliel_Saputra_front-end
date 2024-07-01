class Kategori {
  final int id;
  final String namaKategori;

  final String createdAt;
  final String? updatedAt;

  Kategori({
    required this.id,
    required this.namaKategori,
    required this.createdAt,
    this.updatedAt,
  });

  factory Kategori.fromSqfliteDatabase(Map<String, dynamic> map) => Kategori(
        id: map['id'] as int,
        namaKategori: map['nama_kategori'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
            .toIso8601String(),
        updatedAt: map['updated_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int)
                .toIso8601String(),
      );
}
