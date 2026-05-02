import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// Core & Providers
import 'package:apkbooking/core/app_colors.dart';
import 'package:apkbooking/providers/app_data_provider.dart';

// Models
import 'package:apkbooking/models/venue_model.dart';

// Widgets
import 'package:apkbooking/widgets/common/empty_state_view.dart';
import 'package:apkbooking/widgets/home/home_search_bar.dart';
import 'package:apkbooking/widgets/venue/list/venue_list_card.dart';
import 'package:apkbooking/widgets/venue/list/venue_filter_tabs.dart';

// Pages
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- LOGIC FILTER ---
  List<VenueModel> _filterVenues(List<VenueModel> venues, String selectedSport) {
    final filteredBySport = selectedSport == 'All'
        ? venues
        : venues.where((v) => v.sports.contains(selectedSport)).toList();

    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return filteredBySport;

    return filteredBySport.where((v) {
      return v.name.toLowerCase().contains(query) ||
          v.location.toLowerCase().contains(query) ||
          v.sports.any((s) => s.toLowerCase().contains(query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppDataProvider>();

    if (!appData.isLoaded || appData.sportsCategories.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final sports = appData.sportsCategories;
    final safeIndex = _selectedCategoryIndex < sports.length ? _selectedCategoryIndex : 0;
    final selectedSport = sports[safeIndex];
    final venues = _filterVenues(appData.venues, selectedSport);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Eksplor Venue',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 18.sp,
              ),
            ),
          ),

          // 2. Search Bar
          SliverToBoxAdapter(
            child: HomeSearchBar(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              onClear: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
          ),

          // 3. Sticky Filter
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverFilterDelegate(
              child: VenueFilterTabs(
                sports: sports,
                selectedIndex: _selectedCategoryIndex,
                onChanged: (index) => setState(() => _selectedCategoryIndex = index),
              ),
            ),
          ),

          // 4. Content List
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
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
                      return VenueListCard(
                        venue: venue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => VenueDetailPage(venue: venue)),
                          );
                        },
                      );
                    }, childCount: venues.length),
                  ),
          ),
        ],
      ),
    );
  }
}

// --- CLASS DELEGATE (DI PERBAIKI) ---
class _SliverFilterDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverFilterDelegate({required this.child});

  // Dinaikkan ke 76.h agar tidak layout error (karena konten minta 74.6)
  @override
  double get minExtent => 76.h;
  @override
  double get maxExtent => 76.h;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background, // Mencegah konten list terlihat di bawah tab saat sticky
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverFilterDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
