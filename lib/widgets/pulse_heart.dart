import 'package:flutter/material.dart';

class PulseHeartButton extends StatefulWidget {
  final VoidCallback? onTap;
  final int count;
  final String label;

  const PulseHeartButton({
    super.key,
    this.onTap,
    this.count = 0,
    this.label = 'Cheer',
  });

  @override
  State<PulseHeartButton> createState() => _PulseHeartButtonState();
}

class _PulseHeartButtonState extends State<PulseHeartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: ElevatedButton.icon(
          onPressed: () {
            _controller.forward(from: 0.0).then((_) => _controller.repeat(reverse: true));
            widget.onTap?.call();
          },
          icon: const Text('❤️', style: TextStyle(fontSize: 18)),
          label: Text(
            '${widget.label} (${widget.count})',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE91E63),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
          ),
        ),
      ),
    );
  }
}
