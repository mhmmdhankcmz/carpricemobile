import 'package:carpricemobile/design_config/color.dart';
import 'package:carpricemobile/design_config/padding_only_right.dart';
import 'package:carpricemobile/pages/page_details.dart';
import 'package:carpricemobile/services/firestore_service.dart';
import 'package:carpricemobile/util/arac-marka.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
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
  bool selectMarka = false;
  String secilenMarka = "";
  bool filtering = false;

  bool markayaAscOrDesc = false;
  bool modeleAscOrDesc = false;
  bool priceAscOrDesc = false;


  List veriList = [];
  List dataList = [];
  List secilmisMarka =[];
  List filters = [ ];


  List selectField = ["Marka","Model","AracFiyat"];
   int selectedField = 0;

  String path = "lib/images/";

  // void coffeeTypeSelected(int index) {
  //     //this for loop makes every selection false
  //     for (int i = 1; i < veriList.length; i++) {
  //       veriList[i][1] = false;
  //       selectMarka = false;
  //
  //     }
  //     setState(() {
  //     veriList[index][1] = true;
  //     selectMarka = true;
  //
  //   });
  // }

  Stream <QuerySnapshot>? postDocumentsList;
  String aramaKelimesi = "";
  initSearcghingPost(aramaKelimesi) {
     postDocumentsList = FirebaseFirestore.instance.collection("Araclar").where("Marka",isGreaterThanOrEqualTo: aramaKelimesi).orderBy("Marka",).startAt([aramaKelimesi]).endAt([aramaKelimesi+'\uf8ff',]).snapshots();
     // FirebaseFirestore.instance.collection("Araclar").where("Marka",isGreaterThanOrEqualTo: aramaKelimesi).orderBy("Marka",).startAt([aramaKelimesi]).endAt([aramaKelimesi+'\uf8ff',]).snapshots();
    setState(() {
      postDocumentsList;
    });
  }

  void dropdownCallBack(String? selectedValue){
    if(selectedValue is String){
      setState(() {
        filters = selectedValue as List;
      });
    }
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
                                if (kDebugMode) {
                                  print("$aramaKelimesi arama yapıldı");
                                }
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
              Row(mainAxisAlignment: MainAxisAlignment.end,
                children: [
                Visibility(
                  visible: !isSearch,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25, top: 8, bottom: 8),
                    child: DropdownButton(isDense: true,borderRadius: BorderRadius.circular(5),
                      dropdownColor: MyColors().iconColor,
                      items:  [
                      DropdownMenuItem(value: 'az',onTap: (){
                        setState(() {
                          filtering = !filtering;
                          markayaAscOrDesc = !markayaAscOrDesc;
                            selectedField = 0;
                            print(selectField[selectedField]);
                        });
                      },child: markayaAscOrDesc?  Text("Markaya göre A dan Z ye",style: Theme.of(context).textTheme.labelMedium,) : Text("Markaya göre Z den-A ya",style: Theme.of(context).textTheme.labelMedium,),),

                      DropdownMenuItem( onTap: (){
                        setState(() {
                          modeleAscOrDesc = !modeleAscOrDesc;
                          selectedField = 1;
                          print(selectField[selectedField]);
                        });
                      },value: 'modelAscOrDesc',child: modeleAscOrDesc ? Text("Modele göre Z den- A ya",style: Theme.of(context).textTheme.labelMedium,) :Text("Modele göre  A dan - Z ye",style: Theme.of(context).textTheme.labelMedium,) ,),

                      DropdownMenuItem(onTap: (){
                        setState(() {
                          priceAscOrDesc = !priceAscOrDesc;
                          selectedField =2;
                          print(selectField[selectedField]);
                        });

                      },value: 'priceAscOrDesc',child: priceAscOrDesc ? Text("Fiyata göre önce en ucuz",style: Theme.of(context).textTheme.labelMedium,) : Text("Fiyata göre önce en pahalı",style: Theme.of(context).textTheme.labelMedium,),
                      ),

                    ], onChanged: dropdownCallBack,
                      icon: const Icon(Icons.filter_list,color: Colors.black),
                      // iconSize: 25,


                    style: GoogleFonts.patuaOne(color: MyColors().iconColor),
                    ),
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

                        )),
                  ),
                )
              ],),

            ],
          ),
          Visibility(
            visible: !isSearch,
            child: SizedBox(
              height: 30,
              child: FutureBuilder(
                future: FireStoreDB().getMarka(listType,markayaAscOrDesc),
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
                              secilenMarka = veriList[index]["MarkaAdi"];
                              setState(() {
                                selectMarka = true;
                                secilenMarka = veriList[index]["MarkaAdi"];

                              });


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
                        return Card(color: MyColors().cardColor,
                          child: CupertinoListTile(additionalInfo: Text("${mod?.kasaTipi}",style: Theme.of(context).textTheme.labelSmall,),
                            leading: CircleAvatar(backgroundImage: NetworkImage(mod!.imageUrl!),),
                            title: Text(mod.marka!,style:Theme.of(context).textTheme.bodyLarge),
                            subtitle:  Text(mod.model!,style:Theme.of(context).textTheme.bodyMedium,),
                            trailing: Text(mod.fiyat!.toString().substring(0,mod.fiyat.toString().length - 3),style:Theme.of(context).textTheme.bodyMedium,),
                            onTap: (){
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(aracID: "${mod.id}", vehicleType: "${mod.vasitaTipi}", caseType: "${mod.kasaTipi}",
                                name: "${mod.marka}", model: "${mod.model}", imagePath: "${mod.imageUrl}", description: "${mod.aciklama}", price: "${mod.fiyat}", isLiked:mod.isLiked!, likeCount: mod.likeCount!, updateDate: mod.eklenmeTarihi!,)));
                              if (kDebugMode) {
                                print("${widget.model?.id} **0***0***0****3*3*3**");
                              }
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
              !selectMarka
               ?
              FutureBuilder(
                  future: FireStoreDB().getVehicle(listType,filtering,selectField[selectedField]),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Birşeyler yanlış  gitti");
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      dataList = snapshot.data as List;

                      return Expanded(
                        child: LiquidPullToRefresh(
                          color: Colors.transparent,
                          backgroundColor: MyColors().iconColor,
                          height: 200,
                          animSpeedFactor: 10,
                          showChildOpacityTransition: true,
                          onRefresh: FireStoreDB().handleRefresh,
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
                                updateDate: dataList[index]["eklenmeTarihi"],
                              );
                            },
                          ),
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  })
              :
              FutureBuilder(
                  future: FireStoreDB().getVehicleMarka(selectMarka,secilenMarka),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const CircularProgressIndicator();
                    }else{
                      if (snapshot.hasError) {
                        return const Text("Birşeyler yanlış  gitti");
                      }else{
                        if(!snapshot.hasData){
                          return  Text("$secilenMarka ile araç yok!!");
                        }else{
                          secilmisMarka = snapshot.data as List;
                          return Expanded(
                            child: LiquidPullToRefresh(
                              color: Colors.transparent,
                              backgroundColor: MyColors().iconColor,
                              height: 200,
                              animSpeedFactor: 10,
                              showChildOpacityTransition: true,
                              onRefresh: FireStoreDB().handleRefresh,
                              child: GridView.builder(
                                itemCount: secilmisMarka.length,
                                shrinkWrap: true,
                                padding: const PaddingOnlyRight.all(),
                                scrollDirection: Axis.vertical,
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                                itemBuilder: (context, index) {
                                  return VehicleGeneral(
                                    carDescription: secilmisMarka[index]["AracOzellikleri"],
                                    carImagePath: secilmisMarka[index]["aracResimUrl"],
                                    carName: secilmisMarka[index]["Marka"],
                                    carPrice: secilmisMarka[index]["AracFiyat"].toString().substring(0, secilmisMarka[index]["AracFiyat"].toString().length - 3),
                                    carModel: secilmisMarka[index]["Model"],
                                    vehicleType: secilmisMarka[index]["VasitaTipi"],
                                    caseType: secilmisMarka[index]["KasaTipi"],
                                    aracID: secilmisMarka[index]["id"],
                                    isLiked: secilmisMarka[index]["isLiked"],
                                    likeCount: secilmisMarka[index]["likeCount"],
                                    updateDate: secilmisMarka[index]["eklenmeTarihi"],
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      }
                    }
                  }
                  )

        ],
      ),
    );
  }

  SizedBox buildSizedBox25() => const SizedBox(
        height: 25,
      );
}
