import 'package:carpricemobile/services/auth_service.dart';
import 'package:carpricemobile/services/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:carpricemobile/design_config/color.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/button.dart';
import '../widgets/textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});



  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  String hintEmail = "Please enter email";
  String hintPass = "Please enter password";
  bool obscure = false;

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    AuthService().loginAuth();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top:25,bottom: 60,left: 25,right: 25),
              child: Form(key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const Icon(Icons.lock,size: 90,color: Colors.black54,),
                    sizedBox30(),
                    Text("Hoşgeldiniz",style: Theme.of(context).textTheme.headlineMedium),
                    sizedBox30(),
                    MyTextfield(controller: emailController, hinText: hintEmail, obscureText: false,iconButtons:  Icon(Icons.email,color: MyColors().iconColor,), validate:Validators().validateEmail, autoValidate: AutovalidateMode.onUserInteraction, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, maxLenghts: 50,),
                    const SizedBox(height: 25,),
                    MyTextfield(controller: passController, hinText: hintPass, obscureText: obscure,iconButtons: IconButton(onPressed: (){
                      setState(() {
                        obscure = !obscure;
                      });
                    },icon:Icon(obscure ? Icons.visibility :Icons.visibility_off) ), validate: Validators().validatePass, autoValidate: AutovalidateMode.onUserInteraction, keyboardType: TextInputType.visiblePassword, textInputAction: TextInputAction.next, maxLenghts: 20,
                    ),

                    GestureDetector(onTap: (){
                      Navigator.pushNamed(context, '/forgotPass');
                    },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Forgot Password?",style: Theme.of(context).textTheme.labelLarge),  // RichText(text: TextSpan(recognizer: TapGestureRecognizer()..onTap =widget.onClickedSignUp,))
                          ),
                        ],
                      ),
                    ),
                    Consumer(
                      builder: (context,girisYapNesnes,child){
                        return MyButton(onTap: () {
                          final isValid = formKey.currentState!.validate();
                          if(!isValid){
                            return ;
                          }else{
                            try {
                              AuthService().login(emailController.text.trim(), passController.text.trim(),context);

                            } on FirebaseAuthException catch (e) {
                              if (kDebugMode) {
                                print("yanlışlık oldu $e");
                              }
                            }
                          }
                        }, buttonName: 'Giriş Yap',);
                      },
                    ),
                    const SizedBox(height: 10,),

                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded (child: Divider(thickness: 1 ,)),
                        Text("Üye değilsen Üye Ol ",style: Theme.of(context).textTheme.bodySmall,),
                        const Expanded (child: Divider(thickness: 1 ,)),
                      ],
                    ),
                    // Row(mainAxisAlignment: MainAxisAlignment.center,
                    //   children: const [
                    //     Padding(
                    //       padding: EdgeInsets.all(8.0),
                    //       child: SquareTile(imagePath:'lib/images/google.png'),
                    //     ),
                    //     SizedBox(width: 25,),
                    //     Padding(
                    //       padding: EdgeInsets.all(8.0),
                    //       child: SquareTile(imagePath:'lib/images/apple.png'),
                    //     ),
                    //   ],
                    // ),
                    sizedBox30(),
                    InkWell(onTap: (){
                      Navigator.pushNamed(context, '/register');
                    },
                      child: Container(height: 40,decoration: BoxDecoration(color: MyColors().appBarColor,borderRadius: BorderRadius.circular(8),),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_add_alt,color: Colors.grey.shade400,),
                            const SizedBox(width: 10,),
                            Text("Üye Ol",style: Theme.of(context).textTheme.titleSmall,),
                          ],),
                      ),
                    ),
                    TextButton.icon(label: Text("Giriş Yapmadan devam et",style: Theme.of(context).textTheme.bodyLarge,) ,onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },icon: const Icon(Icons.home,size: 50,color: Colors.black45,),),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox sizedBox30() => const SizedBox(height: 30,);
}


