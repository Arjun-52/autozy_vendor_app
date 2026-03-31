import 'package:flutter/material.dart';

class TopAlert extends StatefulWidget {
  final String message;
  final VoidCallback onClose;
  final Duration duration;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final IconData icon;

  const TopAlert({
    super.key,
    required this.message,
    required this.onClose,
    required this.duration,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.icon,
  });

  @override
  State<TopAlert> createState() => _TopAlertState();
}

class _TopAlertState extends State<TopAlert>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    /// Auto dismiss
    Future.delayed(widget.duration, () {
      if (mounted) {
        _close();
      }
    });
  }

  void _close() async {
    await _controller.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 12),
              ],
            ),
            child: Stack(
              children: [
                /// MAIN CONTENT
                Row(
                  children: [
                    /// LEFT ICON
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// MESSAGE
                    Expanded(
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(width: 30),
                  ],
                ),

                Positioned(
                  top: 1.7,
                  right: 1.7,
                  child: GestureDetector(
                    onTap: _close,
                    child: const CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,

                      child: Icon(Icons.close, size: 15, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
