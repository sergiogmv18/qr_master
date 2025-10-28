import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_master/config/constanst.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/screen/ads_mod/interstitial_ad.dart';
import 'package:qr_master/services/function_class.dart';
import 'package:qr_master/screen/scan/result_sheet.dart';

class ScanQrProvider with ChangeNotifier {
  final MobileScannerController controllerQr = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
    formats: [BarcodeFormat.all],
  );

  final AndroidInterstitialManager _manager = AndroidInterstitialManager();
  bool _handled = false;
  bool _isTorchOn = false;
  bool _isScannerActive = true;
  bool? _hasTorch;

  bool get isTorchOn => _isTorchOn;
  bool get isScannerActive => _isScannerActive;
  bool get handled => _handled;
  bool? get hasTorch => _hasTorch;

  ScanQrProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _manager.preload();
    _checkTorchAvailability();
  }

  Future<void> _checkTorchAvailability() async {
    try {
      _hasTorch = controllerQr.torchEnabled;
      notifyListeners();
    } catch (e) {
      _hasTorch = false;
      notifyListeners();
    }
  }

  Future<void> toggleTorch() async {
    FunctionsClass.debugDumpAndDie("sdfsdf");
    try {
      await controllerQr.toggleTorch();
      _isTorchOn = !_isTorchOn;
      notifyListeners();
    } catch (e) {
      _isTorchOn = false;
      notifyListeners();
    }
  }

  Future<void> stopScanner() async {
    if (_isScannerActive) {
      await controllerQr.stop();
      _isScannerActive = false;
      notifyListeners();
    }
  }

  Future<void> startScanner() async {
    if (!_isScannerActive) {
      await controllerQr.start();
      _isScannerActive = true;
      _handled = false;
      notifyListeners();
    }
  }

  void setHandled(bool value) {
    _handled = value;
    notifyListeners();
  }

  Future<bool> showInterstitial() async {
    final showed = _manager.showIfReady();
    return showed;
  }

  Future<void> handleBarcode(Barcode barcode, BuildContext context) async {
    if (_handled) return;
    final raw = barcode.rawValue;
    if (raw == null || raw.isEmpty) return;

    _handled = true;
    await stopScanner();

    if (!context.mounted) return;
    Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => ResultScanScreen(value: raw, barcode:barcode, onDismiss: startScanner)));
  }

  @override
  void dispose() {
    _manager.dispose();
    controllerQr.dispose();
    super.dispose();
  }
}