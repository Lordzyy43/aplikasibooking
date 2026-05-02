import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/booking_model.dart';
import '../../models/venue_model.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/common/app_remote_image.dart';
import '../../widgets/common/empty_state_view.dart';
import '../history/mybooking_page.dart';
import '../notification/notification_page.dart';
import '../venue/venue_detail_page.dart';
import '../venue/venue_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppDataProvider>();

    if (!appData.isLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = appData.user;
    final categories = appData.sportsCategories.take(6).toList();
    final filteredRecommended = _filterVenues(appData.recommendedVenues);
    final filteredNearby = _filterVenues(appData.nearbyVenues);
    final recentBooking = appData.upcomingBookings.isNotEmpty
        ? appData.upcomingBookings.first
        : (appData.completedBookings.isNotEmpty ? appData.completedBookings.first : null);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(user.name),
              _buildSearchBar(),
              _buildPromoBanner(
                title: appData.promo.title,
                subtitle: appData.promo.subtitle,
                ctaLabel: appData.promo.ctaLabel,
              ),
              _buildCategorySection(categories),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    _buildSectionHeader(
                      'Booking Terakhir',
                      'Riwayat',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyBookingPage()),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    if (recentBooking != null)
                      _buildRecentBookingCard(recentBooking)
                    else
                      const EmptyStateView(
                        icon: Icons.event_busy_outlined,
                        title: 'Belum ada booking',
                        message: 'Mulai pilih venue favoritmu untuk melihat riwayat booking di sini.',
                        compact: true,
                      ),
                    SizedBox(height: 24.h),
                    _buildSectionHeader(
                      'Venue Rekomendasi',
                      'Lihat Semua',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VenueListPage()),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    if (filteredRecommended.isNotEmpty)
                      _buildRecommendedList(context, filteredRecommended)
                    else
                      const EmptyStateView(
                        icon: Icons.search_off_rounded,
                        title: 'Venue tidak ditemukan',
                        message: 'Coba ubah kata kunci atau pilih kategori olahraga lain.',
                        compact: true,
                      ),
                    SizedBox(height: 30.h),
                    _buildSectionHeader('Terdekat Dari Kamu', null),
                    SizedBox(height: 16.h),
                    if (filteredNearby.isNotEmpty)
                      _buildNearbyList(context, filteredNearby)
                    else
                      const EmptyStateView(
                        icon: Icons.location_off_outlined,
                        title: 'Belum ada venue terdekat',
                        message: 'Filter yang aktif sedang menyembunyikan semua venue.',
                        compact: true,
                      ),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<VenueModel> _filterVenues(List<VenueModel> venues) {
    return venues.where((venue) {
      final matchesCategory =
          _selectedCategory == 'All' || venue.sports.contains(_selectedCategory);
      final keyword = _searchQuery.trim().toLowerCase();
      final matchesSearch = keyword.isEmpty ||
          venue.name.toLowerCase().contains(keyword) ||
          venue.location.toLowerCase().contains(keyword) ||
          venue.sports.any((sport) => sport.toLowerCase().contains(keyword));
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Widget _buildHeader(String userName) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang,',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
                ),
                SizedBox(height: 2.h),
                Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          InkWell(
            borderRadius: BorderRadius.circular(999.r),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationPage()),
            ),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(11.w),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLowest,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.solidBell,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                Positioned(
                  right: 3,
                  top: 3,
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner({
    required String title,
    required String subtitle,
    required String ctaLabel,
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: 170.h),
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryContainer],
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24.w,
            bottom: -24.h,
            child: Icon(
              Icons.sports_tennis,
              size: 160.sp,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    'Promo minggu ini',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  width: 210.w,
                  child: Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VenueListPage()),
                  ),
                  borderRadius: BorderRadius.circular(999.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLowest.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ctaLabel,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 11.sp,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(Icons.arrow_forward_rounded, size: 14.sp, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Cari venue, lokasi, atau olahraga',
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
          suffixIcon: _searchQuery.isEmpty
              ? IconButton(
                  onPressed: () => setState(() => _selectedCategory = 'All'),
                  icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
                )
              : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(List<String> categories) {
    final icons = <String, FaIconData>{
      'Tennis': FontAwesomeIcons.tableTennisPaddleBall,
      'Soccer': FontAwesomeIcons.futbol,
      'Basketball': FontAwesomeIcons.basketball,
      'Volleyball': FontAwesomeIcons.volleyball,
      'Badminton': FontAwesomeIcons.tableTennisPaddleBall,
      'All': FontAwesomeIcons.layerGroup,
    };

    return SizedBox(
      height: 110.h,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 20.w, top: 16.h),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final iconData = icons[category] ?? FontAwesomeIcons.layerGroup;
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: InkWell(
              onTap: () => setState(() => _selectedCategory = category),
              borderRadius: BorderRadius.circular(20.r),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.secondaryContainer.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: FaIcon(
                      iconData,
                      color: isSelected ? Colors.white : AppColors.primary,
                      size: 20,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: 72.w,
                    child: Text(
                      category,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentBookingCard(BookingModel booking) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(11.w),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: const FaIcon(
              FontAwesomeIcons.medal,
              color: AppColors.accent,
              size: 18,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.venueName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${booking.sport} • ${booking.courtName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 11.sp),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VenueListPage()),
            ),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999.r)),
            ),
            child: Text(
              'Booking Lagi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? action, {VoidCallback? onTap}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (action != null)
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(999.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Text(
                action,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRecommendedList(BuildContext context, List<VenueModel> venues) {
    return SizedBox(
      height: 284.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: venues.length,
        itemBuilder: (context, index) {
          final venue = venues[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VenueDetailPage(venue: venue)),
            ),
            child: Container(
              width: 260.w,
              margin: EdgeInsets.only(right: 18.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceLowest,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      AppRemoteImage(
                        imageUrl: venue.imageUrl,
                        height: 140.h,
                        width: 260.w,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLowest.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            venue.sports.first,
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          venue.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          venue.location,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textMuted,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLow,
                                borderRadius: BorderRadius.circular(999.r),
                              ),
                              child: Text(
                                '${venue.distanceKm.toStringAsFixed(1)} km',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              CurrencyFormatter.idr(venue.pricePerHour),
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              '/jam',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 10.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNearbyList(BuildContext context, List<VenueModel> venues) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: venues.length,
      itemBuilder: (context, index) {
        final venue = venues[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => VenueDetailPage(venue: venue)),
          ),
          child: Container(
            margin: EdgeInsets.only(bottom: 15.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                AppRemoteImage(
                  width: 76.w,
                  height: 76.w,
                  imageUrl: venue.imageUrl,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        venue.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${venue.sports.join(' • ')} • ${venue.distanceKm.toStringAsFixed(1)} km',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textMuted,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, size: 14.sp, color: AppColors.accent),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              '${venue.rating} (${venue.reviewCount} ulasan)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
