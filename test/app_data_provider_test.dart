import 'package:apkbooking/models/booking_model.dart';
import 'package:apkbooking/providers/app_data_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('app data provider loads seeded content and accepts new bookings', () {
    final provider = AppDataProvider()..loadInitialData();

    expect(provider.venues, isNotEmpty);
    expect(provider.upcomingBookings, isNotEmpty);
    expect(provider.notifications, isNotEmpty);

    final booking = BookingModel(
      id: 'BK-test',
      venueName: 'Test Arena',
      venueLocation: 'Test District',
      venueImageUrl: 'https://example.com/test.png',
      courtName: 'Court Test',
      sport: 'Badminton',
      date: DateTime(2026, 4, 27),
      startTime: '18:00',
      endTime: '19:00',
      totalPrice: 100000,
      status: BookingStatus.upcoming,
    );

    provider.confirmBooking(booking);

    expect(provider.bookings.first.id, 'BK-test');
    expect(provider.notifications.first.title, 'Booking confirmed');
  });
}
