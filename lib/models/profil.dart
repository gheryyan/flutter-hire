class ProfilMahasiswa {
  final int? id;
  final String nama;
  final String email;
  final String noHp;
  final String kampus;
  final String pengalamanKerja;
  final int? mahasiswaId;


  ProfilMahasiswa({
    this.id,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.kampus,
    required this.pengalamanKerja,
    this.mahasiswaId
  });

  factory ProfilMahasiswa.fromMap(Map<String, dynamic> map) {
    return ProfilMahasiswa(
      id: map['id'],
      nama: map['nama'],
      email: map['email'],
      noHp: map['noHp'],
      kampus: map['kampus'],
      pengalamanKerja: map['pengalamanKerja'],
      mahasiswaId: map['mahasiswa_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'noHp': noHp,
      'kampus': kampus,
      'pengalamanKerja': pengalamanKerja,
      'mahasiswa_id':mahasiswaId
    };
  }
}
