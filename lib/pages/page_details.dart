import 'package:cached_network_image/cached_network_image.dart';
import 'package:carpricemobile/design_config/color.dart';
import 'package:carpricemobile/pages/profile_page.dart';
import 'package:carpricemobile/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import '../widgets/my_appbar.dart';

class ProductDetails extends StatefulWidget {
  late String aracID;
  late String vehicleType;
  late String caseType;
  late String name;
  late String model;
  late String imagePath;
  late String description;
  late String price;
  late bool isLiked;
  late int likeCount;
  late String updateDate;

  ProductDetails(
      {super.key,
      required this.aracID,
      required this.vehicleType,
      required this.caseType,
      required this.name,
      required this.model,
      required this.imagePath,
      required this.description,
      required this.price,
      required this.isLiked,
      required this.likeCount,
      required this.updateDate});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  void initState() {
    widget.isLiked;
    if (kDebugMode) {
      print("init State isLiked =>  ${widget.isLiked}");
    }
    super.initState();
  }

  final user = FireStoreDB().user;
  final addFavorite = FireStoreDB().collectionRefFav;
  final addVehiclesFavorite = FireStoreDB().collectionRef;


  Future<void> addToFavorite() async {
    if (user == null) {
      beLogin();

    } else {
    widget.isLiked = true;
    addFavorite.doc("${user?.uid}${widget.aracID}").set({
      'AracID': widget.aracID,
      'FavID': addFavorite.id + user!.uid,
      'UserEmail': user!.email,
      'UserID': user!.uid,
      'AracResimUrl': widget.imagePath,
      'AracFiyat': widget.price,
      'AracOzellikleri': widget.description,
      'Marka': widget.name,
      'Model': widget.model,
      'KasaTipi': widget.caseType,
      'VasitaTipi': widget.vehicleType,
      'isLiked': widget.isLiked,
      'eklenmeTarihi': widget.updateDate,
    }).then((value) {
      setState(() {
        widget.isLiked = true;
        widget.likeCount++;
        addVehiclesFavorite.doc(widget.aracID).set(
            {'isLiked': widget.isLiked, 'likeCount': widget.likeCount},
            SetOptions(
              merge: true,
            ));
        addToFav();
      });
    });
   }
  }


  Future deleteToFavorite() async {
    if(user == null){
      beLogin();
    }else{
      addFavorite.doc("${user?.uid}${widget.aracID}").delete().then((value) {
        if(widget.likeCount== 0 || widget.likeCount <= 0){
          widget.isLiked = false;
        }else{
          widget.isLiked = true;
        }
        setState(() {
          widget.isLiked = false;
          widget.likeCount--;
          deleteToFav();
          addVehiclesFavorite.doc(widget.aracID).set(
              {'isLiked': widget.isLiked, 'likeCount': widget.likeCount},
              SetOptions(
                merge: true,
              ));
        });
        if (kDebugMode) {
          print("favori silindi");
            }
          }
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: MyAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onDoubleTap: (){
                setState(() {
                  addToFavorite();
                });
              },
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: MyColors().cardColor,
                ),
                child: Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RichText(text: TextSpan(spellOut: true,text: "  Güncelleme Tarihi  ${widget.updateDate.substring(0,10)}",style: Theme.of(context).textTheme.labelMedium)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text: "${widget.name} ",
                            children: [
                              TextSpan(text: widget.model, style: Theme.of(context).textTheme.titleMedium),

                            ],
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: InstaImageViewer(
                              child: CachedNetworkImage(imageUrl: widget.imagePath,errorWidget: (context, url, error) => const Icon(Icons.error_outline),
                                  placeholder: (context, url) {
                                    return Image.asset("lib/images/place_holder.png",height: 100, fit: BoxFit.fitWidth,);
                                  }),
                            )),

                    ),
                    divider(),
                    RichText(
                      text: TextSpan(
                          text: "${widget.vehicleType} ",
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [TextSpan(text: widget.caseType)]),
                    ),
                    divider(),
                    RichText(
                        text: TextSpan(
                            text: widget.description,
                            style: Theme.of(context).textTheme.bodySmall)),
                    divider(),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("${widget.price} ",
                              style: Theme.of(context).textTheme.bodyLarge),
                          const Spacer(),
                          GestureDetector(
                            onTap:deleteToFavorite,
                              child: Badge(
                                // isLabelVisible: widget.likeCount == 1 || widget.likeCount >= 1,
                              largeSize: 10,
                                smallSize: 10,
                                alignment: AlignmentDirectional.topStart,
                                backgroundColor: MyColors().scaffoldBackground,
                                label: Text("${widget.likeCount}",style: Theme.of(context).textTheme.labelSmall,),
                                child:widget.likeCount ==1 || widget.likeCount >=1 || widget.isLiked ?
                                Icon(Icons.favorite, size: 40, color: Colors.red.shade600)
                                    :

                                Icon(Icons.mood_bad, size: 40, color: Colors.blue.shade800,)
                              ),
                          ),
                        ],
                      ),
                    ),
                    divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(onPressed: (){
                          Navigator.pushNamed(context, '/favoriler');
                        }, child: Text("Favoriler",style: Theme.of(context).textTheme.labelLarge,)),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/home',);
                            },
                            child:  Text("Tüm Araçlar",style: Theme.of(context).textTheme.labelLarge)),
                        TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfilPage()));
                            },
                            child:  Text("Profil",style: Theme.of(context).textTheme.labelLarge)),
                      ],
                    ),
                    SingleChildScrollView(scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: RichText(text: TextSpan(text: "Favorilemek için 2 kez dokunun  geri almak içinse kalp sembolüne 1 kez dokunun",style: Theme.of(context).textTheme.labelSmall,spellOut:true,)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding divider() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Divider(color: Colors.grey, height: 1),
    );
  }

  void addToFav() async {
    await Fluttertoast.showToast(
        msg: "Favorilerine Eklendi",
        // webBgColor: "linear-gradient(to right, #2DE5E5, #2DE5E5)",
        fontSize: 15,
        webPosition: "center");
    const Duration(milliseconds: 1000);
  }
  void beLogin() async {
    await Fluttertoast.showToast(
        msg: "Lütfen üye girişi yapın",
        // webBgColor: "linear-gradient(to right, #2DE5E5, #2DE5E5)",
        fontSize: 15,
        webPosition: "center");
    const Duration(seconds: 3);
  }

  void deleteToFav() async {
    await Fluttertoast.showToast(
        msg: "Favori Silindi",
        // webBgColor: "linear-gradient(to right, #2DE5E5, #2DE5E5)",
        timeInSecForIosWeb: 2,
        fontSize: 15,
        webPosition: "center");
    const Duration(milliseconds: 1000);
  }
}
