import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppRemoteImage extends StatelessWidget {
  const AppRemoteImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  static bool isAssetPath(String imageUrl) {
    return imageUrl.startsWith('assets/');
  }

  static ImageProvider imageProvider(String imageUrl) {
    if (isAssetPath(imageUrl)) {
      return AssetImage(imageUrl);
    }
    return CachedNetworkImageProvider(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    if (isAssetPath(imageUrl)) {
      final image = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            _ImageFallback(width: width, height: height),
      );

      if (borderRadius == null) {
        return image;
      }

      return ClipRRect(borderRadius: borderRadius!, child: image);
    }

    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: const Color(0xFFE7E8EB),
        alignment: Alignment.center,
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: const Color(0xFFE7E8EB),
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: Color(0xFF737685),
        ),
      ),
    );

    if (borderRadius == null) {
      return image;
    }

    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFE7E8EB),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Color(0xFF737685),
      ),
    );
  }
}
