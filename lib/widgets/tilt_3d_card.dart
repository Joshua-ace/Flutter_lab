import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A premium 3D Card wrapper that reacts to touch drag or mouse hover
/// with perspective tilt, dynamic depth shadows, specular glare reflection,
/// and smooth spring-back physics.
class Tilt3DCard extends StatefulWidget {
  final Widget child;
  final double maxTiltAngle; // Radians, default ~0.2 (approx 11 degrees)
  final double perspective; // Matrix4 perspective entry (3,2)
  final double elevation; // Depth scale
  final double borderRadius;
  final bool enableGlare;
  final bool enableScale;
  final VoidCallback? onTap;

  const Tilt3DCard({
    super.key,
    required this.child,
    this.maxTiltAngle = 0.22,
    this.perspective = 0.0016,
    this.elevation = 12.0,
    this.borderRadius = 20.0,
    this.enableGlare = true,
    this.enableScale = true,
    this.onTap,
  });

  @override
  State<Tilt3DCard> createState() => _Tilt3DCardState();
}

class _Tilt3DCardState extends State<Tilt3DCard> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _tiltXAnim;
  late Animation<double> _tiltYAnim;
  late Animation<double> _scaleAnim;

  double _currentX = 0.0;
  double _currentY = 0.0;
  double _scale = 1.0;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _tiltXAnim = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _tiltYAnim = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.addListener(() {
      setState(() {
        _currentX = _tiltXAnim.value;
        _currentY = _tiltYAnim.value;
        _scale = _scaleAnim.value;
      });
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleHover(PointerHoverEvent event, Size size) {
    if (size.width == 0 || size.height == 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final normX = ((event.localPosition.dx - center.dx) / (size.width / 2)).clamp(-1.0, 1.0);
    final normY = ((event.localPosition.dy - center.dy) / (size.height / 2)).clamp(-1.0, 1.0);

    setState(() {
      _isHovered = true;
      _currentX = normX;
      _currentY = normY;
      _scale = widget.enableScale ? 1.03 : 1.0;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details, Size size) {
    if (size.width == 0 || size.height == 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final normX = ((details.localPosition.dx - center.dx) / (size.width / 2)).clamp(-1.0, 1.0);
    final normY = ((details.localPosition.dy - center.dy) / (size.height / 2)).clamp(-1.0, 1.0);

    setState(() {
      _isHovered = true;
      _currentX = normX;
      _currentY = normY;
      _scale = widget.enableScale ? 1.03 : 1.0;
    });
  }

  void _resetTilt() {
    _tiltXAnim = Tween<double>(begin: _currentX, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _tiltYAnim = Tween<double>(begin: _currentY, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _scaleAnim = Tween<double>(begin: _scale, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.reset();
    _animController.forward();

    setState(() {
      _isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardSize = Size(
          constraints.maxWidth.isFinite ? constraints.maxWidth : 300,
          constraints.maxHeight.isFinite ? constraints.maxHeight : 200,
        );

        // Calculate 3D Matrix
        // Rotate X around horizontal axis (tilted by vertical offset Y)
        // Rotate Y around vertical axis (tilted by horizontal offset X)
        final matrix = Matrix4.identity()
          ..setEntry(3, 2, widget.perspective)
          ..rotateX(-_currentY * widget.maxTiltAngle)
          ..rotateY(_currentX * widget.maxTiltAngle);

        // 3D Shadow offset (moves opposite to tilt direction)
        final shadowOffsetX = -_currentX * widget.elevation * 0.8;
        final shadowOffsetY = -_currentY * widget.elevation * 0.8 + (_isHovered ? 8.0 : 4.0);
        final shadowBlur = _isHovered ? widget.elevation * 1.8 : widget.elevation;

        return MouseRegion(
          onHover: (e) => _handleHover(e, cardSize),
          onExit: (_) => _resetTilt(),
          child: GestureDetector(
            onTap: widget.onTap,
            onPanUpdate: (d) => _handlePanUpdate(d, cardSize),
            onPanEnd: (_) => _resetTilt(),
            onPanCancel: () => _resetTilt(),
            child: Transform(
              alignment: FractionalOffset.center,
              transform: matrix,
              child: Transform.scale(
                scale: _scale,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: _isHovered ? 0.22 : 0.08),
                        blurRadius: shadowBlur,
                        offset: Offset(shadowOffsetX, shadowOffsetY),
                      ),
                      if (_isHovered)
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.18),
                          blurRadius: shadowBlur * 1.4,
                          offset: Offset(shadowOffsetX * 0.5, shadowOffsetY * 0.5),
                        ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: Stack(
                      children: [
                        widget.child,

                        // Specular Glare / Light Reflection Overlay
                        if (widget.enableGlare && _isHovered)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(widget.borderRadius),
                                  gradient: LinearGradient(
                                    begin: Alignment(_currentX * 1.5 - 0.5, _currentY * 1.5 - 0.5),
                                    end: Alignment(-_currentX * 1.5 + 0.5, -_currentY * 1.5 + 0.5),
                                    colors: [
                                      Colors.white.withValues(alpha: 0.25),
                                      Colors.white.withValues(alpha: 0.05),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.45, 1.0],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
