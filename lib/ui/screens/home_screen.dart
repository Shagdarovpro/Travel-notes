import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/travel_provider.dart';
import 'add_trip_screen.dart';
import 'trip_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Загружаем поездки при инициализации
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<TravelProvider>().loadTravels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TravelProvider>();
    final travels = _searchController.text.isEmpty
        ? provider.travels
        : provider.search(_searchController.text);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Поиск (город или страна)',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (_) => setState(() {}),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'date') {
                provider.sortByDate(); // метод в TravelProvider
              } else if (value == 'rating') {
                provider.sortByRating(); // метод в TravelProvider
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'date', child: Text('Сортировать по дате')),
              PopupMenuItem(value: 'rating', child: Text('Сортировать по рейтингу')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddTripScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: travels.isEmpty
          ? const Center(child: Text('Пока нет поездок'))
          : ListView.builder(
              itemCount: travels.length,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemBuilder: (_, index) {
                final trip = travels[index];
                return Dismissible(
                  key: ValueKey(trip.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (_) async {
                    if (trip.id != null) {
                      await provider.deleteTravel(trip.id!);
                    }
                  },
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TripDetailScreen(trip: trip)),
                    ),
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (trip.imagePath != null)
                            Hero(
                              tag: trip.id!,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.file(File(trip.imagePath!), height: 160, width: double.infinity, fit: BoxFit.cover),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${trip.city}, ${trip.country}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text("${trip.date.toLocal().toString().split(' ')[0]} — ⭐ ${trip.rating}"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
