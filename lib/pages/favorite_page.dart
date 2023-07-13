import 'package:cached_network_image/cached_network_image.dart';
import 'package:carpricemobile/design_config/color.dart';
import 'package:carpricemobile/pages/page_details.dart';
import 'package:carpricemobile/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  bool listType = false;
  List veriList = [];
  List favNumber = [];
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

  void getFavNum(){
    FireStoreDB().getFav(listType,);
  }


  var user = FirebaseAuth.instance.currentUser?.email;
  var us = FireStoreDB().user;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        body: FutureBuilder(
            future: FireStoreDB().getFav(listType,),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Birşeyler Yanlış gitti");
              }
              if(snapshot.data == null){
                return  Center( child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Favorileri Getirmeye Çalışıyorum",style: Theme.of(context).textTheme.headlineSmall,),
                    const SizedBox(height: 10,),
                    const CircularProgressIndicator()
                  ],
                ));
              }
              if (snapshot.connectionState == ConnectionState.done) {
                veriList = snapshot.data as List;
                return LiquidPullToRefresh(
                  color: Colors.transparent,
                  backgroundColor: MyColors().iconColor,
                  height: 200,
                  animSpeedFactor: 10,
                  showChildOpacityTransition: true,
                  onRefresh: FireStoreDB().handleRefresh,

                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: veriList.length,
                      itemBuilder: (context, index) {
                        var aracFiyat = veriList[index]["AracFiyat"];
                        return Card(
                            color: MyColors().cardColor,
                                child:ListTile(
                                      leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: CachedNetworkImage(imageUrl: veriList[index]["AracResimUrl"],errorWidget: (context, url, error) => const Icon(Icons.error_outline),fit: BoxFit.fitWidth,width: 100,)),
                                      title: Text(
                                        veriList[index]["Marka"] ?? " boş",
                                        style: Theme.of(context).textTheme.titleLarge,
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(aracID: veriList[index]["AracID"], vehicleType: veriList[index]["VasitaTipi"], caseType: veriList[index]["KasaTipi"], name: veriList[index]["Marka"], model: veriList[index]["Model"], imagePath: veriList[index]["AracResimUrl"], description: veriList[index]["AracOzellikleri"], price: veriList[index]["AracFiyat"], isLiked: veriList[index]["isLiked"], likeCount: favNumber[index]["likeCount"], updateDate: veriList[index]["eklenmeTarihi"],)));
                                      },
                                      subtitle: FutureBuilder(future: FireStoreDB().getVehicle(listType),
                                        builder: (context, snap) {
                                          if (snap.hasError) {
                                            return const Text("Birşeyler Yanlış gitti");
                                          }
                                          if(snap.data == null){
                                            return  Center( child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("veri yok",style: Theme.of(context).textTheme.titleSmall,),

                                                const LinearProgressIndicator()
                                              ],
                                            ));
                                          }
                                          favNumber = snap.data as List;
                                          if (snap.connectionState == ConnectionState.done) {
                                            return  RichText(text: TextSpan(text: "${veriList[index]["Model"]} \n",style:Theme.of(context).textTheme.bodyMedium,children: [
                                              TextSpan(text: "${favNumber[index]["likeCount"]} Favorilenme ",style: Theme.of(context).textTheme.labelMedium),
                                              TextSpan(text:" \n ${veriList[index]["AracFiyat"].toString().substring(0,aracFiyat.toString().length )} ",style:Theme.of(context).textTheme.headlineSmall)
                                            ]
                                            )
                                            );
                                          }

                                        return const Text("assa");
                                          }
                                        ,
                                        // child: ,
                                      ),

                                    ),
                            );
                      },
                  ),
                );
              }
              return const RefreshProgressIndicator(

                color: Colors.orangeAccent,
              );
            }),
        // bottomNavigationBar:  bottomNavigationBar(),
      ),
    );
  }
}
