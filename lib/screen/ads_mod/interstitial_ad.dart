import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_master/config/constanst.dart';
/// Gestor simple para Interstitial en Android
class AndroidInterstitialManager {
  InterstitialAd? _ad;
  bool _loading = false;
  int _attempts = 0;
  static const int _maxAttempts = 3;

  void preload() {
    if (_loading || _ad != null) return;
    _loading = true;

    InterstitialAd.load(
      adUnitId: Constants.interstitialADS,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _loading = false;
          _attempts = 0;

          ad.setImmersiveMode(true);
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _ad = null;
              preload(); // deja listo el siguiente
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _ad = null;
              preload();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _loading = false;
          _ad = null;
          _attempts++;
          if (_attempts <= _maxAttempts) {
            Future.delayed(Duration(seconds: 2 * _attempts), preload);
          }
        },
      ),
    );
  }
  bool showIfReady() {
    final ad = _ad;
    if (ad == null) {
      preload(); // intenta dejarlo listo para la próxima
      return false;
    }
    ad.show();
    return true;
  }

  bool get isReady => _ad != null;

  void dispose() {
    _ad?.dispose();
    _ad = null;
  }
}
