import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/driver.dart';

/// Presentation helpers that turn the domain [Driver]'s raw ARGB values into
/// Flutter [Color]/[Gradient] objects and resolve its tag styling. Keeps colour
/// logic out of both the domain layer and the widgets.
extension DriverPresentation on Driver {
  Color get carColor => Color(carColorValue);

  LinearGradient get avatarGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(avatarStartValue), Color(avatarEndValue)],
      );

  Color get tagBackground =>
      recommended ? AppColors.successBg : AppColors.neutralTagBg;

  Color get tagColor =>
      recommended ? AppColors.successDark : AppColors.neutralTagText;
}
