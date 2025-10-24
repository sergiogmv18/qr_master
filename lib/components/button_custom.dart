import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JuicyButton extends StatefulWidget {
  final String label;
  final void Function()? onTap;
  final IconData? icon;
  /// Gradiente principal del botón (obligatorio si quieres colores custom)
  /// Contorno sutil para “pop”
  final Color borderColor;
  final double height;
  final double radius;
  final Color? background;
  
  const JuicyButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.background,
    this.borderColor = const Color(0x22000000),
    this.height = 64,
    this.radius = 18,
  });
  

  @override
  State<JuicyButton> createState() => _JuicyButtonState();
}

class _JuicyButtonState extends State<JuicyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap:widget.onTap,
      child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            color:widget.background,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(color: widget.borderColor, width: 1),
            boxShadow: const [
              // sombra base (suave y ancha)
              BoxShadow(
                color: Color(0x33000000),
                offset: Offset(0, 8),
                blurRadius: 20,
                spreadRadius: 1,
              ),
              // sombra de contacto
              BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // brillo superior (gloss sutil)
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.radius),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: const [
                          Colors.white12,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // contenido
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: Colors.white, size: 26),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    widget.label,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      letterSpacing: .2,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}



