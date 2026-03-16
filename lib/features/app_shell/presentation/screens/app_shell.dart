import 'package:flutter/material.dart';

import '../../../feed/presentation/video/feed_video_controller.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../shared/presentation/widgets/feature_placeholder.dart';
import '../widgets/app_shell_bottom_navigation_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({this.feedVideoControllerFactory, super.key});

  final FeedVideoControllerFactory? feedVideoControllerFactory;

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
            feedVideoControllerFactory: widget.feedVideoControllerFactory,
          ),
          FeaturePlaceholder(
            title: 'Friends',
            description:
                'Friends branch placeholder. Social graph surfaces can be mounted here later.',
            bottomPadding: bottomNavigationHeight,
          ),
          FeaturePlaceholder(
            title: 'Create',
            description:
                'Create branch placeholder. Camera and creation flows can be mounted here later.',
            bottomPadding: bottomNavigationHeight,
          ),
          FeaturePlaceholder(
            title: 'Inbox',
            description:
                'Inbox branch placeholder. Notifications and direct messages can be mounted here later.',
            bottomPadding: bottomNavigationHeight,
          ),
          FeaturePlaceholder(
            title: 'Profile',
            description:
                'Profile branch placeholder. Account surfaces can be mounted here later.',
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
