import 'package:cached_network_image/cached_network_image.dart';
import 'package:carpricemobile/pages/page_details.dart';
import 'package:carpricemobile/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  bool listType = false;
  List veriList = [];
  late bool login ;

  bool loggedIn(){
    if(user == null){
      login = false;
      return false;
    }else{
      login = true;
      return true;
    }
  }


  var user = FirebaseAuth.instance.currentUser?.email;
  var us = FireStoreDB().user;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: FutureBuilder(
          future: FireStoreDB().getFav(listType),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Birşeyler Yanlış gitti");
            }
            if(snapshot.data == null){
              return  Center( child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Favorileri Getirmeye Çalışıyorum",style: GoogleFonts.farro(fontSize: 20,color: Colors.orange),),
                  const SizedBox(height: 10,),
                  const CircularProgressIndicator()
                ],
              ));
            }
            if (snapshot.connectionState == ConnectionState.done) {
              veriList = snapshot.data as List;
              return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: veriList.length,
                  itemBuilder: (context, index) {
                    var aracFiyat = veriList[index]["AracFiyat"];
                    return Card(
                        color: Colors.transparent,
                            child:ListTile(
                                  leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(imageUrl: veriList[index]["AracResimUrl"],errorWidget: (context, url, error) => const Icon(Icons.error_outline),fit: BoxFit.fitWidth,width: 100,)),
                                  title: Text(
                                    veriList[index]["Marka"] ?? " boş",
                                    style: GoogleFonts.farro(fontSize: 18,color: Colors.yellow.shade300),
                                  ),
                                  trailing: Visibility(visible: loggedIn(),
                                    child: IconButton(
                                        onPressed: () {
                                          var fav = FirebaseFirestore.instance
                                              .collection('Favoriler');
                                          var user = FirebaseAuth.instance.currentUser;
                                          var aracId = veriList[index]["AracID"];

                                          fav.doc("${user?.uid}$aracId").delete().then(
                                              (value) =>
                                                  print("${user!.uid}$aracId silindi"));
                                          setState(() {});
                                        },
                                        icon: const Icon(CupertinoIcons.delete_simple)),
                                  ),
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>ProductDetails(aracID: veriList[index]["AracID"], vehicleType: veriList[index]["VasitaTipi"], caseType: veriList[index]["KasaTipi"], name: veriList[index]["Marka"], model: veriList[index]["Model"], imagePath: veriList[index]["AracResimUrl"], description: veriList[index]["AracOzellikleri"], price: veriList[index]["AracFiyat"], isLiked: veriList[index]["isLiked"], likeCount: veriList[index]["likeCount"])), (route) => false);
                                  },
                                  subtitle: RichText(text: TextSpan(text: "${veriList[index]["Model"]} \n",style:GoogleFonts.saira(fontSize: 18,color: Colors.grey),children: [
                                    TextSpan(text: "Favorileyen Sayısı ${veriList[index]["likeCount"]}",style: GoogleFonts.acme(fontSize: 12,color: Colors.cyanAccent.shade200)),
                                    TextSpan(text:" \n ${veriList[index]["AracFiyat"].toString().substring(0,aracFiyat.toString().length )} ",style: GoogleFonts.arya(fontSize: 16,color: Colors.redAccent.shade200))])),

                                ),
                        );
                  },
              );
            }
            return const RefreshProgressIndicator(
              color: Colors.orangeAccent,
            );
          }),
      // bottomNavigationBar:  bottomNavigationBar(),
    );
  }
}
