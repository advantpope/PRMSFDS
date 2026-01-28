import 'package:flutter/material.dart';
import 'package:property_tax_system_fd/shared/theme/app_theme.dart';

class ThemeAwareChip extends StatelessWidget {
  final String label;
  final ChipType type;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;
  final bool selected;

  const ThemeAwareChip({
    super.key,
    required this.label,
    this.type = ChipType.neutral,
    this.icon,
    this.color,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    Color textColor;

    switch (type) {
      case ChipType.success:
        chipColor = context.successColor.withOpacity(0.1);
        textColor = context.successColor;
        break;
      case ChipType.warning:
        chipColor = context.warningColor.withOpacity(0.1);
        textColor = context.warningColor;
        break;
      case ChipType.error:
        chipColor = context.taxOverdueColor.withOpacity(0.1);
        textColor = context.taxOverdueColor;
        break;
      case ChipType.info:
        chipColor = context.infoColor.withOpacity(0.1);
        textColor = context.infoColor;
        break;
      case ChipType.activeProperty:
        chipColor = context.propertyActiveColor.withOpacity(0.1);
        textColor = context.propertyActiveColor;
        break;
      case ChipType.inactiveProperty:
        chipColor = context.propertyInactiveColor.withOpacity(0.1);
        textColor = context.propertyInactiveColor;
        break;
      case ChipType.taxPaid:
        chipColor = context.taxPaidColor.withOpacity(0.1);
        textColor = context.taxPaidColor;
        break;
      case ChipType.taxDue:
        chipColor = context.taxDueColor.withOpacity(0.1);
        textColor = context.taxDueColor;
        break;
      case ChipType.neutral:
      default:
        chipColor = context.colorScheme.surfaceVariant;
        textColor = context.colorScheme.onSurfaceVariant;
        break;
    }

    if (color != null) {
      chipColor = color!.withOpacity(0.1);
      textColor = color!;
    }

    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? textColor.withOpacity(0.2) : chipColor,
        borderRadius: BorderRadius.circular(20),
        border: selected ? Border.all(color: textColor, width: 1.5) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: chip);
    }

    return chip;
  }
}

enum ChipType {
  success,
  warning,
  error,
  info,
  activeProperty,
  inactiveProperty,
  taxPaid,
  taxDue,
  neutral,
}
