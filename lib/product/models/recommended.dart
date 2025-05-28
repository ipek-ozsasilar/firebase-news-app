import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_news_app/product/models/tag.dart';
import 'package:flutter_firebase_news_app/product/utility/base/base_firebase_model.dart';

@immutable
class Recommended extends BaseFirebaseModel<Recommended> with EquatableMixin implements IdModel  {
  final String? image;
  final String? title;
  final String? description;
  final String? id;

  Recommended({
    this.image,
    this.title,
    this.description,
    this.id,
  });

  @override
  List<Object?> get props => [image, title, description,id];

  Recommended copyWith({
    String? image,
    String? title,
    String? description,
    String? id,
  }) {
    return Recommended(
      image: image ?? this.image,
      title: title ?? this.title,
      description: description ?? this.description,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'description': description,
    };
  }
  
  @override
  Recommended fromJson(Map<String, dynamic> json) {
   return Recommended(
      image: json['image'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      id: json['id'] as String?,
    );
  }

}
