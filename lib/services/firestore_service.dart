
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


class FireStoreDB extends ChangeNotifier{
  var db = FirebaseFirestore.instance;

  List vehicleList  =[];
  final CollectionReference collectionRef = FirebaseFirestore.instance.collection("Araclar");
  List markaList = [];
  final CollectionReference collectionRefMarka = FirebaseFirestore.instance.collection("Markalar");
  List favList = [];
  final CollectionReference collectionRefFav = FirebaseFirestore.instance.collection("Favoriler");
  List userList = [];
  final CollectionReference collectionUsers = FirebaseFirestore.instance.collection("Uyeler");

  final user = FirebaseAuth.instance.currentUser;

  Future getVehicle(bool listType )async{
    try{
      await collectionRef.get().then((querySnaps) {
        for(var result in querySnaps.docs){
          vehicleList.add(result.data());
        }
      });
      notifyListeners();
      return vehicleList;
    }catch(e){
      debugPrint("Error - $e");
      return null;
    }
  }
  Future<void> handleRefresh() async{
    return await Future.delayed(const Duration(seconds: 2));
  }

  Future getFavoriteVehicle(bool listType )async{
    try{
      await collectionRef.where("isLiked",isEqualTo: false,).get().then((querySnaps) {
        collectionRefFav.where("UserID",isEqualTo: user?.uid);
        for(var result in querySnaps.docs){
          vehicleList.add(result.data());
        }
      });
      notifyListeners();
      return vehicleList;
    }catch(e){
      debugPrint("Error - $e");
      return null;
    }
  }

  Future getMarka(bool listType )async{
    try{
      await collectionRefMarka.get().then((querySnaps) {
        for(var result in querySnaps.docs){
          markaList.add(result.data());
        }
      });
      notifyListeners();
      return markaList;
    }catch(e){
      debugPrint("Error - $e");
      return null;
    }
  }

  Future getSearchVehicle(bool listType) async{
    try{

    }catch(e){
      debugPrint("Arama Hatası --> $e");
    }
  }

  Future getFav(bool listType )async{
    try{
      await collectionRefFav.where("UserID",isEqualTo:user?.uid).get().then((querySnaps) {
        print("---> ${user?.email}");
        for(var result in querySnaps.docs){
          favList.add(result.data());
        }
      });
      notifyListeners();
      return favList;
    }catch(e){
      debugPrint("Error - $e");
      return null;
    }
  }

  Future getUser(bool listType )async{
    try{
      await collectionUsers.where("UserId",isEqualTo:user?.uid).get().then((querySnaps) {
        for(var result in querySnaps.docs){
          userList.add(result.data());
        }
      });
      notifyListeners();
      return userList;
    }catch(e){
      debugPrint("Error - $e");
      return null;
    }
  }

   void profilGuncelle (adsoyad,eposta) async{
    await collectionUsers.doc(user?.uid).update({'AdSoyad':adsoyad,'Eposta':eposta,}).then((value) {
        user?.updateDisplayName(adsoyad);
        user?.updateEmail(eposta);
    });
    notifyListeners();
  }
  void telGuncelle(tel,telTeyit)async{
    await collectionUsers.doc(user?.uid).update({'Telefon':telTeyit});
    notifyListeners();
  }

  void profilePic(profilimageUrl) async{
    await collectionUsers.doc(user?.uid).update({'ProfilPicUrl' :profilimageUrl}).then((value) {
      user?.updatePhotoURL(profilimageUrl);
    });
    notifyListeners();
  }



}