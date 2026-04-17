import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Penting untuk mengatur warna status bar
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/views/main_screen.dart';

void main() {
  // Memastikan aplikasi hanya berorientasi portrait agar layout tidak rusak
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800), // Ukuran 800 lebih ideal untuk standar layar modern
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sport Booking App',
          theme: ThemeData(
            useMaterial3: true,
            // Warna dasar dari palet AppColors kita
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
            // Font Poppins terintegrasi global
            textTheme: GoogleFonts.poppinsTextTheme(),

            // --- Global Styles (Efisiensi Kode) ---
            scaffoldBackgroundColor: AppColors.background,

            // AppBar otomatis mengikuti tema aplikasi
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.surface,
              elevation: 0,
              titleTextStyle: GoogleFonts.poppins(
                color: AppColors.textDark,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
              iconTheme: const IconThemeData(color: AppColors.textDark),
            ),

            // Button otomatis mengikuti style primary
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
              ),
            ),
          ),
          home: const MainScreen(),
        );
      },
    );
  }
}
