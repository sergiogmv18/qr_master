// lib/ads/native_ad_card.dart
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:qr_master/provider/provider_native_ad.dart';

class NativeAdCard extends StatelessWidget {
  final double? height; // defina conforme seu layout
  final EdgeInsets padding;
  final BorderRadius radius;

  const NativeAdCard({
    super.key,
    this.height,
    this.padding = const EdgeInsets.all(12),
    this.radius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NativeAdProvider>(
      builder: (_, provider, __) {
        if (!provider.isLoaded || provider.ad == null) {
          // esqueletinho leve
          return _Skeleton(radius: radius, height: height);
        }
        return ClipRRect(
          borderRadius: radius,
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            height: height, // pode ser null se a factory for auto-size
            padding: padding,
            child: AdWidget(ad: provider.ad!),
          ),
        );
      },
    );
  }
}

class _Skeleton extends StatelessWidget {
  final BorderRadius radius;
  final double? height;
  const _Skeleton({required this.radius, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 160,
      decoration: BoxDecoration(
        borderRadius: radius,
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.25),
      ),
      padding: const EdgeInsets.all(16),
      child: const Row(
        children: [
          Expanded(child: SizedBox.shrink()),
        ],
      ),
    );
  }
}
