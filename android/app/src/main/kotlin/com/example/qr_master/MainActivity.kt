package com.sgv.qr_master

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity : FlutterActivity() {

    // Debe coincidir con el factoryId que usarás en Dart (ej. "install_card")
    private val factoryId = "install_card"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Registra la factory nativa que renderiza tu NativeAd
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            factoryId,
            InstallCardFactory(this) // <-- clase que creamos abajo
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        // Limpia el registro para evitar fugas cuando el engine se destruye
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, factoryId)
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
