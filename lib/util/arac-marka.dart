import 'package:flutter/material.dart';


class Marka extends StatelessWidget {
  final String coffeType;
  final bool isSelected;
  final VoidCallback onTap;


  const Marka({super.key, required this.coffeType, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: Text(coffeType,style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}
