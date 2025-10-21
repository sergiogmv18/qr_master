import 'package:flutter/material.dart';
import 'package:qr_master/config/style.dart';

/*
 * reusable widget for screen titles in app bars
 * @author  SGV
 * @version 1.0 - 20250814 - initial release
 * @param   String name - text to display as screen title
 * @return  Widget - styled text widget for app bar titles
 * @note    designed specifically for consistent app bar titles
 *          uses predefined styling (headlineMedium, light weight)
 *          includes ellipsis overflow for long titles
 * @example 
 *   AppBar(
 *     title: NameScreens(name: "Products"),
 *   )
 */

class NameScreens  extends StatelessWidget{
  final String name;
  const NameScreens({super.key, required this.name}); // Constructor recomendado
  @override
  Widget build(BuildContext context) {
    return
    SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child:Text(
        name,
        style:Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w300,
          color: CustomColors.white
        ),
        maxLines:1,
        overflow: TextOverflow.ellipsis,
      )
    ); 
  }
}