import 'package:flutter/foundation.dart';
import 'package:apkbooking/core/services/booking_service.dart';
import 'package:apkbooking/core/services/gor_service.dart';
import 'package:apkbooking/core/services/supabase_booking_service.dart';
import 'package:apkbooking/core/services/supabase_catalog_service.dart';
import 'package:apkbooking/models/booking_model.dart';
import 'package:apkbooking/models/notification_model.dart';
import 'package:apkbooking/models/promo_model.dart';
import 'package:apkbooking/models/user_model.dart';
import 'package:apkbooking/models/venue_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppDataProvider extends ChangeNotifier {
  AppDataProvider({bool useSeedData = false}) : _useSeedData = useSeedData;

  final bool _useSeedData;
  final GorService _gorService = const GorService();
  final BookingService _bookingService = const BookingService();
  SupabaseCatalogService? _catalogService;
  SupabaseBookingService? _supabaseBookingService;

  // Gunakan nullable atau data default agar tidak error saat inisialisasi awal
  UserModel? _user;
  PromoModel? _promo;
  List<VenueModel> _venues = [];
  List<BookingModel> _bookings = [];
  List<NotificationModel> _notifications = [];
  List<String> _sportsCategories = ['All'];

  bool _isLoaded = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
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

  void clearSessionData() {
    _user = null;
    _bookings = [];
    _notifications = [];
    notifyListeners();
  }

  // Logic filter booking yang lebih presisi
  List<BookingModel> get upcomingBookings => _bookings
      .where((booking) => booking.status == BookingStatus.upcoming)
      .toList();

  List<BookingModel> get completedBookings => _bookings
      .where((booking) => booking.status == BookingStatus.completed)
      .toList();

  // Rekomendasi berdasarkan rating tertinggi
  List<VenueModel> get recommendedVenues {
    final sorted = [..._venues]..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(5).toList();
  }

  // Nearby berdasarkan jarak terdekat
  List<VenueModel> get nearbyVenues {
    final sorted = [..._venues]
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return sorted.take(5).toList();
  }

  /// Evolve: Gunakan loadInitialData agar sinkron dengan HomePage
  Future<void> loadInitialData() async {
    if (_isLoading) return; // Mencegah double loading

    if (_useSeedData) {
      _loadSeedData();
      notifyListeners();
      return;
    }

    _isLoading = true;
    // Jika ingin UI menampilkan loading saat refresh, set _isLoaded ke false
    // _isLoaded = false;
    notifyListeners();

    try {
      _user = Supabase.instance.client.auth.currentUser == null
          ? _bookingService.getUser()
          : null;
      _promo = _bookingService.getPromo();
      _notifications = Supabase.instance.client.auth.currentUser == null
          ? _bookingService.getNotifications()
          : [];

      final results = await Future.wait<Object>([
        (_catalogService ??= SupabaseCatalogService()).getSports(),
        (_catalogService ??= SupabaseCatalogService()).getVenues(),
      ]);

      final remoteSports = results[0] as List<String>;
      final remoteVenues = results[1] as List<VenueModel>;

      if (remoteVenues.isEmpty) {
        _venues = _gorService.getVenues();
        _generateCategories();
      } else {
        _venues = remoteVenues;
        _sportsCategories = [
          'All',
          ...remoteSports.where((sport) => sport.toLowerCase() != 'all'),
        ];

        if (_sportsCategories.length == 1) {
          _generateCategories();
        }
      }

      await refreshBookings(notify: false);
      await refreshNotifications(notify: false);

      if (_bookings.isEmpty &&
          Supabase.instance.client.auth.currentUser == null) {
        _bookings = _bookingService.getBookings();
      }

      if (_notifications.isEmpty &&
          Supabase.instance.client.auth.currentUser == null) {
        _notifications = _bookingService.getNotifications();
      }

      _isLoaded = true;
    } catch (e) {
      _errorMessage =
          'Catalog Supabase belum bisa dimuat. Menggunakan data dummy.';
      debugPrint('Error loading data: $e');
      _loadSeedData();
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
      orElse: () => _venues.isNotEmpty
          ? _venues.first
          : throw Exception("Venue tidak ditemukan"),
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

  Future<void> refreshBookings({bool notify = true}) async {
    if (_useSeedData) {
      _bookings = _bookingService.getBookings();
      if (notify) notifyListeners();
      return;
    }

    try {
      final remoteBookings =
          await (_supabaseBookingService ??= SupabaseBookingService())
              .getMyBookings();

      if (Supabase.instance.client.auth.currentUser != null ||
          remoteBookings.isNotEmpty) {
        _bookings = remoteBookings;
      }
    } catch (e) {
      debugPrint('Error loading bookings from Supabase: $e');
    } finally {
      if (notify) notifyListeners();
    }
  }

  Future<void> refreshNotifications({bool notify = true}) async {
    if (_useSeedData) {
      _notifications = _bookingService.getNotifications();
      if (notify) notifyListeners();
      return;
    }

    try {
      final remoteNotifications =
          await (_supabaseBookingService ??= SupabaseBookingService())
              .getMyNotifications();

      if (Supabase.instance.client.auth.currentUser != null ||
          remoteNotifications.isNotEmpty) {
        _notifications = remoteNotifications;
      }
    } catch (e) {
      debugPrint('Error loading notifications from Supabase: $e');
    } finally {
      if (notify) notifyListeners();
    }
  }

  Future<void> markNotificationRead(String notificationId) async {
    final index = _notifications.indexWhere(
      (item) => item.id == notificationId,
    );
    if (index == -1) return;

    final previous = _notifications[index];
    if (!previous.isUnread) return;

    _notifications = [
      ..._notifications.take(index),
      previous.copyWith(isUnread: false),
      ..._notifications.skip(index + 1),
    ];
    notifyListeners();

    try {
      await (_supabaseBookingService ??= SupabaseBookingService())
          .markNotificationRead(notificationId);
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  Future<void> markAllNotificationsRead() async {
    if (_notifications.every((item) => !item.isUnread)) return;

    _notifications = [
      for (final item in _notifications) item.copyWith(isUnread: false),
    ];
    notifyListeners();

    try {
      await (_supabaseBookingService ??= SupabaseBookingService())
          .markAllNotificationsRead();
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
    }
  }

  void _loadSeedData() {
    _user = _bookingService.getUser();
    _promo = _bookingService.getPromo();
    _venues = _gorService.getVenues();
    _bookings = _bookingService.getBookings();
    _notifications = _bookingService.getNotifications();
    _generateCategories();
    _isLoaded = true;
  }
}
