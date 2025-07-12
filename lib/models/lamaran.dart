class Lamaran {
  final int? id;
  final int idLowongan;
  final int mahasiswaId;
  final String namaMahasiswa;
  final String status;

  // Sementara tambahkan manual (dummy)
  final String? title;
  final String? company;
  final String? location;

  Lamaran({
    this.id,
    required this.idLowongan,
    required this.mahasiswaId,
    required this.namaMahasiswa,
    required this.status,
    this.title,
    this.company,
    this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_lowongan': idLowongan,
      'nama_mahasiswa': namaMahasiswa,
      'mahasiswa_id': mahasiswaId,
      'status': status,
      'title': title,
      'company': company,
      'location': location,
    };
  }

  factory Lamaran.fromMap(Map<String, dynamic> map) {
    return Lamaran(
      id: map['id'],
      idLowongan: map['id_lowongan'],
      mahasiswaId: map['mahasiswa_id'],
      namaMahasiswa: map['nama_mahasiswa'],
      status: map['status'],
      title: map['title'], // jika nanti join table
      company: map['company'],
      location: map['location'],
    );
  }
}

