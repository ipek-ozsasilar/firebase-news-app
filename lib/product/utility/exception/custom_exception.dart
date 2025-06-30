class FirebaseCustomException implements Exception {
  final String description;
  FirebaseCustomException({required this.description});
  
  @override
  String toString() {
    return "$this.description";
  }
  
}


class VersionCustomException implements Exception {
  final String description;
  VersionCustomException({required this.description});
  
  @override
  String toString() {
    return "${this.description}";
  }
  
}