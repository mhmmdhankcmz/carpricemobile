import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextfield extends StatelessWidget {
 late final controller;
 late final String hinText;
 late final bool obscureText;
 late final Widget? iconButtons;
 final String? Function(String?) validate;
 final  AutovalidateMode? autoValidate;
 final TextInputType? keyboardType;
 final TextInputAction? textInputAction;
 final String? gelenIsim;
 final int maxLenghts;


 MyTextfield({super.key, required this.iconButtons,required this.controller,required this.hinText,required this.obscureText, required this.validate, required this.autoValidate,required this.keyboardType,required this.textInputAction, this.gelenIsim, required this.maxLenghts});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 80,
      child: TextFormField(
        initialValue: gelenIsim,
        validator: validate,
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLenghts),
        ],
        textInputAction:textInputAction,
        style: const TextStyle(fontSize: 13),
        controller: controller,
        autovalidateMode: autoValidate,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLength: maxLenghts,
        decoration: InputDecoration(
          suffixIcon: iconButtons,
            hintText: hinText,hintStyle: const TextStyle(fontSize: 15),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            enabledBorder:
               const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            fillColor: Colors.grey.shade600,
            filled: true,),

      ),
    );
  }
}
