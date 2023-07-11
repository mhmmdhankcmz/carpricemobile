import 'package:carpricemobile/design_config/padding_only_right.dart';
import 'package:carpricemobile/pages/page_details.dart';
import 'package:carpricemobile/services/firestore_service.dart';
import 'package:carpricemobile/util/arac-marka.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../design_config/page_padding_top_right.dart';
import '../models/vehicles_model.dart';
import '../util/vehicle-general.dart';

class ProductsPage extends StatefulWidget {
  Vehicles? model;
  BuildContext? context;

  ProductsPage({super.key, this.model,this.context});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  bool isSearch = false;
  bool listType = false;

  List veriList = [];
  List dataList = [];

  String path = "lib/images/";

  void coffeeTypeSelected(int index) {

      //this for loop makes every selection false
      for (int i = 1; i < veriList.length; i++) {
        veriList[i][1] = false;
      }
      setState(() {
      veriList[index][1] = true;
    });
  }

  Stream <QuerySnapshot>? postDocumentsList;
  String aramaKelimesi = "";
  initSearcghingPost(aramaKelimesi) {
     postDocumentsList = FirebaseFirestore.instance.collection("Araclar").where("Marka",isGreaterThanOrEqualTo: aramaKelimesi).orderBy("Marka",).startAt([aramaKelimesi]).endAt([aramaKelimesi+'\uf8ff',]).snapshots();
     // FirebaseFirestore.instance.collection("Araclar").where("Marka",isGreaterThanOrEqualTo: aramaKelimesi).orderBy("Marka",).startAt([aramaKelimesi]).endAt([aramaKelimesi+'\uf8ff',]).snapshots();
    setState(() {
      postDocumentsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: isSearch,
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 25, left: 8, top: 8, bottom: 8),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 40,
                      child: TextField(
                        onChanged: (textEntered){
                          setState(() {
                            aramaKelimesi = textEntered.trim().toUpperCase();


                          });
                        },
                        autofocus: !isSearch,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                print("$aramaKelimesi arama yapıldı");
                              },
                              icon: const Icon(Icons.search_rounded)),
                          prefixIcon: GestureDetector(
                              onTap: () => setState(() => isSearch = !isSearch),
                              child: const Icon(Icons.visibility_off)),
                          hintText: "Find your Car..",
                          hintStyle: Theme.of(context).textTheme.labelMedium,

                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade900)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade900)),
                        ),
                      )),
                ),
              ),
              Visibility(
                visible: !isSearch,
                child: Padding(
                  padding: const EdgeInsets.only(right: 25, top: 8, bottom: 8),
                  child: GestureDetector(
                      onTap: () => setState(() => isSearch = !isSearch),
                      child: const Icon(
                        Icons.search,
                        color: Colors.orange,
                      )),
                ),
              )
            ],
          ),
          Visibility(
            visible: !isSearch,
            child: SizedBox(
              height: 30,
              child: FutureBuilder(
                future: FireStoreDB().getMarka(listType),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Bir şeyler yanlış  Gitti");
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    veriList = snapshot.data as List;
                    return ListView.builder(
                      padding: const PaddingOnlyTopAndRight.all(),
                      scrollDirection: Axis.horizontal,
                      itemCount: veriList.length,
                      itemBuilder: (context, index) {
                        return Marka(
                            isSelected: true,
                            coffeType: veriList[index]["MarkaAdi"],
                            onTap: () {
                              print(veriList[index]["MarkaAdi"]);
                            });
                      },
                    );
                  }
                  return Text(
                    "Yükleniyor.. ",
                    style: Theme.of(context).textTheme.labelSmall,
                  );
                },
              ),
            ),
          ),
          isSearch
              ?
          StreamBuilder(
              stream: (aramaKelimesi != "") ? FirebaseFirestore.instance.collection("Araclar").where("Marka",isGreaterThanOrEqualTo: aramaKelimesi).orderBy("Marka",).startAt([aramaKelimesi]).endAt(['$aramaKelimesi\uf8ff',]).snapshots() : FirebaseFirestore.instance.collection("Araclar").snapshots(),
              builder: (context,AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Text("Birşeyler yanlış  gitti");
                }
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        widget.model = Vehicles.fromJson(snapshot.data.docs[index].data() as Map<String, dynamic>);
                        var mod = widget.model;
                        return Card(
                          child: CupertinoListTile(additionalInfo: Text("${mod?.kasaTipi}",style: Theme.of(context).textTheme.labelSmall,),
                            leading: CircleAvatar(backgroundImage: NetworkImage(mod!.imageUrl!),),
                            title: Text(mod.marka!,style:Theme.of(context).textTheme.bodyLarge),
                            subtitle:  Text(mod.model!,style:Theme.of(context).textTheme.bodyMedium,),
                            trailing: Text(mod.fiyat!.toString().substring(0,mod.fiyat.toString().length - 3),style:Theme.of(context).textTheme.bodyMedium,),
                            onTap: (){
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(aracID: "${mod.id}", vehicleType: "${mod.vasitaTipi}", caseType: "${mod.kasaTipi}",
                                name: "${mod.marka}", model: "${mod.model}", imagePath: "${mod.imageUrl}", description: "${mod.aciklama}", price: "${mod.fiyat}", isLiked:false , likeCount: 0,)));
                              print("${widget.model?.id} **0***0***0****3*3*3**");
                            });

                              },

                          ),
                        );

                      },
                ),
                  );
                } else {
                  return Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            Text("Arama yapmak için arama çubuğuna birşeyler girin  ",style: Theme.of(context).textTheme.labelMedium,),
                          ],
                        ));
                }
              }
          )
              :
          FutureBuilder(
              future: FireStoreDB().getVehicle(listType),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Birşeyler yanlış  gitti");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  dataList = snapshot.data as List;

                  return Expanded(
                    child: GridView.builder(
                      itemCount: dataList.length,
                      shrinkWrap: true,
                      padding: const PaddingOnlyRight.all(),
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return VehicleGeneral(
                          carDescription: dataList[index]["AracOzellikleri"],
                          carImagePath: dataList[index]["aracResimUrl"],
                          carName:dataList[index]["Marka"] ,
                          carPrice: dataList[index]["AracFiyat"].toString().substring(0,dataList[index]["AracFiyat"].toString().length - 3),
                          carModel: dataList[index]["Model"],
                          vehicleType: dataList[index]["VasitaTipi"],
                          caseType: dataList[index]["KasaTipi"],
                          aracID: dataList[index]["id"],
                          isLiked: dataList[index]["isLiked"],
                          likeCount: dataList[index]["likeCount"],
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ],
      ),
    );
  }

  SizedBox buildSizedBox25() => const SizedBox(
        height: 25,
      );
}
