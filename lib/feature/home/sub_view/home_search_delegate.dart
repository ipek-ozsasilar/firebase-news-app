import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/product/models/tag.dart';

//SearchDelegate, bir arama sayfası (UI) oluşturmak için kullanılan hazır bir abstract class'tır.
//Bir kullanıcı arama ikonuna tıkladığında açılan tam ekran arama arayüzünü (search page) oluşturmak 
//için SearchDelegate sınıfı kullanılır. Uygulama içinde metin arama yapılmasını sağlamak. Gelişmiş
// arama önerileri, sonuçlar, geri butonu gibi şeyleri kolayca yönetmek için kullanılır

//Searchdeleggate sınıfından extends edıyoruz ve bıze 4 overrıde etmemız gereken metot verıyor.
//buildActions, buildLeading, buildResults, buildSuggestions
//buildActions Arama kutusunun sağ tarafındaki aksiyon (icon) butonlarını tanımlar.
//buildLeading Arama kutusunun sol tarafındaki ikon (genelde geri dönüş butonu) tanımlanır.
//buildResults Kullanıcı bir arama yaptıktan (Enter'a bastıktan) sonra arama sonuçlarını gösterir.
//buildSuggestions Kullanıcı arama kutusuna bir şeyler yazarken öneri listesi gösterir.
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
        // Bu, SearchDelegate sınıfının içinde tanımlı bir methoddur.
        //Açılmış olan arama sayfasını kapatır ve eğer istersen bir sonuç (result) döndürür.
        // close(context, selectedTag); // seçilen tag geri döner
        close(context, null);
      },
       icon: Icon(Icons.arrow_back_outlined));
  }
  
  //Kullanıcı arama yaptıktan sonra ne gösterileceğini tanımlar.
  @override
  Widget buildResults(BuildContext context) {
    //where ıle her eleman ıle bu fıltreyı uygulayacagını soyledı
    //arama kısmına yazdıgımız metnı yanıo queryyı bu taglıst ıcınde var mı dıye kontrol eder
    //toLowerCase() ile büyük küçük harf duyarlılığını kaldırıyoruz
    //orn tag beyza ise ve bey veya z bıle yazsak bu resulta dahıl edılır
    //Çünkü .contains() bir alt string (substring) aramasıdır.
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