import 'package:flutter/material.dart';

OverlayEntry? _topBannerEntry;

void showTopStatusBanner(BuildContext context, String message, IconData icon) {
  if (_topBannerEntry != null) {
    _topBannerEntry!.remove();
    _topBannerEntry = null;
  }

  final overlay = Overlay.of(context);

  _topBannerEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: _TopBannerWidget(message: message, icon: icon),
    ),
  );

  overlay.insert(_topBannerEntry!);

  Future.delayed(const Duration(milliseconds: 3000), () {
    if (_topBannerEntry != null) {
      _topBannerEntry!.remove();
      _topBannerEntry = null;
    }
  });
}

void handleOnlineToggle(BuildContext context, bool isOnline) {
  if (isOnline) {
    showTopStatusBanner(context, "Switched to Online mode", Icons.wifi);
  } else {
    showTopStatusBanner(context, "Switched to Offline mode", Icons.wifi_off);
  }
}

class _TopBannerWidget extends StatefulWidget {
  final String message;
  final IconData icon;

  const _TopBannerWidget({required this.message, required this.icon});

  @override
  State<_TopBannerWidget> createState() => _TopBannerWidgetState();
}

class _TopBannerWidgetState extends State<_TopBannerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 20, color: Colors.black87),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
