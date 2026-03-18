import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../feed/presentation/screens/feed_screen.dart';
import '../../../shared/presentation/widgets/feature_placeholder.dart';

enum HomeTab {
  explore('Explore'),
  following('Following'),
  feed('For You');

  const HomeTab(this.label);

  final String label;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.bottomNavigationHeight,
    required this.isActiveBranch,
    super.key,
  });

  static const double chromeContentHeight = 88;

  final double bottomNavigationHeight;
  final bool isActiveBranch;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeTab _currentTab = HomeTab.feed;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final topOverlayHeight = topInset + HomeScreen.chromeContentHeight;

    return ColoredBox(
      color: const Color(0xFF070707),
      child: Stack(
        fit: StackFit.expand,
        children: [
          IndexedStack(
            index: HomeTab.values.indexOf(_currentTab),
            children: [
              FeaturePlaceholder(
                title: 'Explore',
                topPadding: topOverlayHeight,
                bottomPadding: widget.bottomNavigationHeight,
              ),
              FeaturePlaceholder(
                title: 'Following',
                topPadding: topOverlayHeight,
                bottomPadding: widget.bottomNavigationHeight,
              ),
              FeedScreen(
                topOverlayHeight: topOverlayHeight,
                bottomNavigationHeight: widget.bottomNavigationHeight,
                isActive: widget.isActiveBranch && _currentTab == HomeTab.feed,
              ),
            ],
          ),
          Positioned(
            top: topInset + 54,
            left: 0,
            right: 0,
            child: _HomeTabBar(
              currentTab: _currentTab,
              onSelectTab: (tab) {
                setState(() {
                  _currentTab = tab;
                });
              },
            ),
          ),
          Positioned(
            top: topInset + 52,
            right: 18,
            child: const Icon(
              CupertinoIcons.search,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeTabBar extends StatelessWidget {
  const _HomeTabBar({required this.currentTab, required this.onSelectTab});

  final HomeTab currentTab;
  final ValueChanged<HomeTab> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: HomeTab.values
            .map(
              (tab) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: GestureDetector(
                  onTap: () => onSelectTab(tab),
                  child: Text(
                    tab.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: currentTab == tab
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: currentTab == tab
                          ? Colors.white
                          : const Color(0xB8FFFFFF),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
