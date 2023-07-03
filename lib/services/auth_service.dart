import 'dart:io';

import 'package:carpricemobile/pages/profile_page.dart';
import 'package:carpricemobile/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../pages/home.dart';
import '../pages/login_page.dart';


class AuthService extends ChangeNotifier{

  final userAuth =  FirebaseAuth.instance.createUserWithEmailAndPassword;
  final user = FirebaseAuth.instance;

  String role = 'user';



    loginAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
                "Birşeyler Yanlış Gitti :( \n Uygulamayı kapatıp tekrar deneyin"),
          );
        } else if (snapshot.hasData) {
          if (kDebugMode) {
            print("oturum AÇIK");
          }
          notifyListeners();
          return const Home();
        } else {
          if (kDebugMode) {
            print("oturum KAPALI");
          }
          notifyListeners();
          return const Home();
        }
      },
    );
    }

    login(email, password,context) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) {
        successLogin();
          if (kDebugMode) {
            print("giriş Yapıldı");
          }
          Navigator.pushNamed(context, '/home');
        return const Home();
      }).catchError((dynamic error) {
        if (error.toString().contains('user-not-found')) {
          if (kDebugMode) {
            print("Hatalı Kullanıcı -- ${error.code}");
            buildErrorMessage();
          }
        }
        if (error.toString().contains('invalid-email')) {
          if (kDebugMode) {
            buildErrorMessage();
            print("Hatalı Eposta -- ${error.code}");
          }
        }
        buildErrorMessage();
      });
      notifyListeners();
    }

  void pickUploadImage(userId) async{
    String imageURl = "";
    final image = await ImagePicker().pickImage(source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    Reference ref = FirebaseStorage.instance.ref().child("UyeProfilImage/$userId/profilepic.jpg");
    ref.putFile(File(image!.path));
    await  ref.getDownloadURL().then((value) {
      print(value);
        imageURl = value;
        FireStoreDB().profilePic(imageURl);
        notifyListeners();
        return const ProfilPage();

    });

  }


    signOut()  {
       Fluttertoast.showToast(
          msg: "Kullanıcı Çıkışı Yapıldı",
          webBgColor: "linear-gradient(to right, #E55E2D, #E55E2D)",
          timeInSecForIosWeb: 2,
          textColor: Colors.white,
          fontSize: 15,
          webPosition: "center");
       FirebaseAuth.instance.signOut();
       notifyListeners();
    }

     register(fullName,email,phoneNo,password) {

      try{
         userAuth(email: email, password: password).then((value) {
           final _addUser = FirebaseFirestore.instance.collection("Uyeler").doc(value.user?.uid);
          _addUser.set({'Role':'user','AdSoyad': fullName,'Eposta':email,'Telefon':phoneNo,'Sifre':password,'UserId':value.user?.uid}).then((value) {
            user.currentUser?.updateDisplayName(fullName).then((value) {
              user.currentUser?.updatePhoneNumber(phoneNo);
            });
          });
          successRegister(email,fullName);
        });
      }on FirebaseAuthException catch(e){
        if (kDebugMode) {
          print('$e HATA OLDU');
        }

      }
      notifyListeners();
    }

    resetPasword(email)async{

      try{
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      }on FirebaseAuthException catch (e){
        if (kDebugMode) {
          print(e.message);
        }
      }
      notifyListeners();
    }
  void successUpdate(String email,String fullName) async {
    await Fluttertoast.showToast(
        msg: "$email ile $fullName güncellendi edildi :)",
        webBgColor: "linear-gradient(to right, #2DE5E5, #2DE5E5)",
        timeInSecForIosWeb: 2,
        fontSize: 15,
        webPosition: "center");
    const Duration(milliseconds: 1000);
  }
  void yanlisNo(String tel,String telTeyit) async {
    await Fluttertoast.showToast(
        msg: "$tel ile $telTeyit aynı değil.Lütfen Kotrol edin",
        webBgColor: "linear-gradient(to right, #2DE5E5, #2DE5E5)",
        timeInSecForIosWeb: 2,
        fontSize: 15,
        webPosition: "center");
    const Duration(milliseconds: 2000);
  }

}

void buildErrorMessage() {
  Fluttertoast.showToast(
      msg: "Hatalı Giriş \n Eposta ve Şifrenizi Kontrol Ediniz !!",
      webBgColor: "linear-gradient(to right, #E55E2D, #E55E2D)",
      timeInSecForIosWeb: 3,
      textColor: Colors.white,
      fontSize: 15,
      webPosition: "center");
}

void successLogin() async {
  await Fluttertoast.showToast(
      msg: "Kullanıcı Girişi Yapıldı",
      webBgColor: "linear-gradient(to right, #2DE5E5, #2DE5E5)",
      timeInSecForIosWeb: 2,
      fontSize: 15,
      webPosition: "center");
}
void successRegister(String email,String fullName) async {
  await Fluttertoast.showToast(
      msg: "$email ile $fullName kayıt edildi :)",
      webBgColor: "linear-gradient(to right, #2DE5E5, #2DE5E5)",
      timeInSecForIosWeb: 2,
      fontSize: 15,
      webPosition: "center");
  const Duration(milliseconds: 1000);
}
