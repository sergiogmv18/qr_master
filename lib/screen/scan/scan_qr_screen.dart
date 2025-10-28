import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_master/components/app_bar.dart';
import 'package:qr_master/components/botton_navigator_bar.dart';
import 'package:qr_master/components/name_app_bar.dart';
import 'package:qr_master/components/pop_scope_custom.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/provider/provider_scanqr.dart';
import 'package:qr_master/screen/ads_mod/banner_ad.dart';
import 'package:qr_master/widgets/scan_frame_painter.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen>  with WidgetsBindingObserver {
   late ScanQrProvider provider;

    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    provider = ScanQrProvider();
    // Iniciar scanner al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.startScanner();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    provider.stopScanner();
    // Importante: dispose del provider
    provider.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
    value: provider,
    child: const _ScanQrScreenContent(),
  );
  }
}



class _ScanQrScreenContent extends StatelessWidget {
  const _ScanQrScreenContent();

  @override
  Widget build(BuildContext context) {
    return popScopeCustom(
      canPop: false,
      child: Scaffold(
        backgroundColor: CustomColors.primaryDark,
        appBar: appBarCustom(
          context,
          showButtonReturn: true,
          onTap: () async {
            final provider = context.read<ScanQrProvider>();
            await provider.showInterstitial();
            if(!context.mounted) return;
            Navigator.of(context).pushNamedAndRemoveUntil(RouteAppName.homeScreen,(route) => false);
          },
          title: NameScreens(name: translate("scan QR")),
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        bottomNavigationBar: const BottonNavigatorBarCustom(redirectToHome: true),
        body:Consumer<ScanQrProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AdaptiveBanner(),
                Expanded(
                  child:_buildScanner(context,provider),
                ),
                SizedBox(height: 20, width: double.infinity),
                _buildTorchButton(context,provider),
                SizedBox(height: 40, width: double.infinity)
              ],
            );
          },
        ),
           
      ),
    );
  }

  Widget _buildTorchButton(BuildContext context, ScanQrProvider provider) {
    if (provider.hasTorch == null) {
      return const IconButton(
        icon: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        onPressed: null,
      );
    }
    return IconButton(
      tooltip: 'Linterna',
      onPressed:(){
        if(!provider.hasTorch!){
          provider.toggleTorch();
        }
      } ,
      icon:Icon(provider.isTorchOn ? Icons.flash_on : Icons.flash_off),
      color:provider.isTorchOn ? CustomColors.primary : CustomColors.white,
    );
  }

  Widget _buildScanner(BuildContext context, ScanQrProvider provider) {
    return Consumer<ScanQrProvider>(
      builder: (context, provider, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: provider.controllerQr,
              onDetect: (capture) {
                final b = capture.barcodes;
                if (b.isNotEmpty) {
                  provider.handleBarcode(b.first, context);
                }
              },
            ),
            IgnorePointer(
              child: CustomPaint(
                painter: ScanFramePainter(
                  stroke: 5,
                  radius: 80,
                  color: CustomColors.primary,
                  gap: 28,
                  length: 28,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}