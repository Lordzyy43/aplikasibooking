import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// Core & Providers
import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/providers/app_data_provider.dart';

// Models
import 'package:apkbooking/models/venue_model.dart';
import 'package:apkbooking/models/category_model.dart';

// Widgets - Common
import 'package:apkbooking/widgets/common/empty_state_view.dart';

// Widgets - Home
import 'package:apkbooking/widgets/home/home_header.dart';
import 'package:apkbooking/widgets/home/home_search_bar.dart';
import 'package:apkbooking/widgets/home/home_promo_banner.dart';
import 'package:apkbooking/widgets/home/home_category_list.dart';
import 'package:apkbooking/widgets/home/home_section_header.dart';

// Widgets - Booking & Venue
import 'package:apkbooking/widgets/booking/recent_booking_card.dart';
import 'package:apkbooking/widgets/venue/venue_card_recommended.dart';
import 'package:apkbooking/widgets/venue/venue_card_nearby.dart';

// Pages
import 'package:apkbooking/views/history/mybooking_page.dart';
import 'package:apkbooking/views/venue/venue_list_page.dart';
import 'package:apkbooking/views/venue/venue_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Logic filter yang sudah dioptimalkan
  List<VenueModel> _filterVenues(List<VenueModel> venues) {
    return venues.where((venue) {
      final matchesCategory =
          _selectedCategory == 'All' || venue.sports.contains(_selectedCategory);
      final keyword = _searchQuery.trim().toLowerCase();
      final matchesSearch =
          keyword.isEmpty ||
          venue.name.toLowerCase().contains(keyword) ||
          venue.location.toLowerCase().contains(keyword) ||
          venue.sports.any((s) => s.toLowerCase().contains(keyword));
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Fungsi refresh untuk menarik data terbaru dari provider
  Future<void> _onRefresh() async {
    // Simulasi refresh data
    await context.read<AppDataProvider>().loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan select untuk efisiensi rebuild
    final isLoaded = context.select((AppDataProvider p) => p.isLoaded);

    if (!isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final appData = context.watch<AppDataProvider>();
    final user = appData.user;

    // Transformasi kategori dengan icon mapping
    final List<CategoryModel> categories = appData.sportsCategories.take(6).map((item) {
      return CategoryModel(
        id: item.hashCode,
        name: item.toString(),
        icon: _getCategoryIcon(item.toString()),
      );
    }).toList();

    final filteredRecommended = _filterVenues(appData.recommendedVenues);
    final filteredNearby = _filterVenues(appData.nearbyVenues);

    final recentBooking =
        appData.upcomingBookings.firstOrNull ?? appData.completedBookings.firstOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header
                HomeHeader(userName: user.name),

                // 2. Search & Filter Section
                HomeSearchBar(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  onClear: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  onFilterTap: () {
                    // Reset filter atau buka BottomSheet filter
                    setState(() => _selectedCategory = 'All');
                  },
                ),

                SizedBox(height: 16.h),

                // 3. Promo Banner
                HomePromoBanner(
                  title: 'Promo Spesial!',
                  subtitle: 'Diskon hingga 50% untuk user baru.',
                  ctaLabel: 'Klaim Sekarang',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VenueListPage()),
                  ),
                ),

                SizedBox(height: 24.h),

                // 4. Kategori Olahraga
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kategori Olahraga',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (_selectedCategory != 'All')
                        GestureDetector(
                          onTap: () => setState(() => _selectedCategory = 'All'),
                          child: Text(
                            'Reset Filter',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
                HomeCategoryList(
                  categories: categories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) => setState(() => _selectedCategory = category),
                ),

                // 5. Main Content Area
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 28.h),

                      // Section: Booking Terakhir (Hanya muncul jika tidak sedang searching)
                      if (_searchQuery.isEmpty) ...[
                        HomeSectionHeader(
                          title: 'Booking Terakhir',
                          actionLabel: 'Riwayat',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MyBookingPage()),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        recentBooking != null
                            ? RecentBookingCard(booking: recentBooking)
                            : const EmptyStateView(
                                icon: Icons.calendar_today_outlined,
                                title: 'Belum ada jadwal',
                                message: 'Cari lapangan dan mulai main!',
                                compact: true,
                              ),
                        SizedBox(height: 32.h),
                      ],

                      // Section: Rekomendasi
                      HomeSectionHeader(
                        title: 'Rekomendasi Untukmu',
                        actionLabel: 'Lihat Semua',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const VenueListPage()),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildRecommendedList(filteredRecommended),

                      SizedBox(height: 32.h),

                      // Section: Venue Terdekat
                      const HomeSectionHeader(title: 'Disekitar Kamu'),
                      SizedBox(height: 12.h),
                      _buildNearbyList(filteredNearby),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget Helper agar kode build tidak terlalu gemuk
  Widget _buildRecommendedList(List<VenueModel> venues) {
    if (venues.isEmpty) {
      return const EmptyStateView(
        icon: Icons.search_off,
        title: 'Tidak ada hasil',
        message: 'Coba kata kunci lain',
        compact: true,
      );
    }
    return SizedBox(
      height: 270.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: venues.length,
        itemBuilder: (context, index) => VenueCardRecommended(
          venue: venues[index],
          onTap: () {
            // NAVIGASI KE DETAIL VENUE
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VenueDetailPage(venue: venues[index])),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNearbyList(List<VenueModel> venues) {
    if (venues.isEmpty) {
      return const EmptyStateView(
        icon: Icons.map_outlined,
        title: 'Tidak ditemukan',
        message: 'Venue tidak ada di lokasi ini',
        compact: true,
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: venues.length,
      itemBuilder: (context, index) => VenueCardNearby(
        venue: venues[index],
        onTap: () {
          /* Ke Detail */
        },
      ),
    );
  }

  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'futsal':
        return Icons.sports_soccer;
      case 'badminton':
        return Icons.sports_tennis;
      case 'basket':
        return Icons.sports_basketball;
      case 'voli':
        return Icons.sports_volleyball;
      case 'tennis':
        return Icons.sports_baseball;
      default:
        return Icons.sports_outlined;
    }
  }
}
