part of '../home_view.dart';


class _ActiveChip extends StatelessWidget {
  const _ActiveChip({
    required this.tag,
  });
  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return Chip(
    backgroundColor: ColorConstants.purplePrimary,
    label: Text(tag.name ?? '',style: context.general.textTheme.bodySmall?.copyWith(
      color: ColorConstants.white,
      ),),
    padding: context.padding.low,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.sized.dynamicWidth(0.1)),
    ),
    );
  }
}

class _PassiveChip extends StatelessWidget {
  const _PassiveChip({
    required this.tag,
  });
 final Tag tag;
  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: ColorConstants.grayLighter,
      label: Text(tag.name ?? '',style: context.general.textTheme.bodySmall?.copyWith(
        color: ColorConstants.grayPrimary,
        ),),
      padding: context.padding.low,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.sized.dynamicWidth(0.1)),
      ),
      );
  }
}