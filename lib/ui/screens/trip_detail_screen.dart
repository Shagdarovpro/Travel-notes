import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/travel.dart';
import '../../providers/travel_provider.dart';
import 'add_trip_screen.dart';

class TripDetailScreen extends StatelessWidget {
  final Travel trip;
  const TripDetailScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final prov = context.read<TravelProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('${trip.city}, ${trip.country}'),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTripScreen(trip: trip)))),
          IconButton(icon: const Icon(Icons.delete), onPressed: () async {
            final confirm = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: const Text('Удалить поездку?'), actions: [TextButton(onPressed: ()=>Navigator.pop(context,false), child: const Text('Отмена')), TextButton(onPressed: ()=>Navigator.pop(context,true), child: const Text('Удалить'))]));
            if (confirm == true) {
              if (trip.id != null) await prov.deleteTravel(trip.id!);
              if (context.mounted) Navigator.pop(context);
            }
          })
        ],
      ),
      body: ListView(
        children: [
          if (trip.imagePath != null) Hero(tag: trip.id!, child: Image.file(File(trip.imagePath!), height: 260, width: double.infinity, fit: BoxFit.cover)),
          Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${trip.city}, ${trip.country}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Дата: ${trip.date.toLocal().toString().split(' ')[0]}'),
            const SizedBox(height: 8),
            Text('Рейтинг: ${trip.rating}'),
            const SizedBox(height: 12),
            Text('Описание:', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(trip.description),
          ]))
        ],
      ),
    );
  }
}
