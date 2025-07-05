import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_news_app/product/utility/base/base_firebase_model.dart';

@immutable
class CategoryModel extends BaseFirebaseModel<CategoryModel> with EquatableMixin implements IdModel {
  final String? detail;
  final String? name;
  final String? id;

  CategoryModel({
    this.detail,
    this.name,
    this.id,
  });

  @override
  List<Object?> get props => [detail, name,id];

  CategoryModel copyWith({
    String? detail,
    String? name,
    String? id,
  }) {
    return CategoryModel(
      detail: detail ?? this.detail,
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }
  
  //toJson kullanmayacağımız için şuan boş yaptık
  Map<String, dynamic> toJson() {
    return {};
  }
  
  @override
  CategoryModel fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      detail: json['detail'] as String?,
      name: json['name'] as String?,
      //dummy
      //id bazı modellerde vermisiz buraya bazılarında vermemısız dıkkate et
      id: json['id'] as String?,
    );
  }
  

}
