import 'package:flutter/material.dart';

/// Gently floats its [child] up and down — the subtle hover used on the logo in
/// the welcome and "finding driver" screens.
class Bobbing extends StatefulWidget {
  const Bobbing({
    super.key,
    required this.child,
    this.distance = 6,
    this.duration = const Duration(seconds: 4),
  });

  final Widget child;
  final double distance;
  final Duration duration;

  @override
  State<Bobbing> createState() => _BobbingState();
}

class _BobbingState extends State<Bobbing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration)
        ..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, -widget.distance * animation.value),
        child: child,
      ),
      child: widget.child,
    );
  }
}
