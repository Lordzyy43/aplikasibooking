import 'package:flutter/material.dart';

class BookingProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  String? _selectedField;
  String? _selectedVenueId;
  String? _selectedVenueName;
  String? _selectedVenueLocation;
  String? _selectedVenueImageUrl;
  String? _selectedSport;
  int? _selectedPrice;

  DateTime get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;
  String? get selectedField => _selectedField;
  String? get selectedVenueId => _selectedVenueId;
  String? get selectedVenueName => _selectedVenueName;
  String? get selectedVenueLocation => _selectedVenueLocation;
  String? get selectedVenueImageUrl => _selectedVenueImageUrl;
  String? get selectedSport => _selectedSport;
  int get selectedPrice => _selectedPrice ?? 0;

  void setDate(DateTime date) {
    _selectedDate = date;
    _selectedTime = null;
    notifyListeners();
  }

  void setTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setSelectedField(String fieldName) {
    _selectedField = fieldName;
    notifyListeners();
  }

  void setVenueSelection({
    required String venueId,
    required String venueName,
    required String venueLocation,
    required String venueImageUrl,
    required String sport,
    required String fieldName,
    required int price,
  }) {
    _selectedVenueId = venueId;
    _selectedVenueName = venueName;
    _selectedVenueLocation = venueLocation;
    _selectedVenueImageUrl = venueImageUrl;
    _selectedSport = sport;
    _selectedField = fieldName;
    _selectedPrice = price;
    notifyListeners();
  }

  void resetBooking() {
    _selectedDate = DateTime.now();
    _selectedTime = null;
    _selectedField = null;
    _selectedVenueId = null;
    _selectedVenueName = null;
    _selectedVenueLocation = null;
    _selectedVenueImageUrl = null;
    _selectedSport = null;
    _selectedPrice = null;
    notifyListeners();
  }
}
