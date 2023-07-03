// import 'dart:async';
//
// import 'package:carpricemobile/pages/home.dart';
// import 'package:carpricemobile/widgets/button.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// class VerifyEmailPage extends StatefulWidget {
//   const VerifyEmailPage({Key? key}) : super(key: key);
//
//   @override
//   State<VerifyEmailPage> createState() => _VerifyEmailPageState();
// }
//
// class _VerifyEmailPageState extends State<VerifyEmailPage> {
//   bool isEmailVerified = false;
//   bool canResendEmail = false;
//   late Timer timer;
//
//   @override
//   void initState() {
//     super.initState();
//     isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
//     if(!isEmailVerified){
//       sendVerificationEmail();
//
//      timer =   Timer.periodic(Duration(seconds: 3), (timer) { checkEmailVeried();});
//     }
//   }
//   Future sendVerificationEmail() async{
//     try{
//       final user= FirebaseAuth.instance.currentUser!;
//       await user.sendEmailVerification();
//       setState(() {
//         canResendEmail =false;
//       });
//       await Future.delayed(Duration(seconds: 5));
//     }catch(e){
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//   }
//   Future checkEmailVeried()async{
//     await FirebaseAuth.instance.currentUser!.reload();
//     setState(() {
//       isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
//      });
//     if(isEmailVerified) timer?.cancel();
//   }
//
//   @override
//   void dispose() {
//      timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) => isEmailVerified ? Home() : Scaffold(
//     appBar: AppBar(title: Text("Verify Email"),),
//     body: Center(child: Column(
//       children: [
//         Text("Verify Email please"),
//         MyButton(buttonName: "Resent Email", onTap: canResendEmail ? sendVerificationEmail : checkEmailVeried),
//       ],
//     ),),
//   );
// }
//
