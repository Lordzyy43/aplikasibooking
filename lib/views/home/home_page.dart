import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/providers/app_data_provider.dart';
import 'package:apkbooking/providers/auth_provider.dart';

import 'package:apkbooking/models/venue_model.dart';
import 'package:apkbooking/models/category_model.dart';

import 'package:apkbooking/widgets/common/empty_state_view.dart';

import 'package:apkbooking/widgets/home/home_header.dart';
import 'package:apkbooking/widgets/home/home_search_bar.dart';
import 'package:apkbooking/widgets/home/home_promo_banner.dart';
import 'package:apkbooking/widgets/home/home_category_list.dart';
import 'package:apkbooking/widgets/home/home_section_header.dart';

import 'package:apkbooking/widgets/booking/recent_booking_card.dart';
import 'package:apkbooking/widgets/venue/venue_card_recommended.dart';
import 'package:apkbooking/widgets/venue/venue_card_nearby.dart';

import 'package:apkbooking/views/history/mybooking_page.dart';
import 'package:apkbooking/views/venue/venue_list_page.dart';
import 'package:apkbooking/views/venue/venue_detail_page.dart';
import 'package:apkbooking/views/booking/booking_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'All';

  bool get _hasActiveFilter {
    return _searchQuery.trim().isNotEmpty || _selectedCategory != 'All';
  }

  List<VenueModel> _filterVenues(List<VenueModel> venues) {
    final keyword = _searchQuery.trim().toLowerCase();
    final selectedCategory = _selectedCategory.toLowerCase();

    return venues.where((venue) {
      final matchesCategory =
          selectedCategory == 'all' ||
          venue.sports.any((sport) => sport.toLowerCase() == selectedCategory);

      final matchesSearch =
          keyword.isEmpty ||
          venue.name.toLowerCase().contains(keyword) ||
          venue.location.toLowerCase().contains(keyword) ||
          venue.sports.any((sport) => sport.toLowerCase().contains(keyword));

      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<CategoryModel> _buildCategories(AppDataProvider appData) {
    final sportNames = <String>[
      'All',
      ...appData.sportsCategories.map((item) => item.toString()),
    ];

    final uniqueSportNames = sportNames.toSet().take(6).toList();

    return uniqueSportNames.map((name) {
      return CategoryModel(
        id: name.hashCode,
        name: name,
        icon: _getCategoryIcon(name),
      );
    }).toList();
  }

  Future<void> _onRefresh() async {
    await context.read<AppDataProvider>().loadInitialData();
  }

  void _setSearchQuery(String value) {
    if (_searchQuery == value) return;
    setState(() => _searchQuery = value);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedCategory = 'All';
    });
  }

  void _openVenueList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VenueListPage()),
    );
  }

  void _openBookingHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MyBookingPage()),
    );
  }

  void _openVenueDetail(VenueModel venue) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => VenueDetailPage(venue: venue)),
    );
  }

  void _showCategoryFilterSheet(List<CategoryModel> categories) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        String tempSelectedCategory = _selectedCategory;

        return StatefulBuilder(
          builder: (context, modalSetState) {
            return SafeArea(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLowest,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 4.h,
                        width: 44.w,
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(99.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 22.h),
                    Text(
                      'Filter Kategori',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Pilih jenis olahraga yang ingin kamu cari.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: categories.map((category) {
                        final isSelected =
                            tempSelectedCategory == category.name;

                        return ChoiceChip(
                          selected: isSelected,
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                category.icon,
                                size: 16.sp,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                              SizedBox(width: 6.w),
                              Text(category.name),
                            ],
                          ),
                          labelStyle: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.surfaceLow,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.divider.withValues(alpha: 0.55),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          onSelected: (_) {
                            modalSetState(() {
                              tempSelectedCategory = category.name;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _resetFilters();
                            },
                            child: const Text('Reset'),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                _selectedCategory = tempSelectedCategory;
                              });
                            },
                            child: const Text('Terapkan'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appData = context.watch<AppDataProvider>();
    final authUser = context.watch<AuthProvider>().user;

    if (!appData.isLoaded) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator.adaptive(),
              SizedBox(height: 16.h),
              Text(
                'Menyiapkan Aerobook...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final user = authUser ?? appData.user;
    final categories = _buildCategories(appData);

    final filteredRecommended = _filterVenues(appData.recommendedVenues);
    final filteredNearby = _filterVenues(appData.nearbyVenues);

    final totalFilteredVenues =
        filteredRecommended.length + filteredNearby.length;

    final recentBooking =
        appData.upcomingBookings.firstOrNull ??
        appData.completedBookings.firstOrNull;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        top: true,
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: theme.colorScheme.primary,
          backgroundColor: theme.cardColor,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    HomeHeader(userName: user.name),
                    HomeSearchBar(
                      controller: _searchController,
                      onChanged: _setSearchQuery,
                      onClear: _clearSearch,
                      onFilterTap: () => _showCategoryFilterSheet(categories),
                    ),
                  ],
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.only(top: 22.h, bottom: 128.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (!_hasActiveFilter) ...[
                      HomePromoBanner(onTap: _openVenueList),
                      SizedBox(height: 30.h),
                    ],

                    HomeSectionHeader(
                      title: 'Kategori Olahraga',
                      actionLabel: _hasActiveFilter ? 'Reset' : null,
                      onTap: _hasActiveFilter ? _resetFilters : null,
                    ),
                    SizedBox(height: 16.h),
                    HomeCategoryList(
                      categories: categories,
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (category) {
                        setState(() => _selectedCategory = category);
                      },
                    ),

                    if (_hasActiveFilter) ...[
                      SizedBox(height: 18.h),
                      _buildFilterSummary(totalFilteredVenues),
                    ],

                    SizedBox(height: 32.h),

                    if (!_hasActiveFilter) ...[
                      HomeSectionHeader(
                        title: 'Booking Terakhir',
                        actionLabel: 'Riwayat',
                        onTap: _openBookingHistory,
                      ),
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: recentBooking != null
                            ? RecentBookingCard(
                                booking: recentBooking,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BookingDetailPage(
                                        booking: recentBooking,
                                      ),
                                    ),
                                  );
                                },
                                onTicketTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BookingDetailPage(
                                        booking: recentBooking,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const EmptyStateView(
                                icon: Icons.calendar_today_outlined,
                                title: 'Belum ada jadwal',
                                message: 'Cari lapangan dan mulai main!',
                                compact: true,
                              ),
                      ),
                      SizedBox(height: 32.h),
                    ],

                    HomeSectionHeader(
                      title: _hasActiveFilter
                          ? 'Hasil Rekomendasi'
                          : 'Rekomendasi Untukmu',
                      actionLabel: 'Lihat Semua',
                      onTap: _openVenueList,
                    ),
                    SizedBox(height: 12.h),
                    _buildRecommendedList(filteredRecommended),

                    SizedBox(height: 32.h),

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
      ),
    );
  }

  Widget _buildFilterSummary(int totalVenues) {
    final keyword = _searchQuery.trim();

    String message;

    if (keyword.isNotEmpty && _selectedCategory != 'All') {
      message =
          'Menampilkan $totalVenues venue untuk "$keyword" di kategori $_selectedCategory.';
    } else if (keyword.isNotEmpty) {
      message = 'Menampilkan $totalVenues venue untuk pencarian "$keyword".';
    } else {
      message =
          'Menampilkan $totalVenues venue untuk kategori $_selectedCategory.';
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Container(
              height: 38.h,
              width: 38.h,
              decoration: BoxDecoration(
                color: AppColors.surfaceLowest,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.tune_rounded,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            InkWell(
              onTap: _resetFilters,
              borderRadius: BorderRadius.circular(999.r),
              child: Container(
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.primary,
                  size: 18.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
      height: 276.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: venues.length,
        separatorBuilder: (_, _) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final venue = venues[index];

          return VenueCardRecommended(
            venue: venue,
            onTap: () => _openVenueDetail(venue),
          );
        },
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
      separatorBuilder: (_, _) => SizedBox(height: 14.h),
      itemBuilder: (context, index) {
        final venue = venues[index];

        return VenueCardNearby(
          venue: venue,
          onTap: () => _openVenueDetail(venue),
        );
      },
    );
  }

  IconData _getCategoryIcon(String name) {
    final lowerName = name.toLowerCase();

    if (lowerName == 'all' || lowerName.contains('semua')) {
      return Icons.apps_rounded;
    }

    if (lowerName.contains('futsal') || lowerName.contains('soccer')) {
      return Icons.sports_soccer_rounded;
    }

    if (lowerName.contains('badminton')) {
      return Icons.sports_tennis_rounded;
    }

    if (lowerName.contains('basket')) {
      return Icons.sports_basketball_rounded;
    }

    if (lowerName.contains('voli') || lowerName.contains('volley')) {
      return Icons.sports_volleyball_rounded;
    }

    if (lowerName.contains('tennis')) {
      return Icons.sports_tennis_rounded;
    }

    return Icons.sports_outlined;
  }
}
