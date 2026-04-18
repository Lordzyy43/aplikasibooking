import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../providers/booking_provider.dart';
import '../../core/app_colors.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Booking Lapangan"), elevation: 0),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ===== PILIH LAPANGAN =====
                  _buildSectionLabel("Pilih Lapangan", FontAwesomeIcons.volleyball),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 5.h,
                    children: provider.fields.map((field) {
                      final isSelected = provider.selectedField == field;
                      return _buildChoiceChip(
                        label: field,
                        isSelected: isSelected,
                        onSelected: (_) => provider.selectField(field),
                        activeColor: AppColors.primary,
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 25.h),

                  /// ===== PILIH TANGGAL =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionLabel("Pilih Tanggal", FontAwesomeIcons.calendarDay),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: provider.selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) provider.selectDate(picked);
                        },
                        child: Text(
                          "Lihat Kalender",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  _buildDateContainer(provider),

                  SizedBox(height: 25.h),

                  /// ===== PILIH JAM =====
                  _buildSectionLabel("Pilih Jam", FontAwesomeIcons.clock),
                  SizedBox(height: 12.h),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: 2.2,
                    ),
                    itemCount: provider.times.length,
                    itemBuilder: (context, index) {
                      final time = provider.times[index];
                      final isSelected = provider.selectedTime == time;
                      return _buildTimeCard(time, isSelected, () => provider.selectTime(time));
                    },
                  ),
                ],
              ),
            ),
          ),
          _buildBottomAction(context, provider),
        ],
      ),
    );
  }

  /// SOLUSI UTAMA: Menggunakan dynamic agar menerima FaIconData tanpa protes
  Widget _buildSectionLabel(String title, dynamic iconData) {
    return Row(
      children: [
        FaIcon(iconData, size: 16.sp, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
      ],
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
    required Color activeColor,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: activeColor,
      backgroundColor: AppColors.surface,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textDark,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13.sp,
      ),
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
        side: BorderSide(color: isSelected ? activeColor : AppColors.divider),
      ),
    );
  }

  Widget _buildDateContainer(BookingProvider provider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          // Perbaikan di sini juga menggunakan FaIcon
          FaIcon(FontAwesomeIcons.calendarCheck, color: AppColors.primary, size: 18.sp),
          SizedBox(width: 15.w),
          Text(
            DateFormat('EEEE, dd MMMM yyyy').format(provider.selectedDate),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard(String time, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isSelected ? AppColors.secondary : AppColors.divider),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textDark,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, BookingProvider provider) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Pembayaran",
                    style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
                  ),
                  Text(
                    "Rp 100.000",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                provider.createBooking();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Booking berhasil!"), backgroundColor: Colors.green),
                );
              },
              child: const Text("Booking Now"),
            ),
          ],
        ),
      ),
    );
  }
}
