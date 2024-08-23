class SampahData {
  final int id;
  final String namaUpt;
  final String name;
  final String noHp;
  final String status;
  final String fotoSampah;
  final String deskripsi;
  final Alamat alamat;

  SampahData({
    required this.id,
    required this.namaUpt,
    required this.name,
    required this.noHp,
    required this.status,
    required this.fotoSampah,
    required this.deskripsi,
    required this.alamat,
  });

  factory SampahData.fromJson(Map<String, dynamic> json) {
    return SampahData(
      id: json['id'],
      namaUpt: json['upt']['nama_upt'],
      name: json['warga']['nama'],
      noHp: json['warga']['no_hp'],
      status: json['status'],
      fotoSampah: json['foto_sampah'],
      deskripsi: json['deskripsi'],
      alamat: Alamat.fromJson(json['warga']['alamat'][0]),
    );
  }
}

class Alamat {
  final String kelurahan;
  final String kecamatan;
  final String deskripsi;
  final String kordinat;

  Alamat({
    required this.kelurahan,
    required this.kecamatan,
    required this.deskripsi,
    required this.kordinat,
  });

  factory Alamat.fromJson(Map<String, dynamic> json) {
    return Alamat(
      kelurahan: json['kelurahan'],
      kecamatan: json['kecamatan'],
      deskripsi: json['deskripsi'],
      kordinat: json['kordinat'],
    );
  }
}
