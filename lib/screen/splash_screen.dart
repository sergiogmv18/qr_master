import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/components/pop_scope_custom.dart';
import 'package:qr_master/components/snack_bar_custom.dart';
import 'package:qr_master/config/constanst.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/base_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // Guarda el Future para no ejecutarlo más de una vez
  late final Future<String> _setupFuture;
  static const _fallbackRoute = '/home';        // <- cambia si tu ruta base es otra
  static const _timeout = Duration(seconds: 12); // tiempo máximo para init

  @override
  void initState() {
    super.initState();
    _setupFuture = BaseController().initialSetup();
    _startAppInitialization();
  }

  Future<void> _startAppInitialization() async {
    // Garantiza que el splash se vea al menos X ms
    final minimumDelay = Future.delayed(const Duration(milliseconds: 1500));

    try {
      // Espera init con timeout + el delay mínimo
      final results = await Future.wait([
        _setupFuture.timeout(_timeout),
        minimumDelay,
      ]);

      // Resultado del initialSetup()
      String url = (results.first as String?) ?? '';
      if (!mounted) return;

      // Valida ruta
      if (url.isEmpty || !_isKnownRoute(url)) {
        snackBarCustom(context, subtitle: 'Iniciando en modo estándar');
        url = _fallbackRoute;
      }

      // Navegación definitiva (quita el splash)
      Navigator.of(context).pushNamedAndRemoveUntil(url, (_) => false);

    } on TimeoutException {
      if (!mounted) return;
     // snackBarCustom(context, title: 'Tiempo de espera', subtitle: 'Iniciando en modo estándar');
      Navigator.of(context).pushNamedAndRemoveUntil(_fallbackRoute, (_) => false);

    } catch (e) {
      _handleInitializationError(e);
      if (!mounted) return;
      // Fallback para no quedar colgado
      Navigator.of(context).pushNamedAndRemoveUntil(_fallbackRoute, (_) => false);
    }
  }

  bool _isKnownRoute(String name) {
    // Si usas rutas nombradas estáticas, valida aquí.
    // Simplificado: acepta rutas que empiecen con '/'.
    return name.startsWith('/');
  }

  void _handleInitializationError(Object error) {
    debugPrint('Initialization error: $error');
    if (mounted) {
      //snackBarCustom(context, subtitle: 'Error, por favor intente de nuevo', title: 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return popScopeCustom(
      canPop: false,
      child: Scaffold(
        backgroundColor: CustomColors.primaryDark,
        body: Center(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                IMGConst.logo,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.4,
              ),
              SizedBox(height: 10),
              Text(
                Constants.nameApp,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: CustomColors.white),
              ),
              SizedBox(height: 10),
              circularProgressIndicator(context)
            ],
          ) 
          
        ),
      ),
    );
  }
}
