import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:flutter_firebase_news_app/product/constants/color_constants.dart';

class WavyBoldText extends StatelessWidget {
  final String title;
  WavyBoldText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Flutter'da animasyonları hem animated_text_kit gibi özel Flutter widget paketleriyle,
    //hem de Lottie gibi JSON tabanlı hazır animasyon sistemleriyle sağlayabilirsin
    return AnimatedTextKit(
      repeatForever: true,
      animatedTexts: [
        WavyAnimatedText(
          title,
          textStyle: context.general.textTheme.headlineSmall?.copyWith(
            color: ColorConstants.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
