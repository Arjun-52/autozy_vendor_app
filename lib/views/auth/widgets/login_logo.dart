import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 72,
          width: 72,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: SizedBox(
            height: 44,
            width: 44,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, right: 4),
                    child: SvgPicture.asset(
                      "assets/images/car2.svg",
                      colorFilter: const ColorFilter.mode(
                        AppColors.textPrimary,
                        BlendMode.srcIn,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.auto_awesome,
                    size: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "autozy",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
            color: AppColors.title,
          ),
        ),
        const Text(
          "Service",
          style: TextStyle(fontSize: 14, color: AppColors.shadeYellow),
        ),
      ],
    );
  }
}
