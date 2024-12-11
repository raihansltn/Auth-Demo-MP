class Mahasiswa {
  int? id;
  String nim;
  String nama;
  String prodi;
  String email;

  Mahasiswa(
      {this.id,
      required this.nim,
      required this.nama,
      required this.email,
      required this.prodi});

  // Func to change JSON data to object Mahasiswa
  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
        id: json['id'] is String ? int.tryParse(json['id']) : json['id'],
        nama: json['nama'],
        nim: json['nim'],
        email: json['email'],
        prodi: json['prodi']);
  }
  // Fungsi untuk mengubah objek Mahasiswa menjadi format JSON
  Map<String, dynamic> toJson() {
    return {'nama': nama, 'nim': nim, 'email': email, 'prodi': prodi};
  }
}
