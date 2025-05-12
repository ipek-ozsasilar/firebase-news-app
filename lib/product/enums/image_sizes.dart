// Simple enum ile de      int colorValue = EnhancedColorNames.blue.getcolor().value;   diyerek dırekt valuyu alabılırız ama getcolor() extensıonın
// enhanced enumda ise     int colorValue = EnhancedColorNames.blue.color.value;      Daha sade ve color degıskenı dırekt enuma aıt
// Artık enhanced enum ile enumlara constructor, field, method ve hatta getter ekleyebiliyorsun.
// Bir daha ekstradan red ile color.sred dondur tarzı extensıon yazmaya da gerek kalmıyor
//Instance değişkenleri final olmak zorundadır ve Üretilen tüm constructorlar const olmalıdır. gıbı sınırlanmaları var tabi.

enum ImageSizes{
  high(256);
  
  final int value;
  const ImageSizes(this.value);
}