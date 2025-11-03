import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/models/barcode_spec.dart';
import 'package:qr_master/models/content_type.dart';
import 'package:qr_master/provider/qr_create_provider.dart';
import '../../components/app_dropdown.dart';

class CreateQrScreen extends StatefulWidget {
  const CreateQrScreen({super.key});

  @override
  State<CreateQrScreen> createState() => _CreateQrScreenState();
}

class _CreateQrScreenState extends State<CreateQrScreen> {
  

  @override
  Widget build(BuildContext context) {
    return Consumer<QrCreateProvider>(
      builder: (context, provider, child){
        return SingleChildScrollView(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 30, top: 30),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              AppDropdown<BarcodeSpec>(
                label: translate("code type") ,
                items:provider.entriesDropdownMenu,
                value: provider.selectedDropdownItem,
                onChanged: (val) {
                  if (val == null) return;
                  provider.updateSelectDropdownItem(val);
                },
                width: MediaQuery.of(context).size.width - 32, // full-width con margen
                enableFilter: false,
              ),
              if(provider.showSecundaryDropdownMenu)...[
                AppDropdown<ContentTypeModel>(
                  label: translate("select format") ,
                  items:provider.entriesSecundaryDropdownMenu,
                  value: provider.selectedDropdownItemSecundary,
                  onChanged: (val) {
                    if (val == null) return;
                    provider.updateSelectDropdownItemSecundary(val);
                  },
                  width: MediaQuery.of(context).size.width - 32, // full-width con margen
                  enableFilter: false,
                ),
              ]
                      
            ]
          )
        );
      }
    );
  
  }
}



enum QrBadgeVariant { rounded, circle, outline, ribbon }

class QrBadge extends StatelessWidget {
  final String data;
  final String label;
  final String? sublabel;            // ej. "PROMO CODE"
  final QrBadgeVariant variant;
  final Color bg;
  final Color fg;                    // color de módulos del QR
  final Color eye;                   // color de los “ojos”
  final Color accent;                // botón/contorno
  final IconData? icon;              // pequeño ícono arriba
  final bool dots;                   // módulos redondeados
  final double size;

  const QrBadge({
    super.key,
    required this.data,
    this.label = 'SCAN ME',
    this.sublabel,
    this.variant = QrBadgeVariant.rounded,
    this.bg = Colors.white,
    this.fg = Colors.black,
    this.eye = Colors.black,
    this.accent = Colors.black,
    this.icon,
    this.dots = false,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    final content = _cardContent();
    switch (variant) {
      case QrBadgeVariant.circle:
        return ClipOval(child: content);
      case QrBadgeVariant.outline:
        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accent, width: 3),
            boxShadow: const [BoxShadow(blurRadius: 8, color: Color(0x16000000), offset: Offset(0,4))],
          ),
          child: content,
        );
      case QrBadgeVariant.ribbon:
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(blurRadius: 8, color: Color(0x16000000), offset: Offset(0,4))],
              ),
              child: content,
            ),
            Positioned(
              bottom: -12,
              left: 24,
              right: 24,
              child: _Ribbon(color: accent),
            ),
          ],
        );
      case QrBadgeVariant.rounded:
      default:
        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(blurRadius: 8, color: Color(0x16000000), offset: Offset(0,4))],
          ),
          child: content,
        );
    }
  }

  Widget _cardContent() {
    final qr = QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      gapless: false,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
      eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: eye),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: dots ? QrDataModuleShape.circle : QrDataModuleShape.square,
        color: fg,
      ),
      backgroundColor: Colors.transparent,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accent.withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accent, size: 18),
            ),
            const SizedBox(height: 8),
          ],
          qr,
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.1,
              ),
            ),
          ),
          if (sublabel != null) ...[
            const SizedBox(height: 6),
            Text(
              sublabel!.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(.55),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class _Ribbon extends StatelessWidget {
  final Color color;
  const _Ribbon({required this.color});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 16),
      painter: _RibbonPainter(color),
    );
  }
}

class _RibbonPainter extends CustomPainter {
  final Color color;
  _RibbonPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color;
    final w = size.width, h = size.height;
    final path = Path()
      ..moveTo(0, 0)..lineTo(w, 0)..lineTo(w - 16, h)..lineTo(16, h)..close();
    canvas.drawPath(path, p);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
