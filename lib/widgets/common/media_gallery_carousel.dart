import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:apkbooking/widgets/common/app_remote_image.dart';

class MediaGalleryCarousel extends StatefulWidget {
  const MediaGalleryCarousel({
    super.key,
    required this.images,
    required this.height,
    this.borderRadius,
  });

  final List<String> images;
  final double height;
  final BorderRadius? borderRadius;

  @override
  State<MediaGalleryCarousel> createState() => _MediaGalleryCarouselState();
}

class _MediaGalleryCarouselState extends State<MediaGalleryCarousel> {
  // Tambahkan viewportFraction 1.0 agar gambar full satu layar
  late final PageController _pageController;
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Jika gambar kosong, tampilkan placeholder agar tidak error
    if (widget.images.isEmpty) {
      return Container(
        height: widget.height,
        color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported),
      );
    }

    final content = Stack(
      children: [
        // 1. Image Slider
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (value) => setState(() => _activeIndex = value),
            itemBuilder: (context, index) {
              return AppRemoteImage(
                imageUrl: widget.images[index],
                width: double.infinity,
                height: widget.height,
              );
            },
          ),
        ),

        // 2. Index Counter (Kanan Atas)
        Positioned(
          top: 14.h,
          right: 14.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              '${_activeIndex + 1}/${widget.images.length}',
              style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w700),
            ),
          ),
        ),

        // 3. Dot Indicators (Bawah Tengah)
        Positioned(
          left: 0,
          right: 0,
          bottom: 14.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              final isActive = index == _activeIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250), // Sedikit lebih lambat biar elegan
                width: isActive ? 18.w : 7.w,
                height: 7.w,
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(999.r),
                ),
              );
            }),
          ),
        ),
      ],
    );

    if (widget.borderRadius == null) return content;

    return ClipRRect(borderRadius: widget.borderRadius!, child: content);
  }
}
