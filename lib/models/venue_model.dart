class VenueReviewModel {
  const VenueReviewModel({
    required this.author,
    required this.avatarUrl,
    required this.rating,
    required this.comment,
    required this.timeLabel,
    this.hasPhoto = false,
  });

  final String author;
  final String avatarUrl;
  final double rating;
  final String comment;
  final String timeLabel;
  final bool hasPhoto;
}

class VenueCourtModel {
  const VenueCourtModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.galleryUrls,
    required this.surface,
    required this.environment,
    required this.pricePerHour,
    required this.specs,
    required this.availableTimes,
    required this.bookedTimes,
  });

  final String id;
  final String name;
  final String imageUrl;
  final List<String> galleryUrls;
  final String surface;
  final String environment;
  final int pricePerHour;
  final Map<String, String> specs;
  final List<String> availableTimes;
  final List<String> bookedTimes;

  factory VenueCourtModel.fromSupabase(Map<String, dynamic> json) {
    final images = _imageUrls(json['court_images']);
    final sportName = _nestedName(json['sports']);
    final surface = _stringValue(json['surface'], '-');
    final environment = _stringValue(json['environment'], 'Indoor');

    return VenueCourtModel(
      id: _stringValue(json['id']),
      name: _stringValue(json['name'], 'Court'),
      imageUrl: images.isNotEmpty
          ? images.first
          : 'assets/images/Court/badminton1.jpg',
      galleryUrls: images.isNotEmpty
          ? images
          : const ['assets/images/Court/badminton1.jpg'],
      surface: surface,
      environment: environment,
      pricePerHour: _intValue(json['price_per_hour']),
      specs: {
        if (sportName.isNotEmpty) 'Olahraga': sportName,
        'Lantai': surface,
        'Tipe': environment,
      },
      availableTimes: const [
        '08:00',
        '09:00',
        '10:00',
        '11:00',
        '13:00',
        '14:00',
        '15:00',
        '16:00',
        '19:00',
        '20:00',
        '21:00',
        '22:00',
      ],
      bookedTimes: const [],
    );
  }
}

class VenueModel {
  const VenueModel({
    required this.id,
    required this.name,
    required this.location,
    required this.distanceKm,
    required this.imageUrl,
    required this.galleryUrls,
    required this.rating,
    required this.reviewCount,
    required this.pricePerHour,
    required this.sports,
    required this.amenities,
    required this.courts,
    required this.statusLabel,
    required this.description,
    required this.reviews,
  });

  final String id;
  final String name;
  final String location;
  final double distanceKm;
  final String imageUrl;
  final List<String> galleryUrls;
  final double rating;
  final int reviewCount;
  final int pricePerHour;
  final List<String> sports;
  final List<String> amenities;
  final List<VenueCourtModel> courts;
  final String statusLabel;
  final String description;
  final List<VenueReviewModel> reviews;

  factory VenueModel.fromSupabase(Map<String, dynamic> json) {
    final images = _imageUrls(json['venue_images']);
    final courts = _mapList(
      json['courts'],
    ).map(VenueCourtModel.fromSupabase).toList();
    final amenities = _mapList(json['venue_amenities'])
        .map((item) => _nestedName(item['amenities']))
        .where((name) => name.isNotEmpty)
        .toList();
    final sports = courts
        .map((court) => court.specs['Olahraga'] ?? '')
        .where((sport) => sport.isNotEmpty)
        .toSet()
        .toList();
    final ratings = courts
        .map((court) => _courtRating(json, court.id))
        .where((rating) => rating > 0);
    final reviewCount = courts.fold<int>(0, (sum, court) {
      final source = _mapList(json['courts']).firstWhere(
        (item) => _stringValue(item['id']) == court.id,
        orElse: () => const <String, dynamic>{},
      );
      return sum + _intValue(source['review_count']);
    });
    final startingPrice = courts.isEmpty
        ? 0
        : courts
              .map((court) => court.pricePerHour)
              .reduce((a, b) => a < b ? a : b);

    return VenueModel(
      id: _stringValue(json['id']),
      name: _stringValue(json['name'], 'Venue'),
      location: _location(json),
      distanceKm: 0,
      imageUrl: images.isNotEmpty
          ? images.first
          : 'assets/images/Venue/Venue1.jpg',
      galleryUrls: images.isNotEmpty
          ? images
          : const ['assets/images/Venue/Venue1.jpg'],
      rating: ratings.isEmpty
          ? 0
          : ratings.reduce((value, element) => value + element) /
                ratings.length,
      reviewCount: reviewCount,
      pricePerHour: startingPrice,
      sports: sports.isEmpty ? const ['Sport'] : sports,
      amenities: amenities,
      courts: courts,
      statusLabel: _stringValue(json['status'], 'open').toUpperCase(),
      description: _stringValue(
        json['description'],
        'Venue olahraga Aerobook.',
      ),
      reviews: const [],
    );
  }
}

String _stringValue(Object? value, [String fallback = '']) {
  final text = value?.toString();
  if (text == null || text.trim().isEmpty) return fallback;
  return text;
}

int _intValue(Object? value, [int fallback = 0]) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

double _doubleValue(Object? value, [double fallback = 0]) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? fallback;
}

List<Map<String, dynamic>> _mapList(Object? value) {
  if (value is! List) return const [];

  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

String _nestedName(Object? value) {
  if (value is Map) return _stringValue(value['name']);
  return '';
}

List<String> _imageUrls(Object? value) {
  final rows = _mapList(value);
  rows.sort((a, b) {
    final primaryCompare = (b['is_primary'] == true ? 1 : 0).compareTo(
      a['is_primary'] == true ? 1 : 0,
    );
    if (primaryCompare != 0) return primaryCompare;
    return _intValue(a['sort_order']).compareTo(_intValue(b['sort_order']));
  });

  return rows
      .map((row) => _stringValue(row['image_url']))
      .where((url) => url.isNotEmpty)
      .toList();
}

String _location(Map<String, dynamic> json) {
  final address = _stringValue(json['address']);
  final city = _stringValue(json['city']);

  if (address.isNotEmpty && city.isNotEmpty) return '$address, $city';
  if (address.isNotEmpty) return address;
  return city;
}

double _courtRating(Map<String, dynamic> venueJson, String courtId) {
  final court = _mapList(venueJson['courts']).firstWhere(
    (item) => _stringValue(item['id']) == courtId,
    orElse: () => const <String, dynamic>{},
  );

  return _doubleValue(court['average_rating']);
}
