import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

OverlayEntry? _currentBanner;

void TopBanner(BuildContext context, String message) {
  final overlay = Navigator.of(context).overlay;
  if (overlay == null) return;

  _currentBanner?.remove();

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: -100.0, end: 0.0),
          builder: (context, value, child) {
            return Transform.translate(offset: Offset(0, value), child: child);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      if (entry.mounted) {
                        entry.remove();
                        if (_currentBanner == entry) {
                          _currentBanner = null;
                        }
                      }
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                Row(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xff2F3337),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/Vector.svg',
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        width: 16,
                        height: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  _currentBanner = entry;
  overlay.insert(entry);

  Future.delayed(const Duration(seconds: 3), () {
    if (entry.mounted) {
      entry.remove();
      if (_currentBanner == entry) {
        _currentBanner = null;
      }
    }
  });
}
