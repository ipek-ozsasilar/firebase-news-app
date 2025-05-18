import 'package:equatable/equatable.dart';
import 'package:flutter_firebase_news_app/product/utility/base/base_firebase_model.dart';
//Equatable ile birlikte kullanıldığında, iki nesnenin karşılaştırılması için değerlerinin değişmemesi gerekir.
// Aksi halde, nesne oluşturulduktan sonra değer değişirse, karşılaştırma hatalı olur.
/*
dartj ye bu json dosyasını verdik yanı bize donmesını ıstedıgımız verı bu demek ıstedık
{
  "category": "",
  "categoryId": "",
  "backgroundImage": "",
  "title": "",
  "id": ""
}
 */
class News extends BaseFirebaseModel<News> with EquatableMixin implements IdModel{
  final String? category;
  final String? categoryId;
  final String? backgroundImage;
  final String? title;
  final String? id;

  News({
    this.category,
    this.categoryId,
    this.backgroundImage,
    this.title,
    this.id,
  });

  @override
  List<Object?> get props => [category, categoryId, backgroundImage, title, id];

  News copyWith({
    String? category,
    String? categoryId,
    String? backgroundImage,
    String? title,
    @override
    String? id,
  }) {
    return News(
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      title: title ?? this.title,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'categoryId': categoryId,
      'backgroundImage': backgroundImage,
      'title': title,
      'id': id,
    };
  }

  
  @override
  News fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
     return News(
      category: json['category'] as String?,
      categoryId: json['categoryId'] as String?,
      backgroundImage: json['backgroundImage'] as String?,
      title: json['title'] as String?,
      id: json['id'] as String?,
    );
  }
  
  @override
  set id(String? _id) {
    // TODO: implement id
    id=_id;
  }
  
  
}
