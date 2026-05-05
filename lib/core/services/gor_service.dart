import 'package:apkbooking/models/venue_model.dart';

const _badmintonHallImage = 'assets/images/Venue/Venue1.jpg';
const _tennisCourtImage = 'assets/images/Venue/Venue2.jpg';
const _badmintonActionImage = 'assets/images/Venue/Venue3.jpg';
const _venueOneCanteenImage = 'assets/images/Venue/canteen1.jpg';
const _venueOneBathroomImage = 'assets/images/Venue/kamarmandi1.jpg';
const _venueOneParkingImage = 'assets/images/Venue/parking1.jpg';
const _venueOneChangingRoomImage = 'assets/images/Venue/lokerroom1.jpg';
const _venueTwoCanteenImage = 'assets/images/Venue/centeen2.jpg';
const _venueTwoBathroomImage = 'assets/images/Venue/kamarmandi2.jpg';
const _venueTwoParkingImage = 'assets/images/Venue/parking2.jpg';
const _venueTwoChangingRoomImage = 'assets/images/Venue/lokkerroom2.jpg';
const _venueThreeCanteenImage = 'assets/images/Venue/centeen3.jpg';
const _venueThreeBathroomImage = 'assets/images/Venue/kamarmandi3.jpg';
const _venueThreeChangingRoomImage = 'assets/images/Venue/lokerroom3.jpg';
const _stadiumCourtOneImage = 'assets/images/Court/badminton1.jpg';
const _stadiumCourtOneSideImage = 'assets/images/Court/badminton2.jpg';
const _stadiumCourtOneDetailImage = 'assets/images/Court/badminton3.jpg';
const _stadiumCourtTwoImage = 'assets/images/Court/badminton4.jpg';
const _stadiumCourtTwoSideImage = 'assets/images/Court/badminton5.jpg';
const _stadiumCourtTwoDetailImage = 'assets/images/Court/badminton6.jpg';
const _stadiumCourtThreeImage = 'assets/images/Court/badminton7.jpg';
const _stadiumCourtThreeSideImage = 'assets/images/Court/badminton8.jpg';
const _grandSlamCourtImage = 'assets/images/Court/tennis1.jpg';
const _grandSlamCourtSideImage = 'assets/images/Court/tennis2.jpg';
const _grandSlamCourtDetailImage = 'assets/images/Court/tennis3.jpg';
const _grandSlamCourtGalleryImage = 'assets/images/Court/tennis4.jpg';
const _grandSlamCourtLightImage = 'assets/images/Court/tennis5.jpg';
const _grandSlamCourtBaselineImage = 'assets/images/Court/tennis6.jpg';
const _grandSlamCourtNetImage = 'assets/images/Court/tennis7.jpg';
const _grandSlamCourtWideImage = 'assets/images/Court/tennis8.jpg';
const _smashCourtImage = 'assets/images/Court/badminton5.jpg';
const _smashCourtSideImage = 'assets/images/Court/badminton6.jpg';
const _smashCourtDetailImage = 'assets/images/Court/badminton8.jpg';
const _avatarImage = 'assets/Avatar/Avatar.png';

class GorService {
  const GorService();

