import 'package:carpricemobile/design_config/padding_all25.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  Function()? onTap;
  String buttonName;

  MyButton({super.key, required this.buttonName,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(borderRadius: BorderRadius.circular(8),onTap: onTap,
      child: Container(
          padding: const PaddingAll.all(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black54,
          ),
          child: Center(
            child: Text(buttonName,style:  Theme.of(context).textTheme.bodyMedium,),
          )),
    );
  }
}
