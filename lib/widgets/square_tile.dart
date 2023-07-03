import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
   const SquareTile({Key? key,required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(color: Colors.grey,border: Border.all(color: Colors.white30,),borderRadius: BorderRadius.circular(16)),
      child: Image.asset(imagePath,fit: BoxFit.fitWidth,height: 40,),
    );
  }
}
