import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoffeType extends StatelessWidget {
  final String coffeType;
  final bool isSelected;
  final VoidCallback onTap;


  const CoffeType({super.key, required this.coffeType, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: Text(coffeType,style: GoogleFonts.saira(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.orange)),
      ),
    );
  }
}
