import 'package:apkbooking/models/booking_model.dart';
import 'package:apkbooking/models/notification_model.dart';
import 'package:apkbooking/models/promo_model.dart';
import 'package:apkbooking/models/user_model.dart';

const _badmintonHallImage = 'assets/images/Venue/Venue1.jpg';
const _badmintonActionImage = 'assets/images/Venue/Venue3.jpg';
const _tennisCourtImage = 'assets/images/Venue/Venue2.jpg';
const _avatarImage = 'assets/Avatar/Avatar.png';

class BookingService {
  const BookingService();

  UserModel getUser() {
    return const UserModel(
      id: 'USR-001',
      name: 'john doe',
      email: 'john@example.com',
      phone: '0812 3456 7890',
      avatarUrl: _avatarImage,
      walletBalance: 250000,
      points: 320,
    );
  }

  PromoModel getPromo() {
    return const PromoModel(
      title: 'Get 30% OFF',
      subtitle: 'On all indoor arenas this week',
      ctaLabel: 'Claim Now',
      discountLabel: '30%',
    );
  }

  List<BookingModel> getBookings() {
    return [
      BookingModel(
        id: 'BK-99210',
        venueName: 'Stadium Atelier',
        venueLocation: 'Olympic Sports Complex',
        venueImageUrl: _badmintonHallImage,
        courtName: 'Court A',
        sport: 'Badminton',
        date: DateTime.now().add(const Duration(days: 1)),
        startTime: '08:00',
        endTime: '10:00',
        totalPrice: 120000,
        status: BookingStatus.upcoming,
      ),
      BookingModel(
        id: 'BK-99211',
        venueName: 'The Smash Club',
        venueLocation: 'Kartasura Sports Hub',
        venueImageUrl: _badmintonActionImage,
        courtName: 'Court B',
        sport: 'Badminton',
        date: DateTime.now().subtract(const Duration(days: 2)),
        startTime: '19:00',
        endTime: '20:00',
        totalPrice: 100000,
        status: BookingStatus.completed,
      ),
      BookingModel(
        id: 'BK-99212',
        venueName: 'Grand Slam Arena',
        venueLocation: 'Solo Center District',
        venueImageUrl: _tennisCourtImage,
        courtName: 'Center Court',
        sport: 'Tennis',
        date: DateTime.now().subtract(const Duration(days: 5)),
        startTime: '20:00',
        endTime: '21:00',
        totalPrice: 95000,
        status: BookingStatus.completed,
      ),
    ];
  }

  List<NotificationModel> getNotifications() {
    return const [
      NotificationModel(
        id: 'notif-01',
        title: 'Booking confirmed',
        subtitle: 'Court 01 at Stadium Atelier is set for tonight at 19:00.',
        timeLabel: 'Now',
        type: NotificationType.booking,
      ),
      NotificationModel(
        id: 'notif-02',
        title: 'Special offer',
        subtitle: 'Indoor arenas are 30% off until Friday.',
        timeLabel: '2h ago',
        type: NotificationType.offer,
      ),
      NotificationModel(
        id: 'notif-03',
        title: 'Venue reminder',
        subtitle: 'Please arrive 15 minutes early for check-in and warm-up.',
        timeLabel: 'Yesterday',
        type: NotificationType.reminder,
        isUnread: false,
      ),
    ];
  }
}
