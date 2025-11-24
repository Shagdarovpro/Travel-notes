import '../models/travel.dart';
import 'app_database.dart';

class TravelDAO {
  final AppDatabase _db = AppDatabase.instance;

  Future<int> insertTravel(Travel travel) async {
    final db = await _db.database;
    return await db.insert('travels', travel.toMap());
  }

  Future<List<Travel>> getAllTravels() async {
    final db = await _db.database;
    final result = await db.query('travels', orderBy: 'date DESC');
    return result.map((e) => Travel.fromMap(e)).toList();
  }

  Future<int> updateTravel(Travel travel) async {
    final db = await _db.database;
    return await db.update(
      'travels',
      travel.toMap(),
      where: 'id = ?',
      whereArgs: [travel.id],
    );
  }

  Future<int> deleteTravel(int id) async {
    final db = await _db.database;
    return await db.delete('travels', where: 'id = ?', whereArgs: [id]);
  }
}
