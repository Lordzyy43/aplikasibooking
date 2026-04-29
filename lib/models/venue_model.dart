class VenueCourtModel {
  const VenueCourtModel({
    required this.id,
    required this.name,
    required this.imageUrl,
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
  final String surface;
  final String environment;
  final int pricePerHour;
  final Map<String, String> specs;
  final List<String> availableTimes;
  final List<String> bookedTimes;
}

class VenueModel {
  const VenueModel({
    required this.id,
    required this.name,
    required this.location,
    required this.distanceKm,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.pricePerHour,
    required this.sports,
    required this.amenities,
    required this.courts,
    required this.statusLabel,
    required this.description,
  });

  final String id;
  final String name;
  final String location;
  final double distanceKm;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final int pricePerHour;
  final List<String> sports;
  final List<String> amenities;
  final List<VenueCourtModel> courts;
  final String statusLabel;
  final String description;
}
