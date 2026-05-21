import 'package:intl/intl.dart';
import 'package:apkbooking/models/booking_model.dart';
import 'package:apkbooking/models/notification_model.dart';
import 'package:apkbooking/models/venue_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CourtAvailabilitySlot {
  const CourtAvailabilitySlot({
    required this.id,
    required this.label,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    this.reason,
  });

  factory CourtAvailabilitySlot.fromSupabase(Map<String, dynamic> data) {
    return CourtAvailabilitySlot(
      id: data['slot_id']?.toString() ?? '',
      label: data['label']?.toString() ?? '',
      startTime: data['start_time']?.toString() ?? '',
      endTime: data['end_time']?.toString() ?? '',
      isAvailable: data['is_available'] == true,
      reason: data['reason']?.toString(),
    );
  }

  final String id;
  final String label;
  final String startTime;
  final String endTime;
  final bool isAvailable;
  final String? reason;

  String get displayLabel {
    if (label.isNotEmpty) return label;
    if (startTime.length >= 5) return startTime.substring(0, 5);
    return startTime;
  }
}

class CreatedBookingResult {
  const CreatedBookingResult({
    required this.bookingId,
    required this.bookingCode,
    required this.totalPrice,
  });

  factory CreatedBookingResult.fromSupabase(Map<String, dynamic> data) {
    return CreatedBookingResult(
      bookingId: data['booking_id']?.toString() ?? '',
      bookingCode: data['booking_code']?.toString() ?? '',
      totalPrice: int.tryParse(data['total_price']?.toString() ?? '') ?? 0,
    );
  }

  final String bookingId;
  final String bookingCode;
  final int totalPrice;
}

class CreatedPaymentResult {
  const CreatedPaymentResult({
    required this.paymentId,
    required this.amount,
    required this.method,
  });

  factory CreatedPaymentResult.fromSupabase(Map<String, dynamic> data) {
    return CreatedPaymentResult(
      paymentId: data['id']?.toString() ?? '',
      amount: int.tryParse(data['amount']?.toString() ?? '') ?? 0,
      method: data['method']?.toString() ?? 'qris',
    );
  }

  final String paymentId;
  final int amount;
  final String method;
}

class SupabaseBookingService {
  SupabaseBookingService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<CourtAvailabilitySlot>> getCourtAvailability({
    required String courtId,
    required DateTime date,
  }) async {
    final response = await _client.rpc(
      'get_court_availability',
      params: {
        'p_court_id': courtId,
        'p_booking_date': DateFormat('yyyy-MM-dd').format(date),
      },
    );

    final rows = response is List ? response : const [];

    return rows
        .whereType<Map>()
        .map(
          (row) => CourtAvailabilitySlot.fromSupabase(
            Map<String, dynamic>.from(row),
          ),
        )
        .where((slot) => slot.id.isNotEmpty && slot.displayLabel.isNotEmpty)
        .toList();
  }

  Future<CreatedBookingResult> createBooking({
    required String courtId,
    required DateTime date,
    required List<String> timeSlotIds,
  }) async {
    final response = await _client.rpc(
      'create_booking',
      params: {
        'p_court_id': courtId,
        'p_booking_date': DateFormat('yyyy-MM-dd').format(date),
        'p_time_slot_ids': timeSlotIds,
      },
    );

    final rows = response is List ? response : const [];
    if (rows.isEmpty || rows.first is! Map) {
      throw const PostgrestException(message: 'Booking response is empty');
    }

    return CreatedBookingResult.fromSupabase(
      Map<String, dynamic>.from(rows.first as Map),
    );
  }

  Future<CreatedPaymentResult> createPayment({
    required String bookingId,
    required int amount,
    String method = 'qris',
  }) async {
    final row = await _client
        .from('payments')
        .insert({
          'booking_id': bookingId,
          'method': method,
          'status': 'pending',
          'amount': amount,
          'expired_at': DateTime.now()
              .add(const Duration(minutes: 15))
              .toUtc()
              .toIso8601String(),
        })
        .select('id, amount, method')
        .single();

    return CreatedPaymentResult.fromSupabase(row);
  }

  Future<List<BookingModel>> getMyBookings() async {
    if (_client.auth.currentUser == null) return const [];

    final rows = await _client
        .from('bookings')
        .select('''
          id,
          court_id,
          booking_code,
          booking_date,
          status,
          total_price,
          courts(
            name,
            sports(name),
            venues(
              name,
              address,
              city,
              venue_images(image_url, is_primary)
            )
          ),
          booking_slots(
            time_slots(label, start_time, end_time)
          ),
          payments(
            status,
            method,
            expired_at
          ),
          reviews(
            id
          )
        ''')
        .order('booking_date', ascending: false)
        .order('created_at', ascending: false);

    return rows
        .whereType<Map>()
        .map((row) => BookingModel.fromSupabase(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<List<VenueReviewModel>> getCourtReviews(String courtId) async {
    final rows = await _client
        .from('reviews')
        .select('rating, comment, created_at, users(full_name, avatar_url)')
        .eq('court_id', courtId)
        .order('created_at', ascending: false)
        .limit(20);

    return rows
        .whereType<Map>()
        .map((row) => _reviewFromSupabase(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<void> submitReview({
    required String bookingId,
    required String courtId,
    required int rating,
    required String comment,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthException('User belum login.');
    }

    await _client.from('reviews').insert({
      'booking_id': bookingId,
      'court_id': courtId,
      'user_id': userId,
      'rating': rating,
      'comment': comment.trim().isEmpty ? null : comment.trim(),
    });
  }

  Future<List<NotificationModel>> getMyNotifications() async {
    if (_client.auth.currentUser == null) return const [];

    final rows = await _client
        .from('notifications')
        .select('id, title, body, type, is_read, created_at')
        .order('created_at', ascending: false);

    return rows
        .whereType<Map>()
        .map(
          (row) =>
              NotificationModel.fromSupabase(Map<String, dynamic>.from(row)),
        )
        .toList();
  }

  Future<void> markNotificationRead(String notificationId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  Future<void> markAllNotificationsRead() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', userId)
        .eq('is_read', false);
  }
}

VenueReviewModel _reviewFromSupabase(Map<String, dynamic> row) {
  final user = row['users'] is Map
      ? Map<String, dynamic>.from(row['users'] as Map)
      : const <String, dynamic>{};

  return VenueReviewModel(
    author: user['full_name']?.toString() ?? 'User Aerobook',
    avatarUrl: user['avatar_url']?.toString() ?? 'assets/Avatar/Avatar.png',
    rating: double.tryParse(row['rating']?.toString() ?? '') ?? 0,
    comment: row['comment']?.toString() ?? '',
    timeLabel: _relativeTimeLabel(row['created_at']?.toString()),
  );
}

String _relativeTimeLabel(String? value) {
  final createdAt = DateTime.tryParse(value ?? '')?.toLocal();
  if (createdAt == null) return 'Baru saja';

  final difference = DateTime.now().difference(createdAt);
  if (difference.inMinutes < 1) return 'Baru saja';
  if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
  if (difference.inHours < 24) return '${difference.inHours}h ago';
  if (difference.inDays == 1) return 'Yesterday';
  if (difference.inDays < 7) return '${difference.inDays}d ago';
  return DateFormat('dd MMM yyyy').format(createdAt);
}
