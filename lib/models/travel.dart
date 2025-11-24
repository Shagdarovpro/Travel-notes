class Travel {
  final int? id;
  final String country;
  final String city;
  final DateTime date;
  final int rating; // 1..5
  final String description;
  final String? imagePath;

  Travel({
    this.id,
    required this.country,
    required this.city,
    required this.date,
    required this.rating,
    required this.description,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'country': country,
      'city': city,
      'date': date.toIso8601String(),
      'rating': rating,
      'description': description,
      'imagePath': imagePath,
    };
  }

  factory Travel.fromMap(Map<String, dynamic> map) {
    return Travel(
      id: map['id'] as int?,
      country: map['country'] as String,
      city: map['city'] as String,
      date: DateTime.parse(map['date'] as String),
      rating: map['rating'] as int,
      description: map['description'] as String,
      imagePath: map['imagePath'] as String?,
    );
  }

  Travel copyWith({
    int? id,
    String? country,
    String? city,
    DateTime? date,
    int? rating,
    String? description,
    String? imagePath,
  }) {
    return Travel(
      id: id ?? this.id,
      country: country ?? this.country,
      city: city ?? this.city,
      date: date ?? this.date,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
