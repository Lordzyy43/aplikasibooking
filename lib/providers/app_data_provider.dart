import 'package:flutter/foundation.dart';
import '../core/services/booking_service.dart';
import '../core/services/gor_service.dart';
import '../models/booking_model.dart';
import '../models/notification_model.dart';
import '../models/promo_model.dart';
import '../models/user_model.dart';
import '../models/venue_model.dart';

class AppDataProvider extends ChangeNotifier {
  final GorService _gorService = const GorService();
  final BookingService _bookingService = const BookingService();

  late UserModel _user;
  late PromoModel _promo;
  List<VenueModel> _venues = const [];
  List<BookingModel> _bookings = const [];
  List<NotificationModel> _notifications = const [];

  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  UserModel get user => _user;
  PromoModel get promo => _promo;
  List<VenueModel> get venues => _venues;
  List<BookingModel> get bookings => _bookings;
  List<NotificationModel> get notifications => _notifications;

  List<BookingModel> get upcomingBookings =>
      _bookings.where((booking) => booking.status == BookingStatus.upcoming).toList();

  List<BookingModel> get completedBookings =>
      _bookings.where((booking) => booking.status == BookingStatus.completed).toList();

  List<VenueModel> get recommendedVenues => _venues.take(3).toList();

  List<VenueModel> get nearbyVenues {
    final sorted = [..._venues]..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return sorted.take(3).toList();
  }

  List<String> get sportsCategories {
    final sports = <String>{'All'};
    for (final venue in _venues) {
      sports.addAll(venue.sports);
    }
    return sports.toList();
  }

  void load() {
    _user = _bookingService.getUser();
    _promo = _bookingService.getPromo();
    _venues = _gorService.getVenues();
    _bookings = _bookingService.getBookings();
    _notifications = _bookingService.getNotifications();
    _isLoaded = true;
    notifyListeners();
  }

  VenueModel getVenueById(String id) {
    return _venues.firstWhere((venue) => venue.id == id);
  }

  void confirmBooking(BookingModel booking) {
    _bookings = [booking, ..._bookings];
    _notifications = [
      NotificationModel(
        id: 'notif-${booking.id}',
        title: 'Booking confirmed',
        subtitle:
            '${booking.courtName} at ${booking.venueName} is set for ${booking.startTime}.',
        timeLabel: 'Now',
        type: NotificationType.booking,
      ),
      ..._notifications,
    ];
    notifyListeners();
  }
}
