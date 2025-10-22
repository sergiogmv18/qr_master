import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_master/components/plan_current_suscription.dart';
import 'package:qr_master/config/constanst.dart';
import 'package:qr_master/services/function_class.dart';

/// Llama esto una sola vez (por ejemplo, en main() antes de runApp):
/// WidgetsFlutterBinding.ensureInitialized();
/// await MobileAds.instance.initialize();

class AdaptiveBanner extends StatefulWidget {
  const AdaptiveBanner({
    super.key,
    this.backgroundColor = Colors.transparent,
    // Dejamos false para NO colapsar y así mostrar "cargando add" en fallo/cargando.
    this.collapseWhenFailed = false,
    this.placeholderHeight = 50,
    this.placeholderText = "",
  });


  /// Color del contenedor del banner.
  final Color backgroundColor;

  /// Si true, colapsa el espacio cuando falla.
  /// Si false, mantiene el espacio y muestra el placeholder/texto.
  final bool collapseWhenFailed;

  /// Altura usada mientras no se conoce el alto adaptativo.
  final double placeholderHeight;

  /// Texto mostrado mientras carga o si falla.
  final String placeholderText;

  @override
  State<AdaptiveBanner> createState() => _AdaptiveBannerState();
}

class _AdaptiveBannerState extends State<AdaptiveBanner> {
  BannerAd? _ad;
  AnchoredAdaptiveBannerAdSize? _adSize;
  bool _isLoaded = false;
  bool _failed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ad == null && !_failed) {
      _loadAd();
    }
  }

  Future<void> _loadAd() async {
    try {
      final width = MediaQuery.of(context).size.width.truncate();
      final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
      if (!mounted) return;

      if (size == null) {
        setState(() => _failed = true);
        FunctionsClass.debugDumpAndDie('Adaptive size null — no se pudo calcular tamaño del banner.');
        return;
      }

      _adSize = size;

      _ad = BannerAd(
        size: _adSize!,
        adUnitId:Constants.bannerADS,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (!mounted) return;
            setState(() => _isLoaded = true);
            FunctionsClass.debugDumpAndDie('Banner cargado: ${_adSize!.width}x${_adSize!.height}');
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (!mounted) return;
            setState(() {
              _failed = true;
              _isLoaded = false;
            });
            FunctionsClass.debugDumpAndDie('Banner falló al cargar: $error');
          },
          onAdOpened: (ad) => FunctionsClass.debugDumpAndDie('Banner abierto'),
          onAdClosed: (ad) => FunctionsClass.debugDumpAndDie('Banner cerrado'),
          onAdImpression: (ad) => FunctionsClass.debugDumpAndDie('Impresión de banner'),
        ),
      )..load();
    } catch (e) {
      if (!mounted) return;
      setState(() => _failed = true);
      FunctionsClass.debugDumpAndDie('Excepción cargando banner: $e');
    }
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Si quieres colapsar totalmente cuando falla
    if (_failed && widget.collapseWhenFailed) {
      return const SizedBox.shrink();
    }

    // Calcula altura del contenedor
    final height = _isLoaded
        ? _adSize?.height.toDouble()
        : (_adSize?.height.toDouble() ?? widget.placeholderHeight);
    if(_isLoaded && _ad != null){
      return PlanBadgeCard(
        child:Container(
          color: widget.backgroundColor,
          alignment: Alignment.center,
          width: double.infinity,
          height: height,
          child: AdWidget(ad: _ad!)
        )
      );
    }else{
      return Container();
    }
  }
}


