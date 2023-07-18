import 'package:carpricemobile/design_config/color.dart';
import 'package:carpricemobile/pages/edit_profil.dart';
import 'package:carpricemobile/pages/login_page.dart';
import 'package:carpricemobile/services/firestore_service.dart';
import 'package:carpricemobile/widgets/my_%C4%B1nfo.dart';
import 'package:carpricemobile/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
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
            IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfile(gelenAdSoyad: "${user?.displayName}", gelenEmail: "${user?.email}", imageUrl: '${user?.photoURL}',)));},icon: const Icon(Icons.edit_location_sharp,)),
          ],
        ),
        body:  LiquidPullToRefresh(
          color: Colors.transparent,
          backgroundColor: MyColors().iconColor,
          height: 200,
          animSpeedFactor: 10,
          showChildOpacityTransition: false,
          onRefresh: FireStoreDB().handleRefresh,
          child: ListView(
            padding: const EdgeInsets.all(8),
            physics: const BouncingScrollPhysics(),
            children: [
              ProfileWidget(imageUrl: "${user?.photoURL}"),
              const SizedBox(height: 24,),
              buildName("${user?.displayName}", "${user?.email}"),
               FutureBuilder(
                 future: FireStoreDB().getFav(listType,),
                 builder: (context, snapshot) {
                   if(snapshot.hasData){sayi = snapshot.data;return    NumbersWidget(sayi.length);}
                   if(snapshot.hasData == 0){return const Text("Sayı Yok");}
                return Text("Sayi Yok",style: Theme.of(context).textTheme.labelLarge,);
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
      Text(ad,style: Theme.of(context).textTheme.labelSmall,),
      const SizedBox(height: 4,width: 4,),
      Text(email,style: Theme.of(context).textTheme.bodyMedium,),
      const SizedBox(height: 4,width: 4,),

    ],
  );
}
