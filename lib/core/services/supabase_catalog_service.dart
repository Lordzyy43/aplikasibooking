import 'package:apkbooking/models/venue_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseCatalogService {
  SupabaseCatalogService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<String>> getSports() async {
    final rows = await _client
        .from('sports')
        .select('name')
        .eq('is_active', true)
        .order('name');

    return rows
        .map((row) => row['name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
  }

  Future<List<VenueModel>> getVenues() async {
    final rows = await _client
        .from('venues')
        .select('''
          id,
          name,
          description,
          address,
          city,
          status,
          venue_images(image_url, sort_order, is_primary),
          venue_amenities(amenities(name)),
          courts(
            id,
            name,
            surface,
            environment,
            price_per_hour,
            status,
            average_rating,
            review_count,
            sports(name),
            court_images(image_url, sort_order, is_primary)
          )
        ''')
        .eq('status', 'open')
        .order('name');

    return rows.map((row) => VenueModel.fromSupabase(row)).toList();
  }
}
