import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_master/components/app_bar.dart';
import 'package:qr_master/components/botton_navigator_bar.dart';
import 'package:qr_master/components/name_app_bar.dart';
import 'package:qr_master/components/pop_scope_custom.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/screen/ads_mod/banner_ad.dart';
import 'package:qr_master/screen/ads_mod/interstitial_ad.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  final _manager = AndroidInterstitialManager();
  final controllerQr = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode], // solo QR
  );
    bool _handled = false;
  
    @override
  void initState() {
    super.initState();
      _manager.preload();
     
  }


  @override
  void dispose() {
    _manager.dispose();
    controllerQr.dispose();
    super.dispose();
  }

  Future<void> _onAction() async {
    final showed = _manager.showIfReady();
    if (!showed && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Interstitial aún no está listo.')),
      );
    }
  }

  Future<void> _handleBarcode(Barcode barcode) async {
    if (_handled) return;
    final raw = barcode.rawValue;
    if (raw == null || raw.isEmpty) return;

    _handled = true;
    await controllerQr.stop();

    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121826),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => _ResultSheet(value: raw),
    );

    // reanudar
    _handled = false;
    await controllerQr.start();
  }


  @override
   Widget build(BuildContext context) {
     final cian = const Color(0xFF00F5D4);

    return popScopeCustom(
      canPop: false,
      child: Scaffold(
        backgroundColor: CustomColors.primaryDark,
        appBar: appBarCustom(
          context,
          showButtonReturn: true,
          onTap: () async{
             await _onAction();
          },
          title: NameScreens(name: translate("scan QR"))
        ),
        floatingActionButtonAnimator:FloatingActionButtonAnimator.scaling,
        bottomNavigationBar: BottonNavigatorBarCustom(),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              AdaptiveBanner(),
    //            ValueListenableBuilder<MobileScannerState>(
    //   valueListenable: controllerQr.state,
    //   builder: (context, state, _) {
    //     final hasTorch = state.hasCameraPermission; // el dispositivo tiene flash?
    //     final torchOn  = state.torchState == TorchState.on;

    //     return IconButton(
    //       tooltip: 'Linterna',
    //       onPressed: hasTorch ? controllerQr.toggleTorch : null,
    //       icon: Icon(torchOn ? Icons.flash_on : Icons.flash_off),
    //     );
    //   },
    // ),
              Expanded(child: 
               Stack(
                fit: StackFit.expand,
                children: [
                  // Cámara
                  MobileScanner(
                    controller: controllerQr,
                    onDetect: (capture) {
                      final b = capture.barcodes;
                      if (b.isNotEmpty) _handleBarcode(b.first);
                    },
                  ),
                  // Marco
                  IgnorePointer(
                    child: CustomPaint(
                      painter: ScanFramePainter(
                        stroke: 4,
                        radius: 18,
                        color: cian.withOpacity(0.9),
                        gap: 28,
                        length: 38,
                      ),
                    ),
                  ),
                ],
              
               )
          ),
// DETAILS OF PLAN         
              // PlanBadgeCard(
              //   title: 'Plan Free',
              //   subtitle: translate('unlimited scans • 5 free creations.'),
              // ),
// SCAN QR

  
            ],
          )  
        ),
      
    );
  }
}


class ScanFramePainter extends CustomPainter {
  final double stroke, radius, gap, length;
  final Color color;
  ScanFramePainter({
    required this.stroke,
    required this.radius,
    required this.gap,
    required this.length,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final inner = Rect.fromLTWH(gap, gap, rect.width - gap * 2, rect.height - gap * 2);
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    void corner(Offset o, double dx, double dy) {
      canvas.drawLine(o, o + Offset(dx * length, 0), p);
      canvas.drawLine(o, o + Offset(0, dy * length), p);
    }

    corner(inner.topLeft, 1, 1);
    corner(Offset(inner.right, inner.top), -1, 1);
    corner(Offset(inner.left, inner.bottom), 1, -1);
    corner(Offset(inner.right, inner.bottom), -1, -1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ----- hoja de resultados
class _ResultSheet extends StatelessWidget {
  final String value;
  const _ResultSheet({required this.value});

  bool get _isUrl => Uri.tryParse(value)?.hasScheme ?? false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 4, width: 44, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(99))),
          const SizedBox(height: 16),
          Text('Código detectado', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SelectableText(value, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Row(
            children: [
              // Expanded(
              //   child: FilledButton.icon(
              //     onPressed: () async {
              //       await Clipboard.setData(ClipboardData(text: value));
              //       if (context.mounted) Navigator.pop(context);
              //     },
              //     icon: const Icon(Icons.copy),
              //     label: const Text('Copiar'),
              //   ),
              // ),
              const SizedBox(width: 12),
              // Expanded(
              //   child: OutlinedButton.icon(
              //     onPressed: _isUrl ? () => launchUrlString(value, mode: LaunchMode.externalApplication) : null,
              //     icon: const Icon(Icons.open_in_new),
              //     label: const Text('Abrir'),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}