import 'package:flutter/material.dart';

class CustomBrandIcon extends StatelessWidget {
  final String assetName;
  final double size;
  final Color? color;

  const CustomBrandIcon({
    super.key,
    required this.assetName,
    this.size = 24.0,
    this.color,
  });

  static Widget github({double size = 24, Color? color}) =>
      CustomBrandIcon(assetName: 'assets/custom icons/icons-github.png', size: size, color: color);

  static Widget linkedin({double size = 24, Color? color}) =>
      CustomBrandIcon(assetName: 'assets/custom icons/icons-linkedin.png', size: size, color: color);
  
  static Widget eMail({double size = 24, Color? color}) =>
      CustomBrandIcon(assetName: 'assets/custom icons/icons-outlook.png', size: size, color: color);
  
  static Widget leetCode({double size = 24, Color? color}) => 
      CustomBrandIcon(assetName: 'assets/custom icons/icons-leetcode.png', size: size, color: color);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetName,
      width: size,
      height: size,
      color: color,
    );
  }
}