import 'package:carpricemobile/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MyInfo extends StatefulWidget {
  const MyInfo({Key? key}) : super(key: key);

  @override
  State<MyInfo> createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {

  bool listType = false;
  List veriList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FireStoreDB().getUser(listType),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Birşeyler Yanlış gitti");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            veriList = snapshot.data as List;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: veriList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [

                    Text("Eposta : ${veriList[index]["Eposta"]}",style: GoogleFonts.acme(fontSize: 12,color: Colors.white70),),
                    const Divider(indent: 50,endIndent: 50,),
                    Text("Telefon: ${veriList[index]["Telefon"]}",style: GoogleFonts.varela(fontSize: 12,color: Colors.white70)),

                    // Text(veriList[index]["AdSoyad"],style: const TextStyle(color: Colors.yellow,fontSize: 22),),
                  ],
                );
              },
            );
          }
          return const RefreshProgressIndicator(
            color: Colors.orangeAccent,
          );
        });
  }
}
