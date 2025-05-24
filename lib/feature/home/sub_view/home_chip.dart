part of '../home_view.dart';


class _ActiveChip extends StatelessWidget {
  const _ActiveChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
    backgroundColor: ColorConstants.purplePrimary,
    label: Text('label active',style: context.general.textTheme.bodySmall?.copyWith(
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: ColorConstants.grayLighter,
      label: Text('label passive',style: context.general.textTheme.bodySmall?.copyWith(
        color: ColorConstants.grayPrimary,
        ),),
      padding: context.padding.low,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.sized.dynamicWidth(0.1)),
      ),
      );
  }
}