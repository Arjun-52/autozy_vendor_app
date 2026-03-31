import 'package:flutter/material.dart';
import '../widgets/top_alert.dart';

class AlertService {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  static void showTopAlert(
    BuildContext context, {
    required String message,
    VoidCallback? onClose,
    Duration duration = const Duration(seconds: 3),
    Color backgroundColor = Colors.white,
    Color iconColor = Colors.red,
    Color textColor = Colors.black,
    IconData icon = Icons.warning_amber_rounded,
  }) {
    if (_isShowing) return;

    _isShowing = true;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: TopAlert(
          message: message,
          onClose: () {
            hideAlert();
            onClose?.call();
          },
          duration: duration,
          backgroundColor: backgroundColor,
          iconColor: iconColor,
          textColor: textColor,
          icon: icon,
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hideAlert() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isShowing = false;
    }
  }

  static bool get isShowing => _isShowing;
}
