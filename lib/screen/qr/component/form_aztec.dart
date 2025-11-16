import 'package:flutter/material.dart';
import 'package:qr_master/components/text_form_fields.dart';
class FormAztec extends StatefulWidget {
  const FormAztec({super.key});

  @override
  State<FormAztec> createState() => _FormAztecState();
}

class _FormAztecState extends State<FormAztec> {
  final formKey = GlobalKey<FormState>();
  TextEditingController recurrent = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: MediaQuery.of(context).size.height * 0.03,
        children: [
          TextFormFieldCustom(
            controller: recurrent,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            labelText: "Nombre del servicio",
            validator: (value) {
              if (value!.trim().isEmpty) {
                return 'Por favor ingrese un nombre válido';
              }
              return null;
            },
            onChanged: (value) {
              if (value.trim().isEmpty) {
                recurrent.clear();
              } else {
                recurrent.value.copyWith(text: value);
               // validateInputs.text = "validate";
              }
            },
          ),
        ]
      )
    );
  }
}
