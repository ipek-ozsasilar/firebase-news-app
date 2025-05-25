import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_news_app/product/constants/color_constants.dart';
import 'package:flutter_firebase_news_app/product/enums/widget_sizes.dart';
import 'package:flutter_firebase_news_app/product/models/news.dart';
import 'package:flutter_firebase_news_app/product/widget/text/subtitle_text.dart';
import 'package:kartal/kartal.dart';

class HomeBrowseCard extends StatelessWidget {
  const HomeBrowseCard({
    super.key,
    required this.newsItem
  });

  final News? newsItem;

  @override
  Widget build(BuildContext context) {
    //Gelen veri yani news doc null ıse bos kısım gosterılır
    if(newsItem==null) return const SizedBox.shrink();
    if(newsItem?.backgroundImage==null) return const Placeholder();
    

    return Stack(
      children: [
        Padding(
          padding: context.padding.onlyRightNormal,
          child: Image.network(newsItem!.backgroundImage!,errorBuilder: (context, error, stackTrace) => Icon(Icons.error),),
        ),
        //Positioned.fill, bir Stack içindeki child widget'ı parent'ın tüm alanını kaplayacak şekilde konumlandırır.
        // Yani: Top: 0 Bottom: 0 Left: 0 Right: 0 overlayler ıcın falann idealdir
        Positioned.fill(
          child: Padding(
            padding: context.padding.low,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.bookmark_outline,
                    color: ColorConstants.white,
                    size: WidgetSizes.iconNormal.value.toDouble(),
                  ),
                ),
                Spacer(),
                //ıkı texte ayrı ayrı paddıng vermek yerıne column ıle sarmalayıp ona verdık paddıngı
                Padding(
                  padding: context.padding.low,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubTitleText(
                        //dummy
                        //eger null ıse bos vermek dogru bır kullanım dgeıl suan ıcın boyle yaptık
                        value: newsItem!.category ?? '',
                        color: ColorConstants.grayLighter,
                      ),
                      
                      
                      Text(
                        newsItem!.title ?? '',
                        style: context.general.textTheme.titleMedium
                            ?.copyWith(color: ColorConstants.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}