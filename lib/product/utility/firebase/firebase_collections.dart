import 'package:cloud_firestore/cloud_firestore.dart';

enum FirebaseCollections{
  news,
  tag,
  category,
  version;
  
  //FirebaseCollections.news.reference dıyınce newsin name ını alır ve ıcıne verır
  CollectionReference get reference => FirebaseFirestore.instance.collection(name);
}