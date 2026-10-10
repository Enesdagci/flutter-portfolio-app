import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> goLink(String urlAdresi) async {
  final Uri uri = Uri.parse(urlAdresi);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Link açılamadı: $urlAdresi');
  }
}

/// Rounded card with an icon + title header, used for every content section.
class SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const SectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: scheme.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

/// Fades and slides its child in once, after an optional delay.
class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const FadeSlideIn({super.key, required this.child, this.delay = Duration.zero});

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  late final Animation<double> _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curve,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.06), end: Offset.zero).animate(_curve),
        child: widget.child,
      ),
    );
  }
}

/// Slightly lifts its child when the mouse hovers over it (web / desktop).
class HoverLift extends StatefulWidget {
  final Widget child;
  final double scale;

  const HoverLift({super.key, required this.child, this.scale = 1.08});

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? widget.scale : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
