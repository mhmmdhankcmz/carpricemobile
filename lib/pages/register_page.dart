import 'package:carpricemobile/design_config/padding_all25.dart';
import 'package:carpricemobile/services/auth_service.dart';
import 'package:carpricemobile/services/validators.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/button.dart';
import '../widgets/textfield.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final  fullName = TextEditingController();
  final phoneNo = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final password2 = TextEditingController();
   bool visiblePass = false;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return SafeArea(
        child:
        Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const PaddingAll.all(),
              child: Center(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Icon(Icons.person_add_alt_sharp,size: 100,color: Colors.black54,),
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Text("Üyelik Sayfası",style: Theme.of(context).textTheme.titleLarge,),
                      ),
                      MyTextfield(controller: fullName, hinText: "İsim Soyisim", obscureText: false,iconButtons: const Icon(Icons.person), validate: (a){
                        return null;
                        }, autoValidate:  AutovalidateMode.onUserInteraction, keyboardType: TextInputType.name, textInputAction: TextInputAction.next, maxLenghts: 40,),
                      mySizedBox(),
                      MyTextfield(controller: email, hinText: "Eposta", obscureText: false, iconButtons: const Icon(Icons.email), validate: Validators().validateEmail, autoValidate: AutovalidateMode.onUserInteraction, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, maxLenghts: 50,),
                      mySizedBox(),
                      MyTextfield(controller: phoneNo, hinText: "Telefon", obscureText: false,iconButtons: const Icon(Icons.person_2), validate: (a){
                        return null;
                      }, autoValidate: AutovalidateMode.onUserInteraction, keyboardType: TextInputType.phone, textInputAction: TextInputAction.next, maxLenghts: 11,),
                      mySizedBox(),
                      MyTextfield(controller: password, hinText: "Şifre", obscureText: visiblePass,iconButtons: IconButton(onPressed: (){
                        setState(() {
                          visiblePass = !visiblePass;
                        });
                      }, icon: Icon(visiblePass ? Icons.visibility :Icons.visibility_off)), validate: Validators().validatePass, autoValidate: AutovalidateMode.onUserInteraction, keyboardType: TextInputType.visiblePassword, textInputAction:  TextInputAction.next, maxLenghts: 20,),
                      mySizedBox(),
                      MyTextfield(controller: password2, hinText: "Şifre Tekrar", obscureText: visiblePass,iconButtons: IconButton(onPressed: (){
                        setState(() {
                          visiblePass = !visiblePass;
                        });
                      }, icon: Icon(visiblePass ? Icons.visibility :Icons.visibility_off)), validate: Validators().validatePass, autoValidate: AutovalidateMode.onUserInteraction, keyboardType: TextInputType.visiblePassword, textInputAction: TextInputAction.go, maxLenghts: 20,),
                      mySizedBox(),
                      MyButton(onTap: () {
                         final isValid = formKey.currentState!.validate();
                        if(!isValid){
                          return 'Boş alan bırakılamaz';
                        }else{
                          AuthService().register(fullName.text.trim(), email.text.trim(), phoneNo.text.trim(), password.text.trim());
                          setState(() {
                            Navigator.pushNamed(context, '/login');
                          });
                        }
                      }, buttonName: 'Üye Ol ve Giriş Yap',),
                      GestureDetector(onTap: (){
                        Navigator.pushNamed(context, '/login');
                      },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: RichText(text: const TextSpan(text: 'Zaten Üyemisin? ',children: [TextSpan(text: ' Giriş Yap',style: TextStyle(fontSize: 20,decoration: TextDecoration.underline))])),
                        ),
                      ),
                      TextButton.icon(label: Text("Giriş Yapmadan devam et",style: GoogleFonts.acme(fontSize: 20,color: Colors.yellow.shade300),) ,onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },icon: const Icon(Icons.home,size: 50,color: Colors.black45,),),
                    ],
                  ),
                ),),
            ),
          ),

    ));
  }

  SizedBox mySizedBox() => const SizedBox(height: 5,);
}
