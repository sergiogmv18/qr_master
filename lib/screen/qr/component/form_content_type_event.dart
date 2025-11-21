import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_master/components/circular_progress_indicator.dart';
import 'package:qr_master/components/funcion_components.dart';
import 'package:qr_master/components/plan_current_suscription.dart';
import 'package:qr_master/components/text_form_fields.dart';
import 'package:qr_master/config/route_app.dart';
import 'package:qr_master/config/style.dart';
import 'package:qr_master/controllers/translation_controller.dart';
import 'package:qr_master/models/qr_type_event.dart';
import 'package:qr_master/provider/qr_create_provider.dart';
import 'package:qr_master/services/function_class.dart';

import '../../../components/text_form_field_date.dart';

class FormContentTypeEvent extends StatefulWidget {
  const FormContentTypeEvent({super.key});

  @override
  State<FormContentTypeEvent> createState() => _FormContentTypeEventState();
}

class _FormContentTypeEventState extends State<FormContentTypeEvent> {
  final formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController initialHour = TextEditingController();
  TextEditingController eventLocation = TextEditingController();
  TextEditingController description = TextEditingController();
  
  String lastInitialHourValue = '';
  String lastFinalHourValue = '';

  TextEditingController finalHour = TextEditingController();

  @override
  Widget build(BuildContext context) {
     return Consumer<QrCreateProvider>(
      builder: (context, provider, child){
        return Form(
        key: formKey,
        child: Column(
          spacing: MediaQuery.of(context).size.height * 0.03,
          children: [
            TextFormFieldCustom(
              controller: title,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              labelText:translate("event title"),
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return translate("please enter a valid value");
                }
                return null;
              },
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  title.clear();
                } else {
                  title.value.copyWith(text: value);
                }
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: provider.eventAllToday,
                  activeColor:CustomColors.primary,
                  fillColor:!provider.eventAllToday ?WidgetStateProperty.all(CustomColors.white): null,
                  checkColor: CustomColors.white,
                  hoverColor: CustomColors.success,
                   overlayColor: WidgetStateProperty.all(CustomColors.primary),
                  onChanged: (v) => provider.updateEventAllToday(v ?? true),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CustomColors.white),
                      children: [
                        TextSpan(text: translate("all-day event")),
                      
                      ],
                    ),
                  ),
                ),
              ],
            ),
