import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/product/constants/color_constants.dart';
import 'package:flutter_firebase_news_app/product/enums/widget_sizes.dart';
import 'package:flutter_firebase_news_app/product/models/category.dart';
import 'package:flutter_firebase_news_app/product/utility/firebase/firebase_collections.dart';
import 'package:flutter_firebase_news_app/product/utility/firebase/firebase_utility.dart';
import 'package:kartal/kartal.dart';

class HomeCreateView extends StatefulWidget {
  const HomeCreateView({super.key});

  @override
  State<HomeCreateView> createState() => _HomeCreateViewState();
}

class _HomeCreateViewState extends State<HomeCreateView> with FirebaseUtility {
  List<CategoryModel>? categories = [];
  @override
  void initState() {
    super.initState();
    _fetchInitialCategory();
    
  }

  Future<void> _fetchInitialCategory() async {
    final response=await fetchList<CategoryModel,CategoryModel>(CategoryModel(), FirebaseCollections.category);
    categories=response ?? [];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
      title: Text('add new item'),
      ),
      body:Padding(
        padding: context.padding.low,
        //listview verdik bu photo kısmının widhti infinity yani sonsuz olurdu çünkü listview 
        //sonsuzluk sağlıyor column olsaydı icon kadar widht verirdi sonsuzluk sağlamaz column
        child: ListView(
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hint: Text('category'),
                ),
              ),
              _EmptySizedBox(),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hint: Text('title'),
                ),
               ),
               _EmptySizedBox(),
              //icon butonla sarmalayı denedık baktık olmuyor tam ıstedıgımı gıbı ıstedıgımız sekılde elde edemedık butonumuzu
              //Bizde inkwelle sarmalayalim gibi bir çözüm bulduk o nedenle bu şekilde yapıyoruz
              InkWell(
                onTap: (){},
                child: SizedBox(
                  height: context.sized.dynamicHeight(0.2),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorConstants.grayPrimary,
                        
                        ),
                    ),
                    child: Icon(Icons.add_a_photo_outlined)),
                  ),
              ),
              _EmptySizedBox(),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  //padding: context.padding.low,
                  fixedSize: Size.fromHeight(WidgetSizes.buttonNormal.value.toDouble()),
                ),
                onPressed: (){}, label: Text("submit"),icon: Icon(Icons.send,))
            ],
          ),
        ),
      
    );
  }
}

class _EmptySizedBox extends StatelessWidget {
  const _EmptySizedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return context.sized.emptySizedHeightBoxLow;
  }
}