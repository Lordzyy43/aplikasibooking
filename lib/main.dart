import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:apkbooking/core/config/app_theme.dart';
import 'package:apkbooking/providers/app_data_provider.dart';
import 'package:apkbooking/providers/booking_provider.dart'; // Import BookingProvider
import 'package:apkbooking/views/auth/onboarding_page.dart';
import 'package:apkbooking/providers/auth_provider.dart'; // Import AuthProvider

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    // Evolusi: Bungkus aplikasi di level paling atas dengan MultiProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => AppDataProvider()..load()),
        ChangeNotifierProvider(create: (_) => AuthProvider()), // Tambahkan AuthProvider
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
          title: 'ArenaFlow Booking',
          theme: AppTheme.lightTheme,
          home: const OnboardingPage(),
        );
      },
    );
  }
}
