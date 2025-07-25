import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/feature/auth/authentication_view.dart';
import 'package:flutter_firebase_news_app/feature/home/home_create/home_logic.dart';
import 'package:flutter_firebase_news_app/product/constants/color_constants.dart';
import 'package:flutter_firebase_news_app/product/constants/string_constants.dart';
import 'package:flutter_firebase_news_app/product/enums/widget_sizes.dart';
import 'package:flutter_firebase_news_app/product/models/category.dart';
import 'package:kartal/kartal.dart';

class HomeCreateView extends StatefulWidget {
  const HomeCreateView({super.key});

  @override
  State<HomeCreateView> createState() => _HomeCreateViewState();
}

class _HomeCreateViewState extends State<HomeCreateView> with Loading{
  late final HomeLogic _homeLogic;
  @override
  void initState() {
    super.initState();
    _homeLogic=HomeLogic();
    _fetchInitialCategory();
  }

  @override
  void dispose() {
    super.dispose();
    _homeLogic.dispose();
  }
  

  //setState() çağrıldığı anda build() fonksiyonu daha önce bir kez çalışmış olmalı.
  //initState() çalışırken, build() henüz yeniden çizim yapmamıştır ama Flutter zaten ilk kez bir "çizim"
  // için sıraya almıştır. dolayısıyla: initState() içinde async işlemler başlatılır (API çağrısı gibi),
  //o işlem bitince setState() çağrılarak ilk çizimden sonra UI tekrar güncellenir.
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
      actions: [
        if(isLoading)Center(child: CircularProgressIndicator(color: ColorConstants.white,)),
      ]
      ),
      //Form validation işlemleri kullanacağımız için form ile sarmaladık
      body:Form(
        onChanged: () {
          _homeLogic.checkValidateAndSave(

            (value){
              setState(() {});
            }
          );
          //butonun validasyondan sonra ekranda bir değişiklik olduğunu anlaması tetiklenmesi için setstate dedık
          //tabi buradaki dezavantaj boş yere gereksiz elemanlar da tekrar çizilecek
          setState(() {});
        },
        autovalidateMode: AutovalidateMode.always,
        key: _homeLogic.formKey,
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
                  controller: _homeLogic.titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hint: Text(StringConstants.dropdownTitle),
                  ),
                  validator: (value) => value!.isNotEmpty ? null: 'Not Empty',
                 ),
                 _EmptySizedBox(),
                //icon butonla sarmalayı denedık baktık olmuyor tam ıstedıgımı gıbı ıstedıgımız sekılde elde edemedık butonumuzu
                //Bizde inkwelle sarmalayalim gibi bir çözüm bulduk o nedenle bu şekilde yapıyoruz
                InkWell(
                  onTap: () async {
                    await _homeLogic.pickAndCheck(
                      (value){
                        setState(() {});
                      }
                    );
                    
                  },
                  child: SizedBox(
                    height: context.sized.dynamicHeight(0.2),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorConstants.grayPrimary,
                          
                          ),
                      ),
                      // Bu sadece resmi EKRANDA gösterir hiçbir yere KAYDETMEZ
                      //RAM'de (bellekte) bulunan ham byte verisinden (örneğin Uint8List) resmi oluşturur
                      //networl gıbı ınternet gerektormez assets ve memory
                      child: _homeLogic.selectedFileBytes != null? Image.memory(_homeLogic.selectedFileBytes!) 
                      : Icon(Icons.add_a_photo_outlined)),
                    ),
                ),
                _EmptySizedBox(),
        
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    //padding: context.padding.low,
                    fixedSize: Size.fromHeight(WidgetSizes.buttonNormal.value.toDouble()),
                    backgroundColor: ColorConstants.purplePrimary,
                  ),
                  onPressed:_homeLogic.isValidateAllForm ? null:()async{
                    changeLoading();
                    final response=await _homeLogic.Save();
                    changeLoading();
                    if(response){
                     await context.route.pop<bool>(response);
                    }
                  },
                   label: Text(StringConstants.buttonSave),icon: Icon(Icons.send,))
              ],
            ),
          ),
      ),
      
    );
  }
}

class _EmptySizedBox extends StatelessWidget {
  const _EmptySizedBox();

  @override
  Widget build(BuildContext context) {
    return context.sized.emptySizedHeightBoxLow;
  }
}


class _HomeDropDownCategory extends StatelessWidget {
   _HomeDropDownCategory({required this.categories, required this.onSelected,});
  final List<CategoryModel> categories;
  final ValueSetter<CategoryModel>onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CategoryModel>(
      validator: (value) => value==null ?  'Not Empty' : null,
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

mixin Loading on State<HomeCreateView>{
  bool isLoading=false;
  void changeLoading(){
    setState(() {
      isLoading=!isLoading;
    });
  }
}