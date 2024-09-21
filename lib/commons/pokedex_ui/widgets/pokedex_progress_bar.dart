import 'package:flutter/material.dart';

class PokedexProgressBar extends StatefulWidget {
  final double value;
  final Color color;
  final double size;

  const PokedexProgressBar({
    Key? key,
    required this.value,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  State<PokedexProgressBar> createState() => _PokedexProgressBarState();
}

class _PokedexProgressBarState extends State<PokedexProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double _progressValue = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.value).animate(_controller)
      ..addListener(() {
        setState(() {
          _progressValue = _animation.value;
        });
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: SizedBox(
        height: widget.size,
        child: LinearProgressIndicator(
          color: widget.color,
          backgroundColor: widget.color.withOpacity(0.3),
          value: _progressValue,
        ),
      ),
    );
  }
}
