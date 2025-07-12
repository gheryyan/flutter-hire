import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/lamaran.dart';
import '../models/lowongan.dart';
import '../models/mahasiswa.dart';
import '../models/profil.dart';


class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() => _instance;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'lamaran.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE lowongan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        company TEXT,
        location TEXT,
        detail TEXT
      )
    ''');

      await db.execute('''
    CREATE TABLE profil (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nama TEXT,
      email TEXT,
      noHp TEXT,
      kampus TEXT,
      pengalamanKerja TEXT,
      mahasiswa_id INTEGER

    )
  ''');
    await db.execute('''
  CREATE TABLE lamaran (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_lowongan INTEGER,
    mahasiswa_id INTEGER,
    nama_mahasiswa TEXT,
    status TEXT,
    title TEXT,
    company TEXT,
    location TEXT,
    FOREIGN KEY (id_lowongan) REFERENCES lowongan(id)
    )
''');

    await db.execute('''
  CREATE TABLE mahasiswa (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT,
    password TEXT,
    nama TEXT,
    noHp TEXT,
    kampus TEXT,
    pengalamanKerja TEXT
  )
''');
  }

  Future<int> insertLamaran(Lamaran lamaran) async {
    final db = await database;
    return await db.insert('lamaran', lamaran.toMap());
  }

  Future<List<Lamaran>> getLamaranByMahasiswaId(int mahasiswaId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
  SELECT lamaran.id, lamaran.id_lowongan, lamaran.mahasiswa_id, lamaran.nama_mahasiswa, lamaran.status,
         lowongan.title, lowongan.company, lowongan.location
  FROM lamaran
  JOIN lowongan ON lamaran.id_lowongan = lowongan.id
  WHERE lamaran.mahasiswa_id = ?
''', [mahasiswaId]);


    return List.generate(maps.length, (i) => Lamaran.fromMap(maps[i]));
  }

  Future<List<Lamaran>> getAllLamaran() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT lamaran.*, lowongan.title, lowongan.company, lowongan.location
    FROM lamaran
    JOIN lowongan ON lamaran.id_lowongan = lowongan.id
  ''');

    return List.generate(maps.length, (i) => Lamaran.fromMap(maps[i]));
  }




  Future<int> deleteLamaran(int id) async {
    final db = await database;
    return await db.delete('lamaran', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> insertProfil(ProfilMahasiswa profil) async {
    final db = await database;
    return await db.insert('profil', profil.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<ProfilMahasiswa?> getProfil() async {
    final db = await database;
    final maps = await db.query('profil');
    if (maps.isNotEmpty) {
      return ProfilMahasiswa.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateProfil(ProfilMahasiswa profil) async {
    final db = await database;
    return await db.update('profil', profil.toMap(), where: 'id = ?', whereArgs: [profil.id]);
  }
  Future<int> insertLowongan(Lowongan lowongan) async {
    final db = await database;
    return await db.insert('lowongan', lowongan.toMap());
  }

  Future<List<Lowongan>> getAllLowongan() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('lowongan');
    return List.generate(maps.length, (i) => Lowongan.fromMap(maps[i]));
  }

  Future<int> updateStatusLamaran(int id, String status) async {
    final db = await database;
    return await db.update(
      'lamaran',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<int> updateLowongan(Lowongan lowongan) async {
    final db = await database;
    return await db.update(
      'lowongan',
      lowongan.toMap(),
      where: 'id = ?',
      whereArgs: [lowongan.id],
    );
  }
  Future<int> deleteLowongan(int id) async {
    final db = await database;
    return await db.delete('lowongan', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> sudahApply(int idLowongan, int mahasiswaId) async {
    final db = await database;
    final result = await db.query(
      'lamaran',
      where: 'id_lowongan = ? AND mahasiswa_id = ?',
      whereArgs: [idLowongan, mahasiswaId],
    );
    return result.isNotEmpty;
  }


  Future<Mahasiswa?> loginMahasiswa(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'mahasiswa',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return Mahasiswa.fromMap(result.first);
    }
    return null;
  }
  Future<void> insertDummyMahasiswa() async {
    final db = await database;
    await db.insert('mahasiswa', {
      'email': 'mahasiswa1@example.com',
      'password': '123456',
      'nama': 'Budi Mahasiswa',
      'noHp': '081234567890',
      'kampus': 'Universitas Contoh',
      'pengalamanKerja': 'Magang di Startup X'
    });
  }

  Future<int> insertMahasiswa(Mahasiswa mahasiswa) async {
    final db = await database;
    return await db.insert('mahasiswa', mahasiswa.toMap());
  }

  Future<ProfilMahasiswa?> getProfilByMahasiswaId(int id) async {
    final db = await database;
    final result = await db.query(
      'profil',
      where: 'mahasiswa_id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return ProfilMahasiswa.fromMap(result.first);
    }
    return null;
  }


}
