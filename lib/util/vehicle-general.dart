import 'package:cached_network_image/cached_network_image.dart';
import 'package:carpricemobile/pages/page_details.dart';
import 'package:flutter/material.dart';

class VehicleGeneral extends StatelessWidget {
  final String carImagePath;
  final String vehicleType;
  final String caseType;
  final String carName;
  final String carModel;
  final String carDescription;
  final String carPrice;
  final String aracID;
  late bool isLiked ;
  late int likeCount;




  VehicleGeneral({super.key, required this.carDescription,required this.carImagePath, required this.carName,required this.carPrice, required this.carModel, required this.vehicleType, required this.caseType, required this.aracID,required this.isLiked,required this.likeCount});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0,bottom: 8),
      child: GestureDetector(onTap: (){

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>ProductDetails(name: carName.toUpperCase(),imagePath: carImagePath,description:carDescription,price: carPrice, model: carModel.toUpperCase(), vehicleType: vehicleType, caseType: caseType, aracID:aracID, isLiked: isLiked, likeCount: likeCount, )), (route) => false);

      },
        child: Container(margin: const EdgeInsets.all(5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.black54),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RichText(text: TextSpan(text:carName.toUpperCase(),style: Theme.of(context).textTheme.bodyLarge,children: [ TextSpan(text:" ${carModel.toUpperCase()}",style: Theme.of(context).textTheme.bodyMedium)]),),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(5.0),
              //   child: ClipRRect(borderRadius: BorderRadius.circular(8),child: Image.network(carImagePath,height: 75 ,width:150,fit: BoxFit.fitWidth,loadingBuilder: (BuildContext context, Widget child,
              //       ImageChunkEvent? loadingProgress) {
              //     if (loadingProgress == null) {
              //       return child;
              //     }
              //     return const CupertinoActivityIndicator(radius: 20,animating: true,color: Colors.orange,);
              //   },),),
              // ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(borderRadius: BorderRadius.circular(8),child: CachedNetworkImage(
                  height:75,width: 150,
                  fit: BoxFit.fitWidth,
                  imageUrl: carImagePath,errorWidget: (context, url, error) => const Icon(Icons.error_outline),
                  placeholder: (context, url) {
                  return Image.asset("lib/images/place_holder.png",height: 80,);
                },),),
              ),


              Padding(
                padding: const EdgeInsets.only(left: 5.0,right: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: RichText(text: TextSpan(text:"$carPrice ",style: Theme.of(context).textTheme.labelMedium,)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Container(decoration: BoxDecoration(color:Theme.of(context).scaffoldBackgroundColor ,borderRadius: BorderRadius.circular(8)),height: 15,width: 15, child: Center(child: Text(caseType,style: Theme.of(context).textTheme.labelMedium,))),
                    ),
                  ],
                ),
                 ),
          ],
          ),
        ),
      ),
    );
  }
}

