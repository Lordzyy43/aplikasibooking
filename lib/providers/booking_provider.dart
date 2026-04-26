import 'package:flutter/material.dart';

class BookingProvider extends ChangeNotifier {
  // 1. Data State
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  String? _selectedField;

  // 2. Getter (Buat ambil data ke UI)
  DateTime get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;
  String? get selectedField => _selectedField;

  // 3. Setter / Action (Tangan buat nerima data dari UI)

  // Fungsi untuk set tanggal
  void setDate(DateTime date) {
    _selectedDate = date;
    // Setiap kali ganti tanggal, reset jamnya biar user pilih ulang
    _selectedTime = null;
    notifyListeners(); // Ini penting biar UI tau ada perubahan!
  }

  // Fungsi untuk set jam
  void setTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }

  // Fungsi untuk set nama lapangan
  void setSelectedField(String fieldName) {
    _selectedField = fieldName;
    notifyListeners();
  }

  // Bonus: Fungsi reset kalau booking batal/selesai
  void resetBooking() {
    _selectedDate = DateTime.now();
    _selectedTime = null;
    _selectedField = null;
    notifyListeners();
  }
}
