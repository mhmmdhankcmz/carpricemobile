
class Vehicles {
  String? vasitaTipi;
  String? kasaTipi;
  String? marka;
  String? model;
  String? yil;
  String? fiyat;
  String? aciklama;
  String? eklenmeTarihi;
  bool? isLiked;
  int? likeCount;
  String? imageUrl;
  String? id;

  Vehicles({
      this.vasitaTipi,
      this.kasaTipi,
      this.marka,
      this.model,
      this.yil,
      this.fiyat,
      this.aciklama,
      this.eklenmeTarihi,
      this.isLiked,
      this.likeCount,
      this.imageUrl,
      this.id});
  Vehicles.fromJson(Map<String,dynamic> json){
    vasitaTipi = json['VasitaTipi'];
    kasaTipi = json['KasaTipi'];
    marka = json['Marka'];
    model = json['Model'];
    yil = json['Yil'];
    fiyat = json['AracFiyat'];
    aciklama = json['AracOzellikleri'];
    eklenmeTarihi = json['eklenmeTarihi'];
    isLiked = json['isLiked'];
    likeCount = json['likeCount'];
    imageUrl = json['aracResimUrl'];
    id = json['id'];
  }
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = Map<String,dynamic>();
    data['VasitaTipi'] = vasitaTipi;
    data['KasaTipi'] = kasaTipi;
    data['Marka'] = marka;
    data['Model'] = model;
    data['Yil'] = yil;
    data['AracFiyat'] = fiyat;
    data['AracOzellikleri'] = aciklama;
    data['eklenmeTarihi'] = eklenmeTarihi;
    data['isLiked'] = isLiked;
    data['likeCount'] = likeCount;
    data['id'] = id;

    return data;
  }
}
