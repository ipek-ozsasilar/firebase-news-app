import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_news_app/product/utility/base/base_firebase_model.dart';

@immutable
class Tag extends BaseFirebaseModel<Tag> with EquatableMixin implements IdModel {
  final String? name;
  final bool? active;
  final String? id;

   Tag({
    this.name,
    this.active,
    this.id,
  });

  @override
  List<Object?> get props => [name, active, id];

  Tag copyWith({
    String? name,
    bool? active,
  }) {
    return Tag(
      name: name ?? this.name,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'active': active,
    };
  }
    

  
  @override
  Tag fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'] as String?,
      active: json['active'] as bool?,
      id: json['id'] as String?,
    );
  }
  
}
