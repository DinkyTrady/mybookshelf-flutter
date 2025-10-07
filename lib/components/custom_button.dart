import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isLoading;
  final String text;
  final List<Color> gradientColors;
  final double borderRadius;
  final TextStyle? textStyle;
  final Widget? child;
  final double? height;
  final Alignment begin;
  final Alignment end;
  final Color? hoverColor;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.gradientColors,
    this.height,
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    this.isLoading = false,
    this.borderRadius = 12,
    this.textStyle,
    this.child,
    this.hoverColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: begin,
          end: end,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withAlpha(90),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          hoverColor: hoverColor ?? Colors.transparent,
          focusColor: hoverColor ?? Colors.transparent,
          highlightColor: Colors.transparent,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : child ??
                      Text(
                        text,
                        style:
                            textStyle ??
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
          ),
        ),
      ),
    );
  }
}