//SELECT HOURS
            if(!provider.eventAllToday)...[
              Row(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
  // INITIAL HOUR
                  Expanded(
                    child: TextFormFieldCustom(
                      controller: initialHour,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        // Solo permitir números y ":" (opcional)
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
                        // Máximo 5 caracteres -> HH:mm
                        LengthLimitingTextInputFormatter(5),
                      ],
                      labelText: translate("initial hour"),
                      onChanged: (value) {
                        final text = value.trim();
                        // Si está borrando (el texto nuevo es más corto), no toques nada
                        final isDeleting = text.length < lastInitialHourValue.length;
                        if (text.isEmpty) {
                          initialHour.clear();
                        } else {
                          // Inserta ":" al escribir 2 números
                          if (!isDeleting && text.length == 2 && !text.contains(':')) {
                            final newText = '$text:';
                            initialHour.value = TextEditingValue(
                              text: newText,
                              selection: TextSelection.collapsed(offset: newText.length),
                            );
                            lastInitialHourValue = newText;
                            return; // salimos para no sobreescribir más abajo
                          }
                          // Guardamos el último valor para la próxima comparación
                          lastInitialHourValue = initialHour.text;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return translate("time is mandatory");
                        }
                        if (!FunctionsClass().isValidTime(value)) {
                          return translate("invalid time (use HH:mm)");
                        }
                        return null; // ✅ válido
                      },
                    ),
                  ),             
// FINAL HOURS
                  Expanded(
                    child: TextFormFieldCustom(
                      controller: finalHour,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        // Solo permitir números y ":" (opcional)
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
                        // Máximo 5 caracteres -> HH:mm
                        LengthLimitingTextInputFormatter(5),
                      ],
                      labelText: translate("final hour"),
                      onChanged: (value) {
                        final text = value.trim();
                        if (text.isEmpty) {
                          finalHour.clear();
                        } else {
                          // Inserta ":" al escribir 2 números
                          final isDeleting = text.length < lastFinalHourValue.length;
                          if (text.isEmpty) {
                            finalHour.clear();
                          } else {
                            // Inserta ":" al escribir 2 números
                            if (!isDeleting && text.length == 2 && !text.contains(':')) {
                              final newText = '$text:';
                              finalHour.value = TextEditingValue(
                                text: newText,
                                selection: TextSelection.collapsed(offset: newText.length),
                              );
                              lastFinalHourValue = newText;
                              return; // salimos para no sobreescribir más abajo
                            }
                            // Guardamos el último valor para la próxima comparación
                            lastFinalHourValue = finalHour.text;
                          }
                        }
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return translate("time is mandatory");
                        }
                        if (!FunctionsClass().isValidTime(value)) {
                          return translate("invalid time (use HH:mm)");
                        }
                        return null; // ✅ válido
                      },
                    ),
                  ),
                ],
              ),
            ],
            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
  // INVOICES DATE
                FuncionComponents.showTitleOfSelect(
                  context:context,
                  textWidth:(MediaQuery.of(context).size.width * 0.4 - 5),
                  label: translate("initial date"),
                  showIcon: false,
                  onTap: () async{
                    DateTime? initialDateEvent = await selectDate(context: context, lastDate: provider.finalDateEvent, initialDate:provider.initialDateEvent);
                    if(initialDateEvent != null){
                      if(!context.mounted) return;
                      provider.setInitialDateEvent(initialDateEvent);
                    }
                  },
                  controller: TextEditingController(text:jsonEncode({"name":FunctionsClass().formatDateAuto(context, provider.initialDateEvent)})),
                ),
               
  // FINAL DATE INVOICE
                FuncionComponents.showTitleOfSelect(
                  context:context,
                  textWidth:(MediaQuery.of(context).size.width * 0.4 - 5),
                  label:translate("final date"),
                  showIcon: false,
                  onTap: () async{
                    DateTime? finalDateEvent = await selectDate(context: context, firstDate:  provider.initialDateEvent, initialDate: provider.finalDateEvent);
                    if(finalDateEvent != null){
                      if(!context.mounted) return;
                      provider.setFinalDateEvent(finalDateEvent);
                    }
                  },
                  controller: TextEditingController(text:jsonEncode({"name":FunctionsClass().formatDateAuto(context, provider.finalDateEvent)})),
                ),
              ],
            ),
            TextFormFieldCustom(
              controller: eventLocation,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              labelText:translate("event location"),
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  eventLocation.clear();
                } else {
                  eventLocation.value.copyWith(text: value);
                }
              },
            ),
            TextFormFieldCustom(
              controller: description,
              textInputAction: TextInputAction.done,
              minLines: 3, 
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              labelText:translate("description"),
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  description.clear();
                } else {
                  description.value.copyWith(text: value);
                }
              },
            ),

            PlanBadgeCard(
              borderGradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [CustomColors.primary, CustomColors.primary], // aqua → violeta
              ),
              onTap: ()async{
                if (formKey.currentState!.validate()) {
                  showCircularLoadingDialog(context);
                  DateTime baseInitialDate = DateTime(
                    provider.finalDateEvent.year,
                    provider.finalDateEvent.month,
                    provider.finalDateEvent.day,
                  );
                  DateTime baseFinalDate = DateTime(
                    provider.finalDateEvent.year,
                    provider.finalDateEvent.month,
                    provider.finalDateEvent.day,
                  );

                  if(initialHour.text.isNotEmpty){
                    baseInitialDate = DateTime(
                      provider.finalDateEvent.year,
                      provider.finalDateEvent.month,
                      provider.finalDateEvent.day,
                      int.parse(initialHour.text.substring(0, 2)),
                      int.parse(initialHour.text.substring(initialHour.text.length - 2)), 
                    );
                  }
                  if(finalHour.text.isNotEmpty){
                    baseFinalDate = DateTime(
                      provider.finalDateEvent.year,
                      provider.finalDateEvent.month,
                      provider.finalDateEvent.day,
                      int.parse(finalHour.text.substring(0, 2)),
                      int.parse(finalHour.text.substring(finalHour.text.length - 2)), 
                    );
                  }
                  FunctionsClass.debugDumpAndDie(baseInitialDate);
                  QrTypeEvent qrTypeEvent = QrTypeEvent.createNew();
                  qrTypeEvent = qrTypeEvent.copyWith(
                    description: description.text,
                    title: title.text,
                    addressEvent: eventLocation.text,
                    finalDate: baseFinalDate,
                    initialDate: baseInitialDate,
                  );

                  String data = qrTypeEvent.toVEvent();

                 
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil(RouteAppName.createdQrScreen,(route) => false, arguments: data);
                }
              },
              child:Text(
                translate("create"), 
                style:Theme.of(context).textTheme.titleMedium!.copyWith(color: CustomColors.white),
                textAlign: TextAlign.center,
              )
            )
          ]
        )
      );
      }
     );
  }
}