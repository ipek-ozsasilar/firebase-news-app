import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/product/models/tag.dart';

//SearchDelegate, bir arama sayfası (UI) oluşturmak için kullanılan hazır bir abstract class'tır.
//Bir kullanıcı arama ikonuna tıkladığında açılan tam ekran arama arayüzünü (search page) oluşturmak 
//için SearchDelegate sınıfı kullanılır. Uygulama içinde metin arama yapılmasını sağlamak. Gelişmiş
// arama önerileri, sonuçlar, geri butonu gibi şeyleri kolayca yönetmekiçin kullanılır
class HomeSearchDelegate extends SearchDelegate<Tag?> {
  final List<Tag> tagItems;

  HomeSearchDelegate({required this.tagItems});
  //Arama kutusunun sağ tarafında görünen ikonları veya butonları tanımlar.
  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton(
        onPressed: (){
          //query kullanıcının arama kutusuna yazdığı metni temsil eder.
          query='';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }
  
  //Sol tarafta görünen geri butonu. close(context, false); → Arama ekranını kapatır, isteğe bağlı bir sonuç da dönebilir.
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context, null);
      },
       icon: Icon(Icons.arrow_back_outlined));
  }
  
  //Kullanıcı arama yaptıktan sonra ne gösterileceğini tanımlar.
  @override
  Widget buildResults(BuildContext context) {
    final results=tagItems.where((element) => element.name?.toLowerCase().contains(query.toLowerCase()) ?? false);

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(results.elementAt(index).name ?? ''),
          ),
        );
      },
    );
  }
  
  //Kullanıcı arama kutusuna yazı yazarken öneri listesi burada tanımlanır. Genelde burada: Arama geçmişi Önerilen kelimeler gösterilir
  @override
  Widget buildSuggestions(BuildContext context) {
    final results=tagItems.where((element) => element.name?.toLowerCase().contains(query.toLowerCase()) ?? false);

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            onTap: (){
              close(context, results.elementAt(index));
            },
            title: Text(results.elementAt(index).name ?? ''),
          ),
        );
      },
    );
  }
  
}