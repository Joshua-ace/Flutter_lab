import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A 3D Holographic Rotating Halo and Levitation widget
/// for hero portraits and avatars.
class Rotating3DHalo extends StatefulWidget {
  final Widget child;
  final double size;
  final Color primaryGlow;
  final Color secondaryGlow;
  final bool enableLevitation;

  const Rotating3DHalo({
    super.key,
    required this.child,
    this.size = 150.0,
    this.primaryGlow = AppTheme.primaryColor,
    this.secondaryGlow = const Color(0xFF00E5FF), // Holographic Cyan
    this.enableLevitation = true,
  });

  @override
  State<Rotating3DHalo> createState() => _Rotating3DHaloState();
}

class _Rotating3DHaloState extends State<Rotating3DHalo> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _levitationController;
  late Animation<double> _levitationAnim;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _levitationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _levitationAnim = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _levitationController, curve: Curves.easeInOut),
    );

    if (widget.enableLevitation) {
      _levitationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _levitationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _levitationController]),
      builder: (context, _) {
        final levitationOffset = widget.enableLevitation ? _levitationAnim.value : 0.0;
        final angle1 = _rotationController.value * 2 * math.pi;
        final angle2 = -_rotationController.value * 2 * math.pi * 1.5;

        return Transform.translate(
          offset: Offset(0, levitationOffset),
          child: SizedBox(
            width: widget.size + 40,
            height: widget.size + 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ambient 3D Depth Shadow under avatar
                Positioned(
                  bottom: 4,
                  child: Container(
                    width: widget.size * 0.75,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.18 + (levitationOffset > 0 ? 0.08 : 0.0),
                          ),
                          blurRadius: 18 + levitationOffset.abs() * 2,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),

                // Outer 3D Orbital Ring 1
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002)
                    ..rotateX(64 * math.pi / 180)
                    ..rotateZ(angle1),
                  child: Container(
                    width: widget.size + 36,
                    height: widget.size + 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.secondaryGlow.withValues(alpha: 0.7),
                        width: 2.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.secondaryGlow.withValues(alpha: 0.45),
                          blurRadius: 14,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Orbiting Energy Bead 1
                        Positioned(
                          top: 0,
                          left: (widget.size + 36) / 2 - 5,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: widget.secondaryGlow,
                                  blurRadius: 10,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Counter-Rotating Inner 3D Orbital Ring 2
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002)
                    ..rotateX(58 * math.pi / 180)
                    ..rotateY(25 * math.pi / 180)
                    ..rotateZ(angle2),
                  child: Container(
                    width: widget.size + 20,
                    height: widget.size + 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.primaryGlow.withValues(alpha: 0.8),
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.primaryGlow.withValues(alpha: 0.5),
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Orbiting Energy Bead 2
                        Positioned(
                          bottom: 0,
                          right: (widget.size + 20) / 2 - 4,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: widget.primaryGlow,
                                  blurRadius: 8,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Centered Avatar Widget with 3D Radial Backlight
                Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.primaryGlow.withValues(alpha: 0.35),
                        blurRadius: 28,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: widget.child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
