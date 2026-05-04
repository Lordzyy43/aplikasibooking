import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:apkbooking/core/config/app_theme.dart'; // Sesuaikan dengan nama file tema baru
import 'package:apkbooking/providers/app_data_provider.dart';
import 'package:apkbooking/providers/booking_provider.dart';
import 'package:apkbooking/providers/auth_provider.dart';
import 'package:apkbooking/views/auth/onboarding_page.dart';

void main() {
  // Pastikan binding terinisialisasi sebelum melakukan konfigurasi sistem
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar jadi transparan agar menyatu dengan AppBar tema baru
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Kunci orientasi ke portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => AppDataProvider()..loadInitialData()),
      ],
      child: const ArenaApp(), // Nama diubah jadi lebih simple
    ),
  );
}

class ArenaApp extends StatelessWidget {
  const ArenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Menggunakan standar modern 390x844 (iPhone 13/14 size) agar scaling lebih pas
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Aerobook', // Nama aplikasi simpel
          // Menggunakan tema evolusi yang sudah kita buat
          theme: AppTheme.lightTheme,

          // Memastikan font scaling tidak merusak UI jika user mengubah font size di HP
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },

          home: const OnboardingPage(),
        );
      },
    );
  }
}
