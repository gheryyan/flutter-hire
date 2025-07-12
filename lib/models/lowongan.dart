class Lowongan {
  int? id;
  String title;
  String company;
  String location;
  final String detail;

  Lowongan({
    this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.detail
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'company': company,
      'location': location,
      'detail': detail
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Lowongan.fromMap(Map<String, dynamic> map) {
    return Lowongan(
      id: map['id'],
      title: map['title'],
      company: map['company'],
      location: map['location'],
      detail: map['detail'],
    );
  }
}
