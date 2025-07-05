import 'package:flutter/material.dart';
import 'package:flutter_firebase_news_app/product/enums/image_sizes.dart';
import 'package:flutter_firebase_news_app/product/models/recommended.dart';
import 'package:kartal/kartal.dart';

class RecommendedCard extends StatelessWidget {
  const RecommendedCard({
    super.key,
    required this.recommended,
  });

  final Recommended recommended;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.onlyTopLow,
      child: Row(
        children: [
          Image.network(recommended.image ?? '',
          height: ImageSizes.normal.value.toDouble(),
          width: ImageSizes.normal.value.toDouble(),
          errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
          ),
          
          Expanded(
            child: ListTile(
                title: Text(recommended.title ?? ''),
                subtitle: Text(recommended.description ?? ''),
              
            ),
          )
        ],
      ),
    );
  }
}