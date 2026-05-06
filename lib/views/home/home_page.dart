import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// Core & Providers
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

  // --- Logic Layer ---

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

  Future<void> _onRefresh() async {
    await context.read<AppDataProvider>().loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- UI Layer ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appData = context.watch<AppDataProvider>();

    // 1. Loading State
    if (!appData.isLoaded) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    // 2. Data Preparation
    final user = appData.user;
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
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: theme.colorScheme.primary,
        backgroundColor: theme.cardColor,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Sticky-like Header & Search
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 12.h),
                  HomeHeader(userName: user.name),
                  HomeSearchBar(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    onClear: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    onFilterTap: () => setState(() => _selectedCategory = 'All'),
                  ),
                ],
              ),
            ),

            // Main Content Body
            SliverPadding(
              padding: EdgeInsets.only(top: 24.h, bottom: 40.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Section 1: Promo
                  HomePromoBanner(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VenueListPage()),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // Section 2: Categories (Clean & Seragam)
                  HomeSectionHeader(
                    title: "Kategori Olahraga",
                    actionLabel: _selectedCategory != 'All' ? "Reset Filter" : null,
                    onTap: () => setState(() => _selectedCategory = 'All'),
                  ),
                  SizedBox(height: 16.h),
                  HomeCategoryList(
                    categories: categories,
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (category) => setState(() => _selectedCategory = category),
                  ),

                  SizedBox(height: 32.h),

                  // Section 3: Recent Booking
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: recentBooking != null
                          ? RecentBookingCard(booking: recentBooking)
                          : const EmptyStateView(
                              icon: Icons.calendar_today_outlined,
                              title: 'Belum ada jadwal',
                              message: 'Cari lapangan dan mulai main!',
                              compact: true,
                            ),
                    ),
                    SizedBox(height: 32.h),
                  ],

                  // Section 4: Recommendations
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

                  // Section 5: Nearby Venues
                  const HomeSectionHeader(title: 'Disekitar Kamu'),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: _buildNearbyList(filteredNearby),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Refactored Helper Widgets ---

  Widget _buildRecommendedList(List<VenueModel> venues) {
    if (venues.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: const EmptyStateView(
          icon: Icons.search_off,
          title: 'Tidak ada hasil',
          message: 'Coba kata kunci atau kategori lain',
          compact: true,
        ),
      );
    }
    return SizedBox(
      height: 270.h,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: venues.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: VenueCardRecommended(
            venue: venues[index],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VenueDetailPage(venue: venues[index])),
            ),
          ),
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
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: venues.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (context, index) => VenueCardNearby(
        venue: venues[index],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VenueDetailPage(venue: venues[index])),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('futsal')) return Icons.sports_soccer;
    if (lowerName.contains('badminton')) return Icons.sports_tennis;
    if (lowerName.contains('basket')) return Icons.sports_basketball;
    if (lowerName.contains('voli')) return Icons.sports_volleyball;
    if (lowerName.contains('tennis')) return Icons.sports_baseball;
    return Icons.sports_outlined;
  }
}
