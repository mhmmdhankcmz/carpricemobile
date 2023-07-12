import 'package:carpricemobile/design_config/color.dart';
import 'package:carpricemobile/pages/profile_page.dart';
import 'package:carpricemobile/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';



class MyAppBar extends StatelessWidget with PreferredSizeWidget{
   MyAppBar({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {

    return AppBar(
      leading: IconButton(onPressed: (){
        Navigator.pushNamed(context, '/home');
      }, icon:  Icon(CupertinoIcons.home ,color: MyColors().iconColor,)),
      elevation: 1,
      backgroundColor: MyColors().appBarColor,
      // leading: Icon(Icons.menu),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      // ignore: prefer_const_literals_to_create_immutables
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfilPage()));
          },child: RichText(text:  TextSpan(style: Theme.of(context).textTheme.bodyMedium,text:user?.displayName ?? "",) , overflow: TextOverflow.ellipsis, softWrap: false, )),
        ),
        Consumer(builder: (context, value, child) {
          return TextButton.icon( label: Text(user == null ? "Giriş Yap" : "Çıkış yap",style: Theme.of(context).textTheme.labelSmall,),onPressed: () async{
            if(user == null){
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => true);
            }else{
              await AuthService().signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => true);
            }
          },icon: Icon(user == null ? Icons.login : Icons.logout  ,color: MyColors().iconColor,weight: 10,));
        },
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}




