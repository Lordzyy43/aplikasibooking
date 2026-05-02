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
}
