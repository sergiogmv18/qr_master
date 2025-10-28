import 'package:flutter/material.dart';
import 'package:qr_master/config/style.dart';

class PlanBadgeCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Gradient borderGradient;
  final double radius;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Widget? child;
  final void Function()? onTap;
  const PlanBadgeCard({
    super.key,
    this.title,
    this.subtitle,
    this.child,
    this.backgroundColor,
    this.onTap,
    this.borderGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [CustomColors.primary,CustomColors.secundary], // aqua → violeta
    ),
    this.radius = 18,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width:  MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // 1) marco degradé
          gradient: borderGradient,
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: const EdgeInsets.all(1.3), // grosor del borde
        child: Container(
          // 2) interior oscuro (surface)
          decoration: BoxDecoration(
            color:backgroundColor ?? const Color(0xFF111827), // ajusta a tu surface
            borderRadius: BorderRadius.circular(radius - 2),
            // brillo sutil para look “neón”
            boxShadow: const [
              BoxShadow(
                color: Color(0x9900E5FF), // usa el primer color del gradiente
                blurRadius: 18,
                spreadRadius: -6,
                offset: Offset(0, 6),
              ),
            ],
          ),
          padding: padding,
          child:child ?? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? "", // "Plan Free"
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle ?? "", // "3B-QR codes created"
                style: const TextStyle(
                  color: CustomColors.primary, // cian suave
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}