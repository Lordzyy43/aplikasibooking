import 'package:flutter/material.dart';
import '../models/booking_model.dart';

class BookingProvider extends ChangeNotifier {
  String? selectedField;
  DateTime selectedDate = DateTime.now();
  String? selectedTime;

  final List<String> fields = ["Lapangan Futsal A", "Lapangan Futsal B", "Lapangan Badminton"];

  final List<String> times = ["08:00", "10:00", "12:00", "14:00", "16:00", "18:00"];

  final List<BookingModel> bookings = [];

  void selectField(String field) {
    selectedField = field;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void selectTime(String time) {
    selectedTime = time;
    notifyListeners();
  }

  void createBooking() {
    if (selectedField == null || selectedTime == null) return;

    bookings.add(BookingModel(fieldName: selectedField!, date: selectedDate, time: selectedTime!));

    notifyListeners();
  }
}
