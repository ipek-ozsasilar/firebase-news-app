import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/feature/home/home_create/home_logic.dart';
import 'package:flutter_firebase_news_app/product/constants/color_constants.dart';
import 'package:flutter_firebase_news_app/product/constants/string_constants.dart';
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

class _HomeCreateViewState extends State<HomeCreateView>{
  late final HomeLogic _homeLogic;
  @override
  void initState() {
    super.initState();
    _homeLogic=HomeLogic();
    _fetchInitialCategory();
    
  }

  Future<void> _fetchInitialCategory() async {
    await _homeLogic.fetchListCategory();
    
    
  //fetcAllCategory işlemini yap sonra git ekranı güncelle
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
      title: Text(StringConstants.addItemTitle),
      ),
      //Form validation işlemleri kullanacağımız için form ile sarmaladık
      body:Form(
        child: Padding(
          padding: context.padding.low,
          //listview verdik bu photo kısmının widhti infinity yani sonsuz olurdu çünkü listview 
          //sonsuzluk sağlıyor column olsaydı icon kadar widht verirdi sonsuzluk sağlamaz column
          child: ListView(
              children: [
                _HomeDropDownCategory(categories: _homeLogic.categories ?? [],
                 onSelected: (value) {
                  _homeLogic.updateCategory(value);
                }),
                _EmptySizedBox(),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hint: Text(StringConstants.dropdownTitle),
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
                  onPressed: (){}, label: Text(StringConstants.buttonSave),icon: Icon(Icons.send,))
              ],
            ),
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


class _HomeDropDownCategory extends StatelessWidget {
   _HomeDropDownCategory({super.key,required this.categories, required this.onSelected,});
  final List<CategoryModel> categories;
  final ValueSetter<CategoryModel>onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CategoryModel>(
                items: categories.map((e) {
                    return DropdownMenuItem<CategoryModel>(
                      value:e,
                      child: Column(
                        children: [
                          Text(e.name ?? ''),
                      
                        ],
                      )
                    );
                  }).toList() ?? [],
                  hint: Text(StringConstants.dropdownHint),
                 onChanged: (value){
                  if(value==null) return;
                  onSelected.call(value);

                 }
                 
                 );
  }
}