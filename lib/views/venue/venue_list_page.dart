import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/providers/app_data_provider.dart';

import 'package:apkbooking/models/venue_model.dart';

import 'package:apkbooking/widgets/common/empty_state_view.dart';
import 'package:apkbooking/widgets/home/home_search_bar.dart';
import 'package:apkbooking/widgets/venue/list/venue_filter_tabs.dart';
import 'package:apkbooking/widgets/venue/list/venue_list_card.dart';

import 'package:apkbooking/views/venue/venue_detail_page.dart';

class VenueListPage extends StatefulWidget {
  const VenueListPage({super.key});

  @override
  State<VenueListPage> createState() => _VenueListPageState();
}

class _VenueListPageState extends State<VenueListPage> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedCategoryIndex = 0;
  String _searchQuery = '';

  bool get _hasSearch => _searchQuery.trim().isNotEmpty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _buildSports(List<String> source) {
    final sports = <String>['All'];

    for (final item in source) {
      final value = item.trim();

      if (value.isEmpty) continue;

      final alreadyExists = sports.any((sport) => sport.toLowerCase() == value.toLowerCase());

      if (!alreadyExists && value.toLowerCase() != 'all') {
        sports.add(value);
      }
    }

    return sports;
  }

  List<VenueModel> _filterVenues({
    required List<VenueModel> venues,
    required String selectedSport,
  }) {
    final selected = selectedSport.toLowerCase();
    final query = _searchQuery.trim().toLowerCase();

    return venues.where((venue) {
      final matchesSport =
          selected == 'all' || venue.sports.any((sport) => sport.toLowerCase() == selected);

      final matchesSearch =
          query.isEmpty ||
          venue.name.toLowerCase().contains(query) ||
          venue.location.toLowerCase().contains(query) ||
          venue.sports.any((sport) => sport.toLowerCase().contains(query));

      return matchesSport && matchesSearch;
    }).toList();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedCategoryIndex = 0;
    });
  }

  void _openVenueDetail(VenueModel venue) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => VenueDetailPage(venue: venue)));
  }

  void _showSportFilterSheet(List<String> sports) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        int tempSelectedIndex = _selectedCategoryIndex;

        return StatefulBuilder(
          builder: (context, modalSetState) {
            return SafeArea(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLowest,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
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
                      'Filter Venue',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Pilih kategori olahraga untuk menemukan venue yang sesuai.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: List.generate(sports.length, (index) {
                        final sport = sports[index];
                        final isSelected = tempSelectedIndex == index;

                        return ChoiceChip(
                          selected: isSelected,
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getSportIcon(sport),
                                size: 16.sp,
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                              ),
                              SizedBox(width: 6.w),
                              Text(_displaySportName(sport)),
                            ],
                          ),
                          labelStyle: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w900,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                          ),
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.surfaceLow,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.divider.withValues(alpha: 0.55),
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                          onSelected: (_) {
                            modalSetState(() => tempSelectedIndex = index);
                          },
                        );
                      }),
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
                                _selectedCategoryIndex = tempSelectedIndex;
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
  Widget build(BuildContext context) {
    final appData = context.watch<AppDataProvider>();
    final theme = Theme.of(context);

    if (!appData.isLoaded) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator.adaptive(),
              SizedBox(height: 16.h),
              Text(
                'Memuat venue...',
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

    final sports = _buildSports(appData.sportsCategories);
    final safeIndex = _selectedCategoryIndex < sports.length ? _selectedCategoryIndex : 0;
    final selectedSport = sports[safeIndex];

    final venues = _filterVenues(venues: appData.venues, selectedSport: selectedSport);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildHeroHeader(
                    context,
                    totalVenue: appData.venues.length,
                    visibleVenue: venues.length,
                    selectedSport: selectedSport,
                  ),
                  HomeSearchBar(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                    onClear: _clearSearch,
                    onFilterTap: () => _showSportFilterSheet(sports),
                  ),
                ],
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverFilterDelegate(
                child: VenueFilterTabs(
                  sports: sports,
                  selectedIndex: safeIndex,
                  onChanged: (index) {
                    setState(() => _selectedCategoryIndex = index);
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: _buildResultSummary(
                context,
                visibleVenue: venues.length,
                selectedSport: selectedSport,
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 128.h),
              sliver: venues.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyStateView(
                        icon: Icons.travel_explore_outlined,
                        title: 'Venue tidak ditemukan',
                        message: 'Coba kata kunci atau kategori lain.',
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final venue = venues[index];

                        return VenueListCard(venue: venue, onTap: () => _openVenueDetail(venue));
                      }, childCount: venues.length),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(
    BuildContext context, {
    required int totalVenue,
    required int visibleVenue,
    required String selectedSport,
  }) {
    final theme = Theme.of(context);
    final canPop = Navigator.canPop(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.22),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -38.w,
              top: -40.h,
              child: _buildGlowCircle(size: 124.h, color: Colors.white.withValues(alpha: 0.10)),
            ),
            Positioned(
              left: -44.w,
              bottom: -46.h,
              child: _buildGlowCircle(
                size: 118.h,
                color: AppColors.accentGold.withValues(alpha: 0.16),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (canPop) ...[
                      Material(
                        color: Colors.white.withValues(alpha: 0.16),
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          customBorder: const CircleBorder(),
                          child: SizedBox(
                            height: 42.h,
                            width: 42.h,
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 17.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                    ],
                    Container(
                      height: 46.h,
                      width: 46.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                      ),
                      child: Icon(Icons.travel_explore_rounded, color: Colors.white, size: 24.sp),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Eksplor Venue',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Temukan lapangan terbaik di sekitarmu',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.82),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatPill(
                        context,
                        label: 'Venue',
                        value: totalVenue.toString(),
                        icon: Icons.stadium_rounded,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _buildStatPill(
                        context,
                        label: _displaySportName(selectedSport),
                        value: visibleVenue.toString(),
                        icon: _getSportIcon(selectedSport),
                        color: AppColors.accentGold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatPill(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18.sp),
          SizedBox(width: 8.w),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSummary(
    BuildContext context, {
    required int visibleVenue,
    required String selectedSport,
  }) {
    final theme = Theme.of(context);
    final sportLabel = _displaySportName(selectedSport);

    String message;

    if (_hasSearch && selectedSport.toLowerCase() != 'all') {
      message = '$visibleVenue venue ditemukan untuk "$_searchQuery" di kategori $sportLabel.';
    } else if (_hasSearch) {
      message = '$visibleVenue venue ditemukan untuk "$_searchQuery".';
    } else if (selectedSport.toLowerCase() != 'all') {
      message = '$visibleVenue venue tersedia untuk kategori $sportLabel.';
    } else {
      message = '$visibleVenue venue tersedia di sekitar kamu.';
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceLowest,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.28)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.045),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 38.h,
              width: 38.h,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.62),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(Icons.tune_rounded, color: AppColors.primary, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ),
            if (_hasSearch || selectedSport.toLowerCase() != 'all') ...[
              SizedBox(width: 8.w),
              InkWell(
                onTap: _resetFilters,
                borderRadius: BorderRadius.circular(999.r),
                child: Container(
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close_rounded, color: AppColors.primary, size: 18.sp),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _displaySportName(String name) {
    if (name.toLowerCase() == 'all') {
      return 'Semua';
    }

    return name;
  }

  IconData _getSportIcon(String name) {
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

    return Icons.sports_rounded;
  }

  Widget _buildGlowCircle({required double size, required Color color}) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _SliverFilterDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverFilterDelegate({required this.child});

  @override
  double get minExtent => 82.h;

  @override
  double get maxExtent => 82.h;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: AppColors.background, alignment: Alignment.center, child: child);
  }

  @override
  bool shouldRebuild(covariant _SliverFilterDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
