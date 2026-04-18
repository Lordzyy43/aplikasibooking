import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/views/main_screen.dart';
import 'package:apkbooking/providers/booking_provider.dart'; // Import BookingProvider

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    // Evolusi: Bungkus aplikasi di level paling atas dengan MultiProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        // Jika nanti ada AuthProvider atau GorProvider, tinggal tambah di sini
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sport Booking App',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(),
            scaffoldBackgroundColor: AppColors.background,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.surface,
              elevation: 0,
              centerTitle: true, // Tambahan: Biar semua AppBar otomatis center
              titleTextStyle: GoogleFonts.poppins(
                color: AppColors.textDark,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
              iconTheme: const IconThemeData(color: AppColors.textDark),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
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
