import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// High-performance GPU-accelerated 3D Animated Background
/// Features rotating 3D wireframe polyhedra (cube, diamond octahedron, celestial ring,
/// and hexagonal prism), a floating 3D particle constellation with perspective projection,
/// dynamic proximity lines, and ambient glowing 3D aurora light orbs with mouse/touch parallax.
class Animated3DBackground extends StatefulWidget {
  final Widget? child;
  final bool enableParallax;

  const Animated3DBackground({
    super.key,
    this.child,
    this.enableParallax = true,
  });

  @override
  State<Animated3DBackground> createState() => _Animated3DBackgroundState();
}

class _Animated3DBackgroundState extends State<Animated3DBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle3D> _particles = [];
  final math.Random _random = math.Random(42);

  double _mouseTargetX = 0.0;
  double _mouseTargetY = 0.0;
  double _mouseCurrentX = 0.0;
  double _mouseCurrentY = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    // Initialize 60 3D particles distributed across 3D space (X, Y, Z)
    for (int i = 0; i < 60; i++) {
      _particles.add(
        _Particle3D(
          x: (_random.nextDouble() - 0.5) * 1000,
          y: (_random.nextDouble() - 0.5) * 1400,
          z: _random.nextDouble() * 950 + 80,
          speedZ: _random.nextDouble() * 0.9 + 0.35,
          radius: _random.nextDouble() * 2.8 + 1.2,
          colorIndex: i % 4,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updatePointerNorm(Offset localPos, Size size) {
    if (!widget.enableParallax || size.width == 0 || size.height == 0) return;
    final normX = (localPos.dx / size.width - 0.5) * 2;
    final normY = (localPos.dy / size.height - 0.5) * 2;
    setState(() {
      _mouseTargetX = normX.clamp(-1.0, 1.0);
      _mouseTargetY = normY.clamp(-1.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(
          constraints.maxWidth.isFinite ? constraints.maxWidth : 400,
          constraints.maxHeight.isFinite ? constraints.maxHeight : 800,
        );

        return Listener(
          onPointerMove: (e) => _updatePointerNorm(e.localPosition, size),
          child: MouseRegion(
            onHover: (e) => _updatePointerNorm(e.localPosition, size),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                // Smooth camera parallax interpolation
                _mouseCurrentX += (_mouseTargetX - _mouseCurrentX) * 0.06;
                _mouseCurrentY += (_mouseTargetY - _mouseCurrentY) * 0.06;

                final time = _controller.value * 2 * math.pi;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Deep Space Atmospheric Gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                                  const Color(0xFF090614),
                                  const Color(0xFF130E26),
                                  const Color(0xFF1A1235),
                                  const Color(0xFF0C091A),
                                ]
                              : [
                                  const Color(0xFFFAF9FF),
                                  const Color(0xFFF1EEFD),
                                  const Color(0xFFE9E4FC),
                                  const Color(0xFFF5F3FF),
                                ],
                        ),
                      ),
                    ),

                    // Floating 3D Glowing Aurora Orbs
                    CustomPaint(
                      size: size,
                      painter: _AuroraOrbsPainter(
                        time: time,
                        isDark: isDark,
                        parallaxX: _mouseCurrentX,
                        parallaxY: _mouseCurrentY,
                      ),
                    ),

                    // 3D Wireframe Polyhedra, Rings & Perspective Starfield
                    CustomPaint(
                      size: size,
                      painter: _Scene3DPainter(
                        time: time,
                        particles: _particles,
                        isDark: isDark,
                        camRotX: _mouseCurrentY * 0.28,
                        camRotY: _mouseCurrentX * 0.35,
                      ),
                    ),

                    // Foreground Child (if provided)
                    if (widget.child != null) widget.child!,
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _Particle3D {
  double x;
  double y;
  double z;
  double speedZ;
  double radius;
  int colorIndex;

  _Particle3D({
    required this.x,
    required this.y,
    required this.z,
    required this.speedZ,
    required this.radius,
    required this.colorIndex,
  });
}

/// Painter for glowing 3D Aurora light orbs in the background
class _AuroraOrbsPainter extends CustomPainter {
  final double time;
  final bool isDark;
  final double parallaxX;
  final double parallaxY;

  _AuroraOrbsPainter({
    required this.time,
    required this.isDark,
    required this.parallaxX,
    required this.parallaxY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Orb 1: Royal Violet Ambient Cloud
    final orb1X = centerX + math.sin(time * 0.6) * (size.width * 0.3) + (parallaxX * 32);
    final orb1Y = centerY * 0.55 + math.cos(time * 0.45) * (size.height * 0.16) + (parallaxY * 32);
    final orb1Radius = size.width * 0.55;

    final paint1 = Paint()
      ..shader = RadialGradient(
        colors: [
          (isDark ? AppTheme.primaryColor : const Color(0xFFC4B5FD))
              .withValues(alpha: isDark ? 0.32 : 0.25),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(orb1X, orb1Y), radius: orb1Radius));

    canvas.drawCircle(Offset(orb1X, orb1Y), orb1Radius, paint1);

    // Orb 2: Holographic Cyan Nebula
    final orb2X = centerX + math.cos(time * 0.5) * (size.width * 0.35) - (parallaxX * 36);
    final orb2Y = centerY * 1.35 + math.sin(time * 0.7) * (size.height * 0.2) - (parallaxY * 36);
    final orb2Radius = size.width * 0.58;

    final paint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          (isDark ? const Color(0xFF00E5FF) : const Color(0xFFBAE6FD))
              .withValues(alpha: isDark ? 0.26 : 0.20),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(orb2X, orb2Y), radius: orb2Radius));

    canvas.drawCircle(Offset(orb2X, orb2Y), orb2Radius, paint2);

    // Orb 3: Coral Heart Flare
    final orb3X = centerX * 0.4 + math.sin(time * 0.8) * (size.width * 0.22) + (parallaxX * 24);
    final orb3Y = centerY * 0.95 + math.cos(time * 0.55) * (size.height * 0.14) + (parallaxY * 24);
    final orb3Radius = size.width * 0.42;

    final paint3 = Paint()
      ..shader = RadialGradient(
        colors: [
          (isDark ? AppTheme.accentHeart : const Color(0xFFFED7AA))
              .withValues(alpha: isDark ? 0.22 : 0.16),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(orb3X, orb3Y), radius: orb3Radius));

    canvas.drawCircle(Offset(orb3X, orb3Y), orb3Radius, paint3);
  }

  @override
  bool shouldRepaint(covariant _AuroraOrbsPainter oldDelegate) => true;
}

/// 3D Geometry and Particle Space Painter
class _Scene3DPainter extends CustomPainter {
  final double time;
  final List<_Particle3D> particles;
  final bool isDark;
  final double camRotX;
  final double camRotY;

  _Scene3DPainter({
    required this.time,
    required this.particles,
    required this.isDark,
    required this.camRotX,
    required this.camRotY,
  });

  // Perspective projection constant (field of view)
  static const double fov = 520.0;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final colors = isDark
        ? [
            AppTheme.primaryColor.withValues(alpha: 0.85),
            const Color(0xFF00E5FF).withValues(alpha: 0.85),
            AppTheme.accentHeart.withValues(alpha: 0.75),
            Colors.white.withValues(alpha: 0.9),
          ]
        : [
            AppTheme.primaryColor.withValues(alpha: 0.55),
            const Color(0xFF0284C7).withValues(alpha: 0.50),
            const Color(0xFFF97316).withValues(alpha: 0.45),
            AppTheme.primaryDark.withValues(alpha: 0.6),
          ];

    // 1. Draw 3D Rotating Wireframe Cube (Upper-Right)
    _drawRotating3DCube(
      canvas: canvas,
      center: Offset(centerX + size.width * 0.32, centerY * 0.40),
      size3D: 68.0,
      rotX: time * 0.8 + camRotX,
      rotY: time * 1.1 + camRotY,
      rotZ: time * 0.5,
      color: isDark ? const Color(0xFF00E5FF) : AppTheme.primaryColor,
      alpha: isDark ? 0.45 : 0.32,
    );

    // 2. Draw 3D Rotating Hexagonal Prism (Upper-Left)
    _drawRotating3DHexPrism(
      canvas: canvas,
      center: Offset(centerX - size.width * 0.33, centerY * 0.48),
      radius3D: 45.0,
      height3D: 60.0,
      rotX: -time * 0.65 + camRotX,
      rotY: time * 0.75 + camRotY,
      rotZ: time * 0.3,
      color: isDark ? const Color(0xFFA855F7) : const Color(0xFF7C3AED),
      alpha: isDark ? 0.40 : 0.28,
    );

    // 3. Draw 3D Rotating Diamond Octahedron (Lower-Left)
    _drawRotating3DOctahedron(
      canvas: canvas,
      center: Offset(centerX - size.width * 0.28, centerY * 1.38),
      size3D: 60.0,
      rotX: -time * 0.7 + camRotX,
      rotY: time * 0.9 + camRotY,
      rotZ: time * 0.4,
      color: isDark ? AppTheme.accentHeart : const Color(0xFFEA580C),
      alpha: isDark ? 0.42 : 0.30,
    );

    // 4. Draw 3D Dual Concentric Rings (Lower-Right)
    _drawRotating3DDualRings(
      canvas: canvas,
      center: Offset(centerX + size.width * 0.26, centerY * 1.35),
      radiusOuter: 56.0,
      radiusInner: 38.0,
      rotX: time * 0.65 + math.pi / 4 + camRotX,
      rotY: time * 0.5 + camRotY,
      color: isDark ? const Color(0xFF38BDF8) : AppTheme.primaryColor,
      alpha: isDark ? 0.38 : 0.26,
    );

    // 5. Update & Render 3D Starfield Particles
    final List<Offset> projectedPoints = [];
    final List<double> pointScales = [];

    for (final p in particles) {
      // Move particle forward in Z space towards viewer
      p.z -= p.speedZ;
      if (p.z < 25) {
        p.z = 950;
        p.x = (_randomDouble() - 0.5) * 1000;
        p.y = (_randomDouble() - 0.5) * 1400;
      }

      // Apply camera rotation (yaw & pitch)
      final cosY = math.cos(camRotY);
      final sinY = math.sin(camRotY);
      final cosX = math.cos(camRotX);
      final sinX = math.sin(camRotX);

      // Rotate Y (yaw)
      final rx = p.x * cosY - p.z * sinY;
      final rz1 = p.x * sinY + p.z * cosY;

      // Rotate X (pitch)
      final ry = p.y * cosX - rz1 * sinX;
      final rz = p.y * sinX + rz1 * cosX;

      if (rz <= 15) continue;

      // 3D Perspective Projection
      final k = fov / (fov + rz);
      final screenX = centerX + rx * k;
      final screenY = centerY + ry * k;

      if (screenX >= -60 && screenX <= size.width + 60 && screenY >= -60 && screenY <= size.height + 60) {
        final screenOffset = Offset(screenX, screenY);
        projectedPoints.add(screenOffset);
        pointScales.add(k);

        // Draw individual particle with perspective depth glow
        final depthAlpha = (k * 1.35).clamp(0.18, 0.95);
        final baseColor = colors[p.colorIndex];
        final particlePaint = Paint()
          ..color = baseColor.withValues(alpha: baseColor.a * depthAlpha)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(screenOffset, p.radius * k, particlePaint);

        // Halo glint on larger close particles
        if (k > 0.7) {
          final glintPaint = Paint()
            ..color = baseColor.withValues(alpha: 0.2)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0;
          canvas.drawCircle(screenOffset, (p.radius * k) + 2.5, glintPaint);
        }
      }
    }

    // 6. Proximity Constellation Lines between nearby 3D points
    final linePaint = Paint()
      ..strokeWidth = 0.9
      ..style = PaintingStyle.stroke;

    final count = projectedPoints.length;
    for (int i = 0; i < count; i++) {
      for (int j = i + 1; j < count; j++) {
        final dX = projectedPoints[i].dx - projectedPoints[j].dx;
        final dY = projectedPoints[i].dy - projectedPoints[j].dy;
        final dist = math.sqrt(dX * dX + dY * dY);

        if (dist < 92) {
          final avgScale = (pointScales[i] + pointScales[j]) / 2;
          final lineAlpha = ((1.0 - (dist / 92)) * avgScale * 0.50).clamp(0.0, 0.45);
          if (lineAlpha > 0.04) {
            linePaint.color = (isDark ? const Color(0xFF00E5FF) : AppTheme.primaryColor)
                .withValues(alpha: lineAlpha);
            canvas.drawLine(projectedPoints[i], projectedPoints[j], linePaint);
          }
        }
      }
    }
  }

  double _randomDouble() => math.Random().nextDouble();

  /// Draw a rotating 3D Wireframe Cube
  void _drawRotating3DCube({
    required Canvas canvas,
    required Offset center,
    required double size3D,
    required double rotX,
    required double rotY,
    required double rotZ,
    required Color color,
    required double alpha,
  }) {
    final s = size3D / 2;
    final vertices = [
      [-s, -s, -s],
      [s, -s, -s],
      [s, s, -s],
      [-s, s, -s],
      [-s, -s, s],
      [s, -s, s],
      [s, s, s],
      [-s, s, s],
    ];

    final edges = [
      [0, 1], [1, 2], [2, 3], [3, 0], // front
      [4, 5], [5, 6], [6, 7], [7, 4], // back
      [0, 4], [1, 5], [2, 6], [3, 7], // connecting edges
    ];

    final projected = <Offset>[];
    for (final v in vertices) {
      final rotated = _rotate3D(v[0], v[1], v[2], rotX, rotY, rotZ);
      final z = rotated[2] + 250;
      final k = fov / (fov + z);
      projected.add(Offset(center.dx + rotated[0] * k, center.dy + rotated[1] * k));
    }

    final paint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    for (final edge in edges) {
      canvas.drawLine(projected[edge[0]], projected[edge[1]], paint);
    }

    final nodePaint = Paint()
      ..color = color.withValues(alpha: (alpha * 1.6).clamp(0.0, 1.0))
      ..style = PaintingStyle.fill;

    for (final pt in projected) {
      canvas.drawCircle(pt, 2.6, nodePaint);
    }
  }

  /// Draw a rotating 3D Hexagonal Prism
  void _drawRotating3DHexPrism({
    required Canvas canvas,
    required Offset center,
    required double radius3D,
    required double height3D,
    required double rotX,
    required double rotY,
    required double rotZ,
    required Color color,
    required double alpha,
  }) {
    const sides = 6;
    final halfH = height3D / 2;
    final vertices = <List<double>>[];

    // Bottom cap
    for (int i = 0; i < sides; i++) {
      final angle = (i / sides) * 2 * math.pi;
      vertices.add([math.cos(angle) * radius3D, -halfH, math.sin(angle) * radius3D]);
    }
    // Top cap
    for (int i = 0; i < sides; i++) {
      final angle = (i / sides) * 2 * math.pi;
      vertices.add([math.cos(angle) * radius3D, halfH, math.sin(angle) * radius3D]);
    }

    final projected = <Offset>[];
    for (final v in vertices) {
      final rotated = _rotate3D(v[0], v[1], v[2], rotX, rotY, rotZ);
      final z = rotated[2] + 250;
      final k = fov / (fov + z);
      projected.add(Offset(center.dx + rotated[0] * k, center.dy + rotated[1] * k));
    }

    final paint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    // Connect top and bottom hexagons & vertical pillars
    for (int i = 0; i < sides; i++) {
      final next = (i + 1) % sides;
      canvas.drawLine(projected[i], projected[next], paint);
      canvas.drawLine(projected[i + sides], projected[next + sides], paint);
      canvas.drawLine(projected[i], projected[i + sides], paint);
    }
  }

  /// Draw a rotating 3D Octahedron (Diamond)
  void _drawRotating3DOctahedron({
    required Canvas canvas,
    required Offset center,
    required double size3D,
    required double rotX,
    required double rotY,
    required double rotZ,
    required Color color,
    required double alpha,
  }) {
    final s = size3D;
    final vertices = [
      [0.0, -s, 0.0],
      [0.0, s, 0.0],
      [-s * 0.72, 0.0, 0.0],
      [s * 0.72, 0.0, 0.0],
      [0.0, 0.0, -s * 0.72],
      [0.0, 0.0, s * 0.72],
    ];

    final edges = [
      [0, 2], [0, 3], [0, 4], [0, 5],
      [1, 2], [1, 3], [1, 4], [1, 5],
      [2, 4], [4, 3], [3, 5], [5, 2],
    ];

    final projected = <Offset>[];
    for (final v in vertices) {
      final rotated = _rotate3D(v[0], v[1], v[2], rotX, rotY, rotZ);
      final z = rotated[2] + 250;
      final k = fov / (fov + z);
      projected.add(Offset(center.dx + rotated[0] * k, center.dy + rotated[1] * k));
    }

    final paint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;

    for (final edge in edges) {
      canvas.drawLine(projected[edge[0]], projected[edge[1]], paint);
    }
  }

  /// Draw rotating dual concentric 3D Wireframe Rings
  void _drawRotating3DDualRings({
    required Canvas canvas,
    required Offset center,
    required double radiusOuter,
    required double radiusInner,
    required double rotX,
    required double rotY,
    required Color color,
    required double alpha,
  }) {
    const segments = 18;
    final projectedOuter = <Offset>[];
    final projectedInner = <Offset>[];

    for (int i = 0; i < segments; i++) {
      final angle = (i / segments) * 2 * math.pi;

      // Outer ring
      final xo = math.cos(angle) * radiusOuter;
      final yo = math.sin(angle) * radiusOuter;
      final ro = _rotate3D(xo, yo, 0, rotX, rotY, 0);
      final ko = fov / (fov + ro[2] + 250);
      projectedOuter.add(Offset(center.dx + ro[0] * ko, center.dy + ro[1] * ko));

      // Inner ring (tilted counter-axis)
      final xi = math.cos(angle) * radiusInner;
      final yi = math.sin(angle) * radiusInner;
      final ri = _rotate3D(xi, yi, 0, -rotX * 0.9, rotY * 1.2, 0);
      final ki = fov / (fov + ri[2] + 250);
      projectedInner.add(Offset(center.dx + ri[0] * ki, center.dy + ri[1] * ki));
    }

    final paintOuter = Paint()
      ..color = color.withValues(alpha: alpha)
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;

    final paintInner = Paint()
      ..color = (isDark ? AppTheme.accentHeart : const Color(0xFF6366F1))
          .withValues(alpha: alpha * 0.85)
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;

    final pathOuter = Path()..moveTo(projectedOuter[0].dx, projectedOuter[0].dy);
    final pathInner = Path()..moveTo(projectedInner[0].dx, projectedInner[0].dy);

    for (int i = 1; i < segments; i++) {
      pathOuter.lineTo(projectedOuter[i].dx, projectedOuter[i].dy);
      pathInner.lineTo(projectedInner[i].dx, projectedInner[i].dy);
    }
    pathOuter.close();
    pathInner.close();

    canvas.drawPath(pathOuter, paintOuter);
    canvas.drawPath(pathInner, paintInner);
  }

  /// 3D Rotation Matrix Calculation
  List<double> _rotate3D(
    double x,
    double y,
    double z,
    double rotX,
    double rotY,
    double rotZ,
  ) {
    // Pitch (X-axis)
    final cosX = math.cos(rotX);
    final sinX = math.sin(rotX);
    final y1 = y * cosX - z * sinX;
    final z1 = y * sinX + z * cosX;

    // Yaw (Y-axis)
    final cosY = math.cos(rotY);
    final sinY = math.sin(rotY);
    final x2 = x * cosY + z1 * sinY;
    final z2 = -x * sinY + z1 * cosY;

    // Roll (Z-axis)
    final cosZ = math.cos(rotZ);
    final sinZ = math.sin(rotZ);
    final x3 = x2 * cosZ - y1 * sinZ;
    final y3 = x2 * sinZ + y1 * cosZ;

    return [x3, y3, z2];
  }

  @override
  bool shouldRepaint(covariant _Scene3DPainter oldDelegate) => true;
}
