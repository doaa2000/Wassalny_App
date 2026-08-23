import 'package:flutter/material.dart';

/// Lets code outside the widget tree (push notification handlers, deep
/// links, etc.) trigger navigation without needing a [BuildContext].
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
