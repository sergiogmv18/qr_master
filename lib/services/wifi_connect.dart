import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:plugin_wifi_connect/plugin_wifi_connect.dart';
import 'package:qr_master/widgets/content_type_wifi.dart';
import 'package:wifi_iot/wifi_iot.dart';

class WifiConnector with WidgetsBindingObserver {
  bool _inProgress = false;

  /// Llama antes de usar para observar ciclo de vida (opcional).
  void attach() => WidgetsBinding.instance.addObserver(this);
  void detach() => WidgetsBinding.instance.removeObserver(this);

  Future<bool> connectFromWifiQr(
    BuildContext context,
    String raw, {
    Duration focusSettle = const Duration(milliseconds: 200),
    Duration verifyTimeout = const Duration(seconds: 6),
  }) async {
    if (_inProgress) return false;
    _inProgress = true;
    try {
      final c = parseWifiQr(raw);
      if (c == null || c.ssid!.isEmpty) return false;

      // 1) Espera a que la app esté en primer plano y con foco estable
      if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
        return false; // evita llamarlo en background
      }
      // espera un frame + pequeño settle por si hay animaciones/ads/cámara
      await WidgetsBinding.instance.endOfFrame;
      await Future.delayed(focusSettle);

      // 2) Conexión con plugin_wifi_connect
      final type = (c.authType ?? 'WPA').toUpperCase();
      final isOpen = type == 'OPEN' || type == 'NOPASS';

      Future<bool> doConnect() {
        if (isOpen) {
          return PluginWifiConnect.connect(c.ssid!).then((v) => v ?? false);
        } else if (type == 'WPA3') {
          return PluginWifiConnect.connectToSecureNetwork(
            c.ssid!, c.password ?? '',
            isWpa3: true,
            saveNetwork: false,
          ).then((v) => v ?? false);
        } else if (type == 'WEP') {
          // Android 10+ no soporta WEP con este flujo
          return Future.value(false);
        } else {
          return PluginWifiConnect.connectToSecureNetwork(
            c.ssid!, c.password ?? '',
            saveNetwork: false,
          ).then((v) => v ?? false); // WPA/WPA2
        }
      }

      bool ok;
      try {
        ok = await doConnect();
      } on PlatformException catch (e) {
        final txt = ('${e.message} ${e.details}').toLowerCase();
        // Normalizamos los dos casos conocidos del plugin
        if (txt.contains('networkcallback was already unregistered') ||
            txt.contains('networkcallback was not registered')) {
          ok = true; // tratamos como "posible éxito", pasamos a verificar
        } else {
          ok = false;
        }
      }

      // 3) Verificación del SSID (confirma éxito real)
      final success = await _verifySsid(c.ssid!, timeout: verifyTimeout);
      return ok && success;
    } finally {
      _inProgress = false;
    }
  }

  Future<bool> _verifySsid(String target, {required Duration timeout}) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      try {
        final ssid = await WiFiForIoTPlugin.getSSID();
        if (ssid != null && ssid.replaceAll('"', '') == target) return true;
      } catch (_) {/* puede necesitar permisos si lees SSID en 12- */}
      await Future.delayed(const Duration(milliseconds: 300));
    }
    return false;
  }
}