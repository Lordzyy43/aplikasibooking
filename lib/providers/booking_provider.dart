import 'package:flutter/material.dart';

class BookingProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  String? _selectedSlotId;
  String? _selectedField;
  String? _selectedVenueId;
  String? _selectedCourtId;
  String? _selectedVenueName;
  String? _selectedVenueLocation;
  String? _selectedVenueImageUrl;
  String? _selectedSport;
  int? _selectedPrice;
  String? _remoteBookingId;
  String? _remoteBookingCode;
  int? _remoteBookingTotal;
  String? _remotePaymentId;

  DateTime get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;
  String? get selectedSlotId => _selectedSlotId;
  String? get selectedField => _selectedField;
  String? get selectedVenueId => _selectedVenueId;
  String? get selectedCourtId => _selectedCourtId;
  String? get selectedVenueName => _selectedVenueName;
  String? get selectedVenueLocation => _selectedVenueLocation;
  String? get selectedVenueImageUrl => _selectedVenueImageUrl;
  String? get selectedSport => _selectedSport;
  int get selectedPrice => _selectedPrice ?? 0;
  String? get remoteBookingId => _remoteBookingId;
  String? get remoteBookingCode => _remoteBookingCode;
  int? get remoteBookingTotal => _remoteBookingTotal;
  String? get remotePaymentId => _remotePaymentId;

  void setDate(DateTime date) {
    _selectedDate = date;
    _selectedTime = null;
    _selectedSlotId = null;
    notifyListeners();
  }

  void setTime(String time, {String? slotId}) {
    _selectedTime = time;
    _selectedSlotId = slotId;
    notifyListeners();
  }

  void setSelectedField(String fieldName) {
    _selectedField = fieldName;
    notifyListeners();
  }

  void setVenueSelection({
    required String venueId,
    String? courtId,
    required String venueName,
    required String venueLocation,
    required String venueImageUrl,
    required String sport,
    required String fieldName,
    required int price,
  }) {
    _selectedVenueId = venueId;
    _selectedCourtId = courtId;
    _selectedVenueName = venueName;
    _selectedVenueLocation = venueLocation;
    _selectedVenueImageUrl = venueImageUrl;
    _selectedSport = sport;
    _selectedField = fieldName;
    _selectedPrice = price;
    notifyListeners();
  }

  void setRemoteBooking({
    required String bookingId,
    required String bookingCode,
    required int totalPrice,
    String? paymentId,
  }) {
    _remoteBookingId = bookingId;
    _remoteBookingCode = bookingCode;
    _remoteBookingTotal = totalPrice;
    _remotePaymentId = paymentId;
    notifyListeners();
  }

  void resetBooking() {
    _selectedDate = DateTime.now();
    _selectedTime = null;
    _selectedSlotId = null;
    _selectedField = null;
    _selectedVenueId = null;
    _selectedCourtId = null;
    _selectedVenueName = null;
    _selectedVenueLocation = null;
    _selectedVenueImageUrl = null;
    _selectedSport = null;
    _selectedPrice = null;
    _remoteBookingId = null;
    _remoteBookingCode = null;
    _remoteBookingTotal = null;
    _remotePaymentId = null;
    notifyListeners();
  }
}
