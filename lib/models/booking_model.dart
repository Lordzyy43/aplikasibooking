enum BookingStatus {
  upcoming,
  completed,
}

class BookingModel {
  const BookingModel({
    required this.id,
    required this.venueName,
    required this.venueLocation,
    required this.venueImageUrl,
    required this.courtName,
    required this.sport,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
  });

  final String id;
  final String venueName;
  final String venueLocation;
  final String venueImageUrl;
  final String courtName;
  final String sport;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int totalPrice;
  final BookingStatus status;

  BookingModel copyWith({
    String? id,
    String? venueName,
    String? venueLocation,
    String? venueImageUrl,
    String? courtName,
    String? sport,
    DateTime? date,
    String? startTime,
    String? endTime,
    int? totalPrice,
    BookingStatus? status,
  }) {
    return BookingModel(
      id: id ?? this.id,
      venueName: venueName ?? this.venueName,
      venueLocation: venueLocation ?? this.venueLocation,
      venueImageUrl: venueImageUrl ?? this.venueImageUrl,
      courtName: courtName ?? this.courtName,
      sport: sport ?? this.sport,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
    );
  }
}