  List<VenueModel> getVenues() {
    const commonTimes = [
      '08:00',
      '09:00',
      '10:00',
      '11:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '19:00',
      '20:00',
      '21:00',
      '22:00',
    ];

    return const [
      VenueModel(
        id: 'stadium-atelier',
        name: 'Stadium Atelier',
        location: 'Olympic Sports Complex, Solo Baru, Sukoharjo',
        distanceKm: 1.2,
        imageUrl: _badmintonHallImage,
        galleryUrls: [
          _badmintonHallImage,
          _venueOneCanteenImage,
          _venueOneBathroomImage,
          _venueOneParkingImage,
          _venueOneChangingRoomImage,
        ],
        rating: 4.8,
        reviewCount: 120,
        pricePerHour: 120000,
        sports: ['Badminton', 'Tennis'],
        amenities: ['WiFi', 'Shower', 'Socket', 'Mineral', 'Parkir'],
        statusLabel: 'OPEN',
        description:
            'Premium indoor venue with concierge-style service and clean modern courts.',
        reviews: [
          VenueReviewModel(
            author: 'Alya',
            avatarUrl: _avatarImage,
            rating: 4.9,
            comment:
                'Venue bersih, lampu terang, dan staff cepat bantu waktu check-in.',
            timeLabel: '2 hari lalu',
            hasPhoto: true,
          ),
          VenueReviewModel(
            author: 'Raka',
            avatarUrl: _avatarImage,
            rating: 4.7,
            comment:
                'Area tunggu nyaman dan parkir luas. Cocok buat sparring malam.',
            timeLabel: '1 minggu lalu',
          ),
          VenueReviewModel(
            author: 'Nadia',
            avatarUrl: _avatarImage,
            rating: 4.8,
            comment:
                'Lantai court enak dipakai dan sirkulasi udara terasa adem.',
            timeLabel: '2 minggu lalu',
            hasPhoto: true,
          ),
        ],
        courts: [
          VenueCourtModel(
            id: 'court-01',
            name: 'Grand Court 01',
            imageUrl: _stadiumCourtOneImage,
            galleryUrls: [
              _stadiumCourtOneImage,
              _stadiumCourtOneSideImage,
              _stadiumCourtOneDetailImage,
            ],
            surface: 'Vinyl Premium',
            environment: 'Indoor',
            pricePerHour: 100000,
            specs: {
              'Lantai': 'Vinyl Premium',
              'Lampu': 'LED High-Bay',
              'Ventilasi': 'Exhaust Fan Pro',
            },
            availableTimes: commonTimes,
            bookedTimes: ['10:00', '14:00'],
          ),
          VenueCourtModel(
            id: 'court-02',
            name: 'Grand Court 02',
            imageUrl: _stadiumCourtTwoImage,
            galleryUrls: [
              _stadiumCourtTwoImage,
              _stadiumCourtTwoSideImage,
              _stadiumCourtTwoDetailImage,
            ],
            surface: 'Interlock Pro',
            environment: 'Indoor',
            pricePerHour: 100000,
            specs: {
              'Lantai': 'Interlock Pro',
              'Lampu': 'LED Match',
              'Ventilasi': 'Air Flow Plus',
            },
            availableTimes: commonTimes,
            bookedTimes: ['09:00', '20:00'],
          ),
          VenueCourtModel(
            id: 'court-03',
            name: 'Grand Court 03',
            imageUrl: _stadiumCourtThreeImage,
            galleryUrls: [
              _stadiumCourtThreeImage,
              _stadiumCourtThreeSideImage,
              _stadiumCourtOneDetailImage,
            ],
            surface: 'Rubber Shock',
            environment: 'Indoor',
            pricePerHour: 110000,
            specs: {
              'Lantai': 'Rubber Shock',
              'Lampu': 'LED High-Bay',
              'Ventilasi': 'Air Flow Plus',
            },
            availableTimes: commonTimes,
            bookedTimes: ['11:00', '21:00'],
          ),
        ],
      ),
      VenueModel(
        id: 'grand-slam',
        name: 'Grand Slam Arena',
        location: 'Solo Center District',
        distanceKm: 2.4,
        imageUrl: _tennisCourtImage,
        galleryUrls: [
          _tennisCourtImage,
          _venueTwoCanteenImage,
          _venueTwoBathroomImage,
          _venueTwoParkingImage,
          _venueTwoChangingRoomImage,
        ],
        rating: 4.9,
        reviewCount: 98,
        pricePerHour: 95000,
        sports: ['Tennis'],
        amenities: ['WiFi', 'Shower', 'Parkir'],
        statusLabel: 'OPEN',
        description:
            'Bright training courts with tournament-standard lighting.',
        reviews: [
          VenueReviewModel(
            author: 'Kevin',
            avatarUrl: _avatarImage,
            rating: 5.0,
            comment: 'Permukaan lapangan mantap dan area venue terasa premium.',
            timeLabel: '3 hari lalu',
          ),
          VenueReviewModel(
            author: 'Sinta',
            avatarUrl: _avatarImage,
            rating: 4.8,
            comment:
                'Booking cepat dan layout venue enak buat datang bareng teman.',
            timeLabel: '6 hari lalu',
            hasPhoto: true,
          ),
        ],
        courts: [
          VenueCourtModel(
            id: 'grand-a',
            name: 'Center Court',
            imageUrl: _grandSlamCourtImage,
            galleryUrls: [
              _grandSlamCourtImage,
              _grandSlamCourtSideImage,
              _grandSlamCourtDetailImage,
              _grandSlamCourtGalleryImage,
              _grandSlamCourtLightImage,
              _grandSlamCourtBaselineImage,
              _grandSlamCourtNetImage,
              _grandSlamCourtWideImage,
            ],
            surface: 'Synthetic Acrylic',
            environment: 'Indoor',
            pricePerHour: 95000,
            specs: {
              'Lantai': 'Synthetic Acrylic',
              'Lampu': 'Focus LED',
              'Ventilasi': 'Cross Flow',
            },
            availableTimes: commonTimes,
            bookedTimes: ['15:00'],
          ),
        ],
      ),
      VenueModel(
        id: 'smash-club',
        name: 'The Smash Club',
        location: 'Kartasura Sports Hub',
        distanceKm: 3.1,
        imageUrl: _badmintonActionImage,
        galleryUrls: [
          _badmintonActionImage,
          _venueThreeCanteenImage,
          _venueThreeBathroomImage,
          _venueThreeChangingRoomImage,
        ],
        rating: 4.7,
        reviewCount: 144,
        pricePerHour: 85000,
        sports: ['Badminton'],
        amenities: ['WiFi', 'Mineral', 'Parkir'],
        statusLabel: 'OPEN',
        description:
            'Fast and friendly badminton club for weekly sparring and league nights.',
        reviews: [
          VenueReviewModel(
            author: 'Dito',
            avatarUrl: _avatarImage,
            rating: 4.7,
            comment:
                'Tempatnya santai, gampang dicapai, dan admin cepat merespons.',
            timeLabel: '1 hari lalu',
          ),
          VenueReviewModel(
            author: 'Mira',
            avatarUrl: _avatarImage,
            rating: 4.6,
            comment: 'Cocok untuk latihan rutin. Harga juga masih masuk akal.',
            timeLabel: '5 hari lalu',
          ),
        ],
        courts: [
          VenueCourtModel(
            id: 'smash-a',
            name: 'Court A',
            imageUrl: _smashCourtImage,
            galleryUrls: [
              _smashCourtImage,
              _smashCourtSideImage,
              _smashCourtDetailImage,
            ],
            surface: 'Wood Finish',
            environment: 'Indoor',
            pricePerHour: 85000,
            specs: {
              'Lantai': 'Wood Finish',
              'Lampu': 'Daylight LED',
              'Ventilasi': 'Smart Fan',
            },
            availableTimes: commonTimes,
            bookedTimes: ['08:00', '16:00'],
          ),
        ],
      ),
    ];
  }
}
