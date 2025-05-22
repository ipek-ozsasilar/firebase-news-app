// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:flutter_firebase_news_app/product/models/news.dart';
import 'package:flutter_firebase_news_app/product/utility/base/base_firebase_model.dart';

class Version extends BaseFirebaseModel<Version> with EquatableMixin implements IdModel {
  final String? number;

  Version({
    this.number,
  });

  @override
  List<Object?> get props => [number];

  Version copyWith({
    String? number,
  }) {
    return Version(
      number: number ?? this.number,
    );
  }

  @override
  Version fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    return Version(
      number: json['number'] as String?,
    );
    
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
    };
  }
  
  @override
  //Kullanmayacağımız için boş string döndürdük
  //Normalde hangı doc'u cekecegımızı belırtmek ıcın id yi kullanırız ama burada gerek duymadık cunku zaten
  //docs ısımlerını androıd ve ios yaptık bu yuzden id cekmemeıze ıhtıyac yok suan tojsona da ıhtıyac yok olmasa da olur
  // TODO: implement id
  String? get id => ' ';
}
