import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/travel.dart';
import '../../providers/travel_provider.dart';

class AddTripScreen extends StatefulWidget {
  final Travel? trip;
  const AddTripScreen({super.key, this.trip});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cityC;
  late TextEditingController _countryC;
  late TextEditingController _descriptionC;
  int _rating = 3;
  DateTime _date = DateTime.now();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _cityC = TextEditingController(text: widget.trip?.city ?? '');
    _countryC = TextEditingController(text: widget.trip?.country ?? '');
    _descriptionC = TextEditingController(text: widget.trip?.description ?? '');
    _rating = widget.trip?.rating ?? 3;
    _date = widget.trip?.date ?? DateTime.now();
    _imagePath = widget.trip?.imagePath;
  }

  @override
  void dispose() {
    _cityC.dispose();
    _countryC.dispose();
    _descriptionC.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final p = ImagePicker();
    final picked = await p.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imagePath = picked.path);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final travel = Travel(
      id: widget.trip?.id,
      country: _countryC.text.trim(),
      city: _cityC.text.trim(),
      date: _date,
      rating: _rating,
      description: _descriptionC.text.trim(),
      imagePath: _imagePath,
    );

    final prov = context.read<TravelProvider>();
    if (widget.trip == null) {
      await prov.addTravel(travel);
    } else {
      await prov.updateTravel(travel);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.trip != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Редактировать' : 'Добавить поездку')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                child: _imagePath == null ? const Center(child: Text('Выбрать фото')) : ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(File(_imagePath!), fit: BoxFit.cover)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(controller: _countryC, decoration: const InputDecoration(labelText: 'Страна'), validator: (v) => v==null||v.isEmpty ? 'Введите страну' : null),
            const SizedBox(height: 12),
            TextFormField(controller: _cityC, decoration: const InputDecoration(labelText: 'Город'), validator: (v) => v==null||v.isEmpty ? 'Введите город' : null),
            const SizedBox(height: 12),
            TextFormField(controller: _descriptionC, decoration: const InputDecoration(labelText: 'Описание'), maxLines: 3),
            const SizedBox(height: 12),
            Row(children: [
              const Text('Дата: '),
              Text(_date.toLocal().toString().split(' ')[0]),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: _pickDate, child: const Text('Выбрать'))
            ]),
            const SizedBox(height: 12),
            Row(children: [
              const Text('Рейтинг: '),
              const SizedBox(width: 8),
              DropdownButton<int>(value: _rating, items: [1,2,3,4,5].map((e)=>DropdownMenuItem(value:e, child: Text('$e'))).toList(), onChanged: (v)=>setState(()=>_rating=v!))
            ]),
            const SizedBox(height: 20),
            ElevatedButton.icon(onPressed: _save, icon: const Icon(Icons.check), label: const Text('Сохранить'), style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity,48)))
          ]),
        ),
      ),
    );
  }
}
