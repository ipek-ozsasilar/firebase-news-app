import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class SubTitleText extends StatelessWidget {
   SubTitleText({super.key, required this.value, this.color});
  final String value;
 Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
            value,
            style: context.general.appTheme.textTheme.titleMedium?.copyWith(
              color: color,
            ),
          );
  }
}