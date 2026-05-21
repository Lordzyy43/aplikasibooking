enum BookingStatus { upcoming, completed }

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
    this.remoteId,
    this.courtId,
    this.rawStatus = 'confirmed',
    this.paymentStatus,
    this.paymentMethod,
    this.hasReview = false,
  });

  final String id;
  final String? remoteId;
  final String? courtId;
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
  final String rawStatus;
  final String? paymentStatus;
  final String? paymentMethod;
  final bool hasReview;

  bool get isPendingPayment => rawStatus == 'pending_payment';
  bool get isConfirmed => rawStatus == 'confirmed';
  bool get isFinished => rawStatus == 'finished';
  bool get isCancelled => rawStatus == 'cancelled';
  bool get isExpired => rawStatus == 'expired';

  String get statusLabel {
    return switch (rawStatus) {
      'pending_payment' => 'Menunggu Pembayaran',
      'confirmed' => 'Aktif',
      'finished' => 'Selesai',
      'cancelled' => 'Dibatalkan',
      'expired' => 'Kadaluarsa',
      _ => status == BookingStatus.upcoming ? 'Aktif' : 'Selesai',
    };
  }

  String get shortStatusLabel {
    return switch (rawStatus) {
      'pending_payment' => 'PENDING',
      'confirmed' => 'AKTIF',
      'finished' => 'SELESAI',
      'cancelled' => 'BATAL',
      'expired' => 'EXPIRED',
      _ => status == BookingStatus.upcoming ? 'AKTIF' : 'SELESAI',
    };
  }

  String get paymentLabel {
    return switch (paymentStatus) {
      'pending' => 'Payment Pending',
      'paid' => 'Payment Paid',
      'failed' => 'Payment Failed',
      'expired' => 'Payment Expired',
      'cancelled' => 'Payment Cancelled',
      _ => isPendingPayment ? 'Payment Pending' : 'Payment Status',
    };
  }

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
    String? remoteId,
    String? courtId,
    String? rawStatus,
    String? paymentStatus,
    String? paymentMethod,
    bool? hasReview,
  }) {
    return BookingModel(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      courtId: courtId ?? this.courtId,
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
      rawStatus: rawStatus ?? this.rawStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      hasReview: hasReview ?? this.hasReview,
    );
  }

  factory BookingModel.fromSupabase(Map<String, dynamic> json) {
    final court = _mapValue(json['courts'] ?? json['court']);
    final venue = _mapValue(court['venues'] ?? court['venue']);
    final sport = _mapValue(court['sports'] ?? court['sport']);
    final slots = _mapList(json['booking_slots'] ?? json['slots']);
    final payment = _singleOrFirst(json['payments'] ?? json['payment']);
    final review = _singleOrFirst(json['reviews'] ?? json['review']);
    final rawStatus = _stringValue(json['status']);
    final sortedSlots = [...slots]
      ..sort((a, b) {
        final aSlot = _mapValue(a['time_slots'] ?? a['time_slot']);
        final bSlot = _mapValue(b['time_slots'] ?? b['time_slot']);
        return _stringValue(
          aSlot['start_time'],
        ).compareTo(_stringValue(bSlot['start_time']));
      });

    final firstSlot = sortedSlots.isNotEmpty
        ? _mapValue(
            sortedSlots.first['time_slots'] ?? sortedSlots.first['time_slot'],
          )
        : const <String, dynamic>{};
    final lastSlot = sortedSlots.isNotEmpty
        ? _mapValue(
            sortedSlots.last['time_slots'] ?? sortedSlots.last['time_slot'],
          )
        : firstSlot;

    return BookingModel(
      id: _stringValue(json['booking_code']).isNotEmpty
          ? _stringValue(json['booking_code'])
          : _stringValue(json['id']),
      remoteId: _nullableString(json['id']),
      courtId: _nullableString(json['court_id']),
      venueName: _stringValue(venue['name'], fallback: 'Aerobook Venue'),
      venueLocation: _location(venue),
      venueImageUrl: _primaryImageUrl(venue['venue_images'] ?? venue['images']),
      courtName: _stringValue(court['name'], fallback: '-'),
      sport: _stringValue(sport['name'], fallback: '-'),
      date:
          DateTime.tryParse(_stringValue(json['booking_date'])) ??
          DateTime.now(),
      startTime: _slotTime(firstSlot, 'start_time'),
      endTime: _slotTime(lastSlot, 'end_time'),
      totalPrice: _intValue(json['total_price']),
      status: _bookingStatus(rawStatus),
      rawStatus: rawStatus.isEmpty ? 'confirmed' : rawStatus,
      paymentStatus: _nullableString(payment['status']),
      paymentMethod: _nullableString(payment['method']),
      hasReview: _nullableString(review['id']) != null,
    );
  }
}

Map<String, dynamic> _mapValue(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return const <String, dynamic>{};
}

List<Map<String, dynamic>> _mapList(Object? value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

Map<String, dynamic> _singleOrFirst(Object? value) {
  if (value is List) {
    final rows = _mapList(value);
    return rows.isEmpty ? const <String, dynamic>{} : rows.first;
  }

  return _mapValue(value);
}

String _stringValue(Object? value, {String fallback = ''}) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? fallback : text;
}

String? _nullableString(Object? value) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? null : text;
}

int _intValue(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _location(Map<String, dynamic> venue) {
  final city = _stringValue(venue['city']);
  final address = _stringValue(venue['address']);

  if (city.isNotEmpty && address.isNotEmpty) return '$city, $address';
  if (city.isNotEmpty) return city;
  if (address.isNotEmpty) return address;
  return '-';
}

String _primaryImageUrl(Object? imagesValue) {
  final images = _mapList(imagesValue);
  if (images.isEmpty) return '';

  final primary = images.cast<Map<String, dynamic>?>().firstWhere(
    (image) => image?['is_primary'] == true,
    orElse: () => images.first,
  );

  return _stringValue(primary?['image_url']);
}

String _slotTime(Map<String, dynamic> slot, String key) {
  final time = _stringValue(slot[key]);
  if (time.length >= 5) return time.substring(0, 5);
  return time.isEmpty ? '-' : time;
}

BookingStatus _bookingStatus(String status) {
  return switch (status) {
    'finished' || 'cancelled' || 'expired' => BookingStatus.completed,
    _ => BookingStatus.upcoming,
  };
}
