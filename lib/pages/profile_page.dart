import 'package:carpricemobile/pages/edit_profil.dart';
import 'package:carpricemobile/pages/home.dart';
import 'package:carpricemobile/pages/login_page.dart';
import 'package:carpricemobile/services/firestore_service.dart';
import 'package:carpricemobile/widgets/my_%C4%B1nfo.dart';
import 'package:carpricemobile/widgets/my_appbar.dart';
import 'package:carpricemobile/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/numbers_widget.dart';


class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {

  var user = FireStoreDB().user;

  var sayi = [];
  bool listType = false;


  @override
  Widget build(BuildContext context) {
    if(user == null){
      return const LoginPage();
    }
    return  SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfile(gelenAdSoyad: "${user?.displayName}", gelenEmail: "${user?.email}", imageUrl: '${user?.photoURL}',)));},icon: const Icon(Icons.edit_location_sharp,color: Colors.orange,)),
          ],
        ),
        body:  Center(
          child: ListView(
            padding: const EdgeInsets.all(8),
            physics: const BouncingScrollPhysics(),
            children: [
              ProfileWidget(imageUrl: "${user?.photoURL}"),
              const SizedBox(height: 24,),
              buildName("${user?.displayName}", "${user?.email}"),
               FutureBuilder(
                 future: FireStoreDB().getFav(listType),
                 builder: (context, snapshot) {
                   if(snapshot.hasData){sayi = snapshot.data;return    NumbersWidget(sayi.length);}
                   if(snapshot.hasData == 0){return const Text("Sayı Yok");}
                return Text("Sayi Yok",style: GoogleFonts.asap(fontSize: 12),);
               },
                 ),
              const MyInfo()

            ],
          ),
        ),
         // bottomNavigationBar:  MyAppBar(),
      ),
    );
  }

  Widget buildName(String ad, String email)  => Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(ad,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18 ),),
      const SizedBox(height: 4,width: 4,),
      Text(email,style: const TextStyle(color: Colors.grey,fontSize: 12),),
      const SizedBox(height: 4,width: 4,),
      // Text(tel,style: const TextStyle(color: Colors.grey,fontSize: 12),),
    ],
  );
}
