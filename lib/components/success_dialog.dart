
import 'package:flutter/material.dart';
import 'package:qr_master/config/constanst.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';

/*
 * Component to show success dialog and redirect with a routes especifict
 * @author  SGV - 20250801
 * @version 1.0 - 20250801 - initial release
 * @return  <component> showDialog 
 */
class SuccessDialog extends StatefulWidget {

  const SuccessDialog({super.key});
  @override
  State<StatefulWidget> createState() => SuccessDialogState();
}

class SuccessDialogState extends State<SuccessDialog> with SingleTickerProviderStateMixin {
  // AnimationController controller;
  Animation<double>? scaleAnimation;
  AnimationController? controller;
  bool _mounted = false;


  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    scaleAnimation = CurvedAnimation(parent: controller!, curve: Curves.easeOutCirc);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 800)).then((_) {
        if(!_mounted){
          controller!.reverse().then((_) {
            Navigator.of(context).pop();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    _mounted = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation!,
          child: Container( 
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constants.borderRadius),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    IMGConst.check,
                    fit: BoxFit.cover,
                    width: 80,
                    height: 80,
                  ),
                  Text(translate("done!"),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.dark),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


/*
 * Show success dialog e redirect a route defined
 * @author  SGV - 20250801
 * @version 1.0 - 20250801 - initial release
 * @param   <BuildContext> context
 * @param   <String> routerName => route to redirect show dialog
 * @return  <component> showDialog 
 */
Future<void> showMessageForUser(BuildContext context,  {String? routeName,Object? arguments}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SuccessDialog();
    }
  );
  if (!context.mounted) return;
  if(routeName != null){  
      Navigator.of(context).pushNamedAndRemoveUntil(routeName,(route) => false, arguments:arguments);
  }else{
    Navigator.of(context).pop();
  }
  
}