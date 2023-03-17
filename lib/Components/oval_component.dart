import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  CustomContainer({
    required this.child,
    this.onTap,
  this.height,
  this.width,
    Key? key,
    required,
  }) : super(key: key);
  final Widget? child;
  void Function()? onTap;
  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
height: height,
          width: width,
          child: Center(child: child),
        ),
      ),
      color: Theme.of(context).colorScheme.surface,
      shadowColor: Colors.transparent,
    );
  }
}
