import 'package:flutter/material.dart';

class AddToCartAnimation {
  static GlobalKey cartKey = GlobalKey();

  static void run({
    required BuildContext context,
    required GlobalKey imageKey,
    required String imageUrl,
    VoidCallback? onFinish,
  }) {
    // 1. Get positions
    final RenderBox? imageBox =
        imageKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? cartBox =
        cartKey.currentContext?.findRenderObject() as RenderBox?;

    if (imageBox == null || cartBox == null) {
      onFinish?.call();
      return;
    }

    final Offset imagePosition = imageBox.localToGlobal(Offset.zero);
    final Offset cartPosition = cartBox.localToGlobal(Offset.zero);
    final Size imageSize = imageBox.size;

    // 2. Create Overlay Entry
    OverlayEntry? entry;
    entry = OverlayEntry(
      builder: (context) {
        return _FlyImageWidget(
          startPosition: imagePosition,
          endPosition: cartPosition,
          startSize: imageSize,
          imageUrl: imageUrl,
          onFinish: () {
            entry?.remove();
            onFinish?.call();
          },
        );
      },
    );

    Overlay.of(context).insert(entry);
  }
}

class _FlyImageWidget extends StatefulWidget {
  final Offset startPosition;
  final Offset endPosition;
  final Size startSize;
  final String imageUrl;
  final VoidCallback onFinish;

  const _FlyImageWidget({
    required this.startPosition,
    required this.endPosition,
    required this.startSize,
    required this.imageUrl,
    required this.onFinish,
  });

  @override
  State<_FlyImageWidget> createState() => _FlyImageWidgetState();
}

class _FlyImageWidgetState extends State<_FlyImageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _positionAnimation =
        Tween<Offset>(
          begin: widget.startPosition,
          end: widget.endPosition,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 1.0, curve: Curves.easeInOutBack),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeIn),
      ),
    );

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 80),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_controller);

    _controller.forward().then((_) => widget.onFinish());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _positionAnimation.value.dx,
          top: _positionAnimation.value.dy,
          width: widget.startSize.width,
          height: widget.startSize.height,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
