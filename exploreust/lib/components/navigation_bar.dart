import 'package:clicky_flutter/clicky_flutter.dart';
import 'package:clicky_flutter/styles.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Theme.of(context).colorScheme.primary;
    final Color unselectedColor =
        Theme.of(context).iconTheme.color ?? Colors.grey;
    final Color navBarBg = Colors.white;
    final Duration animDuration = const Duration(milliseconds: 400);
    final Curve animCurve = Curves.elasticOut;

    List<IconData> icons = [
      Icons.home,
      Icons.map,
      Icons.person,
      Icons.event,
      Icons.apps,
    ];
    List<String> labels = ['Home', 'Map', 'Profile', 'Events', 'All'];

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: Container(
        color: navBarBg,
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ), // margin *inside* the bar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(icons.length, (index) {
              final bool isSelected = selectedIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onItemTapped(index),
                  child: Clicky(
                    style: ClickyStyle(
                      color: const Color(0xFFF9A825).withOpacity(0.1),
                      durationIn: Duration(milliseconds: 200),
                      durationOut: Duration(milliseconds: 800),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icons[index],
                          color: isSelected ? selectedColor : unselectedColor,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          labels[index],
                          style: TextStyle(
                            color: isSelected ? selectedColor : unselectedColor,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
