import 'package:carpricemobile/services/auth_service.dart';
import 'package:carpricemobile/services/firestore_service.dart';
import 'package:carpricemobile/services/validators.dart';
import 'package:carpricemobile/widgets/button.dart';
import 'package:carpricemobile/widgets/my_appbar.dart';
import 'package:carpricemobile/widgets/textfield.dart';
import 'package:flutter/material.dart';

import '../widgets/profile_widget.dart';

class EditProfile extends StatefulWidget {
  late String gelenAdSoyad;
  late String gelenEmail;
  late String imageUrl;



  EditProfile({super.key,  required this.gelenAdSoyad,required this.gelenEmail,required this.imageUrl});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController adSoyad = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController telefon = TextEditingController();
  TextEditingController telTeyit = TextEditingController();


  @override
  void initState() {
   adSoyad.text = widget.gelenAdSoyad ;
   email.text = widget.gelenEmail;
    // TODO: implement initState
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  final user = FireStoreDB().user;
  @override


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar:  MyAppBar(),
        body: Center(
          child: Form(key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 5,bottom: 5,left: 20.0,right: 20.0),
                child: SingleChildScrollView(scrollDirection: Axis.vertical,
                  child: Column(
            children: [
                  Container(alignment: AlignmentDirectional.center, height: 30,width: width,decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(5)),border: Border.all(color: Colors.green)),
                      child: Text("Bilgilerimi Güncelle",style: Theme.of(context).textTheme.headlineSmall,)),
                  ProfileWidget(imageUrl: widget.imageUrl,),
                  const Divider(),
                  Text(widget.gelenAdSoyad,style:Theme.of(context).textTheme.bodyMedium),
                  Text(widget.gelenEmail,style: Theme.of(context).textTheme.bodyLarge,),
                  // Text(widget.gelenTelefon),
                  MyTextfield(iconButtons: const Icon(Icons.edit), controller: adSoyad,hinText:"ad soyad", obscureText: false, validate: (validate){
                    return null;
                  }, autoValidate: AutovalidateMode.disabled, keyboardType: TextInputType.text, textInputAction: TextInputAction.next, maxLenghts: 40,),
                  const Divider(),
                  MyTextfield(iconButtons: const Icon(Icons.edit), controller: email, hinText: "email", obscureText: false, validate: Validators().validateEmail, autoValidate: AutovalidateMode.onUserInteraction, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, maxLenghts: 50,),
                  const Divider(),
                  buildMyButton(context),
                  const Divider(),
                  MyTextfield(iconButtons: const Icon(Icons.edit), controller: telefon, hinText: "Başında 0 ile telefon no girin", obscureText: false, validate: (a){
                    return null;
                  }, autoValidate: AutovalidateMode.onUserInteraction, keyboardType: TextInputType.phone, textInputAction: TextInputAction.next, maxLenghts: 11,),
                  const Divider(),
                  MyTextfield(iconButtons: const Icon(Icons.edit), controller: telTeyit, hinText: "Başında 0 ile telefon no girin", obscureText: false, validate: (a){
                    return null;
                  }, autoValidate: AutovalidateMode.onUserInteraction, keyboardType: TextInputType.phone, textInputAction: TextInputAction.go, maxLenghts: 11,),
                  const Divider(),
                  buildElevatedButton(context),

            ],
          ),
                ),
              )),
        ),
      ),
    );
  }

  MyButton buildMyButton(BuildContext context) {
    return MyButton(buttonName: "<Güncelle>", onTap: (){
                    FireStoreDB().profilGuncelle(adSoyad.text.trim(), email.text.trim());
                    Navigator.pop(context);
                    AuthService().successUpdate(email.text, adSoyad.text);
                    setState(() {

                    });
                });
  }

  ElevatedButton buildElevatedButton(BuildContext context) {
    return ElevatedButton(onPressed: (){
                  if(telefon.text != telTeyit.text){
                    AuthService().yanlisNo(telefon.text, telTeyit.text);
                    print("yanlışş");
                  }else{
                    FireStoreDB().telGuncelle(telefon.text.trim(),telTeyit.text.trim());
                    Navigator.pop(context);
                    AuthService().successUpdate(telefon.text, telTeyit.text);
                    setState(() {

                    });

                  }
                }, child: const Text("Telefon Güncelle"));
  }
}
