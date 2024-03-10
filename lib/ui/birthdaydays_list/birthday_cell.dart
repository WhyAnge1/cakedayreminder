import 'package:animate_gradient/animate_gradient.dart';
import 'package:cakeday_reminder/business_logic/birthday/birthday_model.dart';
import 'package:cakeday_reminder/ui/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:glowy_borders/glowy_borders.dart';

class BirthdayCell extends StatelessWidget {
  final BirthdayModel model;
  final VoidCallback onTap;
  final bool isBirthdayCell;

  const BirthdayCell({
    Key? key,
    required this.model,
    required this.onTap,
    this.isBirthdayCell = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isBirthdayCell ? _buildBirthdayCell() : _buildRegularCell(),
    );
  }

  Widget _buildRegularCell() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: AppColors.lion,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.personName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.cornsilk,
              ),
            ),
            if (model.note.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    model.note,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.cornsilk,
                    ),
                  ),
                ],
              ),
          ],
        ),
      );

  Widget _buildBirthdayCell() => AnimatedGradientBorder(
        borderSize: 1,
        glowSize: 0,
        gradientColors: const [
          AppColors.princetonOrange,
          AppColors.icterine,
        ],
        stretchAlongAxis: true,
        borderRadius: BorderRadius.circular(7),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: AppColors.lion,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientAnimationText(
                text: Text(
                  model.personName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cornsilk,
                  ),
                ),
                colors: const [
                  AppColors.princetonOrange,
                  AppColors.icterine,
                ],
                duration: const Duration(seconds: 2),
              ),
              if (model.note.isNotEmpty)
                Column(
                  children: [
                    const SizedBox(height: 10),
                    GradientAnimationText(
                      text: Text(
                        model.note,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.cornsilk,
                        ),
                      ),
                      colors: const [
                        AppColors.princetonOrange,
                        AppColors.icterine,
                      ],
                      duration: const Duration(seconds: 2),
                    )
                  ],
                ),
            ],
          ),
        ),
      );
}
