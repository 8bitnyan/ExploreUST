import 'package:clicky_flutter/styles.dart';
import 'package:flutter/material.dart';
import 'package:clicky_flutter/clicky_flutter.dart';

class QuickAccess extends StatelessWidget {
  final Color? accentColor;
  const QuickAccess({super.key, this.accentColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              children: const [
                _QuickAccessButton(
                  icon: Icons.meeting_room,
                  label: 'Book Room',
                ),
                SizedBox(height: 8),
                _QuickAccessButton(icon: Icons.school, label: 'Canvas'),
                SizedBox(height: 8),
                _QuickAccessButton(icon: Icons.person, label: 'Advisor'),
                SizedBox(height: 8),
                _QuickAccessButton(icon: Icons.grade, label: 'Grades'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickAccessButton extends StatefulWidget {
  final IconData icon;
  final String label;
  const _QuickAccessButton({required this.icon, required this.label});

  @override
  State<_QuickAccessButton> createState() => _QuickAccessButtonState();
}

class _QuickAccessButtonState extends State<_QuickAccessButton> {
  bool _pressed = false;
  double _scale = 1.0;

  void _onTapDown(_) {
    setState(() {
      _scale = 1.08;
      _pressed = true;
    });
  }

  void _resetScale() {
    setState(() {
      _scale = 1.0;
      _pressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.secondary;
    return GestureDetector(
      onTap: () {
        _onTapDown(null);
        Future.delayed(const Duration(milliseconds: 120), _resetScale);
      },
      onTapDown: _onTapDown,
      onTapUp: (_) => _resetScale(),
      onTapCancel: _resetScale,
      child: Clicky(
        style: ClickyStyle(
          color: const Color(0xFFF9A825).withOpacity(0.1),
          durationIn: Duration(milliseconds: 200),
          durationOut: Duration(milliseconds: 800),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),

          child: Row(
            children: [
              Icon(widget.icon, size: 26),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
