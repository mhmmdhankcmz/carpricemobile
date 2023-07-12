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
        style: Theme.of(context).textTheme.labelMedium,
        controller: controller,
        autovalidateMode: autoValidate,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLength: maxLenghts,
        decoration: InputDecoration(
          suffixIcon: iconButtons,
            hintText: hinText,hintStyle: Theme.of(context).textTheme.labelMedium,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            enabledBorder:
               const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            fillColor: const Color(0xD2E6E7FF),
            filled: true,),

      ),
    );
  }
}
