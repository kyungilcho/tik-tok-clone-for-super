import 'package:flutter/material.dart';

import '../../../home/presentation/screens/home_screen.dart';
import '../../../shared/presentation/widgets/feature_placeholder.dart';
import '../widgets/app_shell_bottom_navigation_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppShellBranch _currentBranch = AppShellBranch.home;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bottomNavigationHeight =
        AppShellBottomNavigationBar.baseHeight + bottomInset;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: AppShellBranch.values.indexOf(_currentBranch),
        children: [
          HomeScreen(
            bottomNavigationHeight: bottomNavigationHeight,
            isActiveBranch: _currentBranch == AppShellBranch.home,
          ),
          FeaturePlaceholder(
            title: 'Friends',
            bottomPadding: bottomNavigationHeight,
          ),
          FeaturePlaceholder(
            title: 'Create',
            bottomPadding: bottomNavigationHeight,
          ),
          FeaturePlaceholder(
            title: 'Inbox',
            bottomPadding: bottomNavigationHeight,
          ),
          FeaturePlaceholder(
            title: 'Profile',
            bottomPadding: bottomNavigationHeight,
          ),
        ],
      ),
      bottomNavigationBar: AppShellBottomNavigationBar(
        currentBranch: _currentBranch,
        bottomInset: bottomInset,
        onSelectBranch: (branch) {
          setState(() {
            _currentBranch = branch;
          });
        },
      ),
    );
  }
}
