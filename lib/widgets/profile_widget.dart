
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carpricemobile/services/auth_service.dart';
import 'package:carpricemobile/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ProfileWidget extends StatefulWidget {
    String imageUrl;


    ProfileWidget({super.key, required this.imageUrl});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  String imageURl = "";


  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Center(
      child: Stack(
        children: [
          buildImage(imageURl),
          Positioned(
              bottom: 0,
              right: 4,
              child: buildEditIcon(color)),
        ],
      ),
    );
  }

  Widget buildImage(image) {
    final image =  FireStoreDB().user?.photoURL ;
    if(image == null){
      return  const Icon(Icons.person,size: 120,);
    }
    return ClipOval(
      child: Material(elevation: 500,shadowColor: Colors.grey,
        color: Colors.transparent,
        child: CachedNetworkImage(imageUrl: image,width: 150,height: 150,fit:BoxFit.cover,placeholder: (context, url) {
      return Image.asset("lib/images/place_holder.png",height: 100, fit: BoxFit.fitHeight,);}
    ),
      ),
    );
  }

  Widget buildEditIcon(Color color) {
    return GestureDetector(
      onTap: () async{
        showDialog(context: context, builder: (context) {
          return SimpleDialog(
            title:  Text("Profil Resmi Seç",style: Theme.of(context).textTheme.bodyMedium,),
            backgroundColor: Colors.black54,
            shadowColor: Colors.yellow,elevation: 50,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(height: 60,width: 60,
                  child: Consumer(builder: (context, value, child) {
                    return  IconButton(icon: const Icon(Icons.upload,size: 50,), onPressed: () {
                      AuthService().pickUploadImage(FireStoreDB().user?.uid);
                    }
                    );
                  }

                  ),
                ),
              )
            ],
          );
        },);
      },
      child: buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color:color,
          all: 8,
          child: const Icon(
            Icons.edit,size: 20,
            color: Colors.white,),
        ),
      ),
    );
  }

  Widget buildCircle({
    required Color color,
    required double all,
    required Widget child
  }) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
  }

}

