import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AppShellBranch {
  home('Home', CupertinoIcons.house_fill),
  friends('Friends', CupertinoIcons.person_2),
  create('Create', CupertinoIcons.add),
  inbox('Inbox', CupertinoIcons.tray),
  profile('Profile', CupertinoIcons.person_crop_circle);

  const AppShellBranch(this.label, this.icon);

  final String label;
  final IconData icon;
}

class AppShellBottomNavigationBar extends StatelessWidget {
  const AppShellBottomNavigationBar({
    required this.currentBranch,
    required this.bottomInset,
    required this.onSelectBranch,
    super.key,
  });

  static const double baseHeight = 52;

  final AppShellBranch currentBranch;
  final double bottomInset;
  final ValueChanged<AppShellBranch> onSelectBranch;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: bottomInset + baseHeight,
      padding: EdgeInsets.only(bottom: bottomInset),
      color: const Color(0xC2000000),
      child: Row(
        children: [
          Expanded(
            child: _BottomNavItem(
              branch: AppShellBranch.home,
              selected: currentBranch == AppShellBranch.home,
              onTap: onSelectBranch,
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              branch: AppShellBranch.friends,
              selected: currentBranch == AppShellBranch.friends,
              onTap: onSelectBranch,
            ),
          ),
          Expanded(
            child: Center(
              child: _CreateButton(
                selected: currentBranch == AppShellBranch.create,
                onTap: () => onSelectBranch(AppShellBranch.create),
              ),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              branch: AppShellBranch.inbox,
              selected: currentBranch == AppShellBranch.inbox,
              onTap: onSelectBranch,
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              branch: AppShellBranch.profile,
              selected: currentBranch == AppShellBranch.profile,
              onTap: onSelectBranch,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.branch,
    required this.selected,
    required this.onTap,
  });

  final AppShellBranch branch;
  final bool selected;
  final ValueChanged<AppShellBranch> onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : const Color(0xC7FFFFFF);

    return InkWell(
      onTap: () => onTap(branch),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(branch.icon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(
              branch.label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 52,
        height: 32,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 4,
              child: Container(
                width: 18,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF27D9F8),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Positioned(
              right: 4,
              child: Container(
                width: 18,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF2D55),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Container(
              width: 40,
              height: 26,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  BoxShadow(
                    color: selected
                        ? const Color(0x66FFFFFF)
                        : const Color(0x47000000),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.add, color: Color(0xFF161616), size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
