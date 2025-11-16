import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_master/config/constanst.dart';
import 'package:qr_master/config/style.dart';

class TextFormFieldCustom extends StatefulWidget {  
  final TextEditingController? controller;
  final bool enabled;
  final bool autoFocus;
  final String? initialValue;
  final Function(String?)? onSaved;
  final String? labelText;
  final String? hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onTap;
  final Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final int? maxLines;
  final Widget? prefixIcon;
  final bool obscureText; 
  final int? minLines;
  final TextCapitalization textCapitalization;

  const TextFormFieldCustom({
    super.key,
    this.controller,
    this.enabled = true,
    this.autoFocus = false,
    this.initialValue,
    this.onSaved,
    this.labelText,
    this.inputFormatters,
    this.onChanged,
    this.validator,
    this.onTap,
    this.focusNode,
    this.onFieldSubmitted,
    this.maxLines,
    this.minLines,
    this.prefixIcon,
    this.hintText,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,  // Valor por defecto false
  });

  @override
  State<TextFormFieldCustom> createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends State<TextFormFieldCustom> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization:widget.textCapitalization,
      cursorColor: CustomColors.primary, 
      minLines:widget.minLines,
      obscureText: widget.obscureText && _isObscure,  // Oculta texto si es password
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      focusNode: widget.focusNode,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.maxLines ?? 1,
      controller: widget.controller,
      initialValue:widget.controller == null ? widget.initialValue : null,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
      enabled: widget.enabled,
      autofocus: widget.autoFocus,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        contentPadding: const EdgeInsets.fromLTRB(6, 10, 0, 0),
        floatingLabelBehavior: FloatingLabelBehavior.always, // 👈 siempre arriba
        floatingLabelStyle:  Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
        hintText: widget.hintText,
        labelText: widget.labelText,
        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
        fillColor:CustomColors.primaryDark,// widget.enabled ? CustomColors.colorFront : CustomColors.colorDark,
        filled: true,
        //floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: widget.obscureText  // Muestra icono solo para campos de password
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color:CustomColors.primaryDark,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.borderRadius),
            borderSide: BorderSide(color: CustomColors.error, width: 1),
          ),
          // BORDE BASE
          border: OutlineInputBorder(
            gapPadding: 4,
            borderRadius: BorderRadius.circular(Constants.borderRadius),
            borderSide: BorderSide(color: CustomColors.white, width: 1),
          ),

          // BORDE HABILITADO
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.borderRadius),
            borderSide: BorderSide(color: CustomColors.white, width: 1),
          ),

          // BORDE ENFOCADO
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.borderRadius),
            borderSide: BorderSide(
              color: CustomColors.white,
              width: 1.2,
            ),
          ),
          // BORDE ERROR
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.borderRadius),
            borderSide: BorderSide(color: CustomColors.error, width: 1),
          ),
        errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith( color:CustomColors.error),
        hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith( color:CustomColors.white),
      ),
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}