class Mahasiswa {
  final int? id;
  final String email;
  final String password;
  final String nama;
  final String noHp;
  final String kampus;
  final String pengalamanKerja;

  Mahasiswa({
    this.id,
    required this.email,
    required this.password,
    required this.nama,
    required this.noHp,
    required this.kampus,
    required this.pengalamanKerja,
  });
  Mahasiswa.minimal({
    required this.email,
    required this.password,
  })  : id = null,
        nama = '',
        noHp = '',
        kampus = '',
        pengalamanKerja = '';

  factory Mahasiswa.fromMap(Map<String, dynamic> map) {
    return Mahasiswa(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      nama: map['nama'],
      noHp: map['noHp'],
      kampus: map['kampus'],
      pengalamanKerja: map['pengalamanKerja'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'nama': nama,
      'noHp': noHp,
      'kampus': kampus,
      'pengalamanKerja': pengalamanKerja,
    };
  }
}
