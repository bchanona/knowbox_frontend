import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildItem(context, icon: Icons.home_filled, index: 0),
          _buildItem(context, icon: Icons.collections_bookmark, index: 1),
          _buildItem(context, icon: Icons.person, index: 2),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, {required IconData icon, required int index}) {
    final theme = Theme.of(context);
    final isSelected = currentIndex == index;

    return IconButton(
      icon: Icon(
        icon,
        size: 30,
        color: isSelected ? theme.colorScheme.primary : Colors.black87,
      ),
      onPressed: () => onTap(index),
    );
  }
}