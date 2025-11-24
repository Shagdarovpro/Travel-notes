import 'package:flutter/material.dart';
import '../models/travel.dart';
import '../data/repositories/travel_repository.dart';

class TravelProvider extends ChangeNotifier {
  final TravelRepository _repo = TravelRepository();

  List<Travel> _travels = [];
  List<Travel> get travels => _travels;

  TravelProvider() {
    loadTravels();
  }

  /// Загрузка всех поездок из базы
  Future<void> loadTravels() async {
    _travels = await _repo.getAllTravels();
    notifyListeners();
  }

  /// Добавление новой поездки
  Future<void> addTravel(Travel travel) async {
    await _repo.addTravel(travel);
    await loadTravels();
  }

  /// Обновление существующей поездки
  Future<void> updateTravel(Travel travel) async {
    await _repo.updateTravel(travel);
    await loadTravels();
  }

  /// Удаление поездки по ID
  Future<void> deleteTravel(int id) async {
    await _repo.deleteTravel(id);
    await loadTravels();
  }

  /// Сортировка по дате (по убыванию)
  void sortByDate() {
    _travels.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  /// Сортировка по рейтингу (по убыванию)
  void sortByRating() {
    _travels.sort((a, b) => b.rating.compareTo(a.rating));
    notifyListeners();
  }

  /// Поиск по городу или стране
  List<Travel> search(String query) {
    final q = query.toLowerCase();
    return _travels.where((t) =>
        t.city.toLowerCase().contains(q) ||
        t.country.toLowerCase().contains(q)
    ).toList();
  }
}
