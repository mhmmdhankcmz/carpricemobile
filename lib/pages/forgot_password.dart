import 'package:carpricemobile/design_config/padding_all25.dart';
import 'package:carpricemobile/services/auth_service.dart';
import 'package:carpricemobile/services/validators.dart';
import 'package:flutter/material.dart';
import '../widgets/button.dart';
import '../widgets/textfield.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {


  final email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return SafeArea(
        child:
        Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const PaddingAll.all(),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Icon(Icons.email,size: 100,color: Colors.black54,),
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Text("Şifre Sıfırlama",style: Theme.of(context).textTheme.titleLarge,),
                      ),
                      mySizedBox(),
                      MyTextfield(controller: email, hinText: "Eposta", obscureText: false, iconButtons: const Icon(Icons.email), validate: Validators().validateEmail, autoValidate: AutovalidateMode.onUserInteraction, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.send, maxLenghts: 50,),
                      mySizedBox(),
                      MyButton(onTap: (){
                        AuthService().resetPasword(email.text.trim());
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.orange,content: Text("Şifre Sıfırlama Epostası Gönderildi")));
                      }, buttonName: 'Şifremi Sıfırla',),
                      GestureDetector(onTap: (){
                        Navigator.pushNamed(context, '/login');
                      },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: RichText(text:  TextSpan(text: 'Şifreni Hatırladın mı? ',children: [TextSpan(text: ' Giriş Yap',style: Theme.of(context).textTheme.headlineSmall)])),
                        ),
                      )
                    ],
                  ),
                ),),
            ),
          ),

        ));
  }

  SizedBox mySizedBox() => const SizedBox(height: 5,);
}
