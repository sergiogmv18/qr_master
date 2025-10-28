// lib/ads/native_ad_provider.dart
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdProvider extends ChangeNotifier {
  final String adUnitId;         // passe por ambiente (test/prod)
  final String factoryId;        // deve bater com a factory nativa
  final Map<String, Object>? customOptions;

  NativeAd? _ad;
  bool _isLoaded = false;
  bool _isLoading = false;

  NativeAdProvider({
    required this.adUnitId,
    required this.factoryId,
    this.customOptions,
  });

  bool get isLoaded => _isLoaded;
  NativeAd? get ad => _ad;

  Future<void> load() async {
    if (_isLoading || _isLoaded) return;
    _isLoading = true;

    final native = NativeAd(
      adUnitId: adUnitId,
      factoryId: factoryId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _ad = ad as NativeAd;
          _isLoaded = true;
          _isLoading = false;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _ad = null;
          _isLoaded = false;
          _isLoading = false;
          debugPrint('NativeAd falhou: $error');
          notifyListeners();
        },
        onAdOpened: (_) {},
        onAdClosed: (_) {},
        onAdImpression: (_) {},
        onPaidEvent: (_, valueMicros, precision, currency) {
          // opcional: monetização
        },
      ),
      request: const AdRequest(),
      nativeAdOptions: NativeAdOptions(
        mediaAspectRatio: MediaAspectRatio.any,
        // muteThisAd: true, // opcional
      ),
      customOptions: customOptions,
    );

    await native.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }
}
