import 'package:flutter/material.dart';
import 'package:property_tax_system_fd/shared/theme/app_theme.dart';

class ThemeAwareCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Color? color;
  final bool withShadow;

  const ThemeAwareCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.color,
    this.withShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? context.cardBackground,
      elevation: elevation ?? (withShadow ? 2 : 0),
      margin: margin ?? const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
