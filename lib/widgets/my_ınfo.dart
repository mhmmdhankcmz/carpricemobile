import 'package:carpricemobile/services/firestore_service.dart';
import 'package:flutter/material.dart';


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

                    Text("Eposta : ${veriList[index]["Eposta"]}",style: Theme.of(context).textTheme.bodyMedium,),
                    const Divider(indent: 50,endIndent: 50,),
                    Text("Telefon: ${veriList[index]["Telefon"]}",style: Theme.of(context).textTheme.bodyMedium),

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
