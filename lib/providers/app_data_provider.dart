import 'package:flutter/foundation.dart';
import 'package:apkbooking/core/services/booking_service.dart';
import 'package:apkbooking/core/services/gor_service.dart';
import 'package:apkbooking/models/booking_model.dart';
import 'package:apkbooking/models/notification_model.dart';
import 'package:apkbooking/models/promo_model.dart';
import 'package:apkbooking/models/user_model.dart';
import 'package:apkbooking/models/venue_model.dart';

class AppDataProvider extends ChangeNotifier {
  final GorService _gorService = const GorService();
  final BookingService _bookingService = const BookingService();

  // Gunakan nullable atau data default agar tidak error saat inisialisasi awal
  UserModel? _user;
  PromoModel? _promo;
  List<VenueModel> _venues = [];
  List<BookingModel> _bookings = [];
  List<NotificationModel> _notifications = [];
  List<String> _sportsCategories = ['All'];

  bool _isLoaded = false;
  bool _isLoading = false;

  // Getters
  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;
  UserModel get user =>
      _user ??
      UserModel(
        id: '0',
        name: 'User',
        email: 'user@example.com',
        walletBalance: 0,
        points: 0,
      ); // Fallback default
  PromoModel? get promo => _promo;
  List<VenueModel> get venues => _venues;
  List<BookingModel> get bookings => _bookings;
  List<NotificationModel> get notifications => _notifications;
  List<String> get sportsCategories => _sportsCategories;

  // Logic filter booking yang lebih presisi
  List<BookingModel> get upcomingBookings =>
      _bookings.where((booking) => booking.status == BookingStatus.upcoming).toList();

  List<BookingModel> get completedBookings =>
      _bookings.where((booking) => booking.status == BookingStatus.completed).toList();

  // Rekomendasi berdasarkan rating tertinggi
  List<VenueModel> get recommendedVenues {
    final sorted = [..._venues]..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(5).toList();
  }

  // Nearby berdasarkan jarak terdekat
  List<VenueModel> get nearbyVenues {
    final sorted = [..._venues]..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return sorted.take(5).toList();
  }

  /// Evolve: Gunakan loadInitialData agar sinkron dengan HomePage
  Future<void> loadInitialData() async {
    if (_isLoading) return; // Mencegah double loading

    _isLoading = true;
    // Jika ingin UI menampilkan loading saat refresh, set _isLoaded ke false
    // _isLoaded = false;
    notifyListeners();

    try {
      // Simulasi delay untuk efek fetching (Hapus saat sudah konek ke API nyata)
      await Future.delayed(const Duration(milliseconds: 800));

      // Fetching data dari Service
      _user = _bookingService.getUser();
      _promo = _bookingService.getPromo();
      _venues = _gorService.getVenues();
      _bookings = _bookingService.getBookings();
      _notifications = _bookingService.getNotifications();

      // Hitung kategori sekali saja setelah data venue dimuat
      _generateCategories();

      _isLoaded = true;
    } catch (e) {
      debugPrint("Error loading data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Menghitung kategori unik dari semua venue
  void _generateCategories() {
    final sports = <String>{'All'};
    for (final venue in _venues) {
      sports.addAll(venue.sports);
    }
    _sportsCategories = sports.toList();
  }

  VenueModel getVenueById(String id) {
    return _venues.firstWhere(
      (venue) => venue.id == id,
      // Gunakan orElse yang lebih aman jika list masih kosong
      orElse: () => _venues.isNotEmpty ? _venues.first : throw Exception("Venue tidak ditemukan"),
    );
  }

  void confirmBooking(BookingModel booking) {
    // Tambahkan di posisi teratas
    _bookings = [booking, ..._bookings];

    // Auto-generate notifikasi saat booking berhasil
    final newNotif = NotificationModel(
      id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Booking Berhasil!',
      subtitle: '${booking.venueName} - ${booking.courtName} siap digunakan.',
      timeLabel: 'Baru saja',
      type: NotificationType.booking,
    );

    _notifications = [newNotif, ..._notifications];
    notifyListeners();
  }
}
