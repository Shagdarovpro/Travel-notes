import '../../db/travel_dao.dart';
import '../../../models/travel.dart';

class TravelRepository {
  final TravelDAO _dao = TravelDAO();

  Future<List<Travel>> getAllTravels() async {
    return await _dao.getAllTravels();
  }

  Future<void> addTravel(Travel travel) async {
    await _dao.insertTravel(travel);
  }

  Future<void> updateTravel(Travel travel) async {
    await _dao.updateTravel(travel);
  }

  Future<void> deleteTravel(int id) async {
    await _dao.deleteTravel(id);
  }
}
