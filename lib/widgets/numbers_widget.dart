import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NumbersWidget extends StatelessWidget {
  int rakam;


  NumbersWidget(this.rakam, {super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildDivider(),
          buildButton(context,rakam,),
          buildDivider(),

      ],),
    );
  }

  Widget buildButton(BuildContext context, int rakam) {
    return MaterialButton(
      padding: const EdgeInsets.symmetric(vertical: 4),
      onPressed: (){},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(text: TextSpan(text: "Favori ",style: GoogleFonts.arya(fontSize: 20),children: [TextSpan(text: rakam.toString(),style: GoogleFonts.arya(fontSize: 22))])),
          const SizedBox(height: 2,),
        ],
      ),
    );
  }

  buildDivider() {
    return const VerticalDivider( thickness: 1, color: Colors.white,);
  }
}
