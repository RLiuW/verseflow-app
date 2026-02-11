import 'dart:ui';
import 'package:flutter/material.dart';

/// Card com efeito glassmorphism: BackdropFilter.blur + Container com opacidade.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.opacity = 0.8,
    this.blurSigma = 10,
    this.padding,
    this.margin,
    this.elevation = 2,
  });

  final Widget child;
  final double borderRadius;
  final double opacity;
  final double blurSigma;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surface;
    final effectiveOpacity = opacity.clamp(0.0, 1.0);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: elevation * 4,
                  offset: Offset(0, elevation),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: effectiveOpacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: color.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
