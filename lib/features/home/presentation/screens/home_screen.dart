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
                description:
                    'Explore tab placeholder. Discovery surfaces can be mounted here later.',
                topPadding: topOverlayHeight,
                bottomPadding: widget.bottomNavigationHeight,
              ),
              FeaturePlaceholder(
                title: 'Following',
                description:
                    'Following tab placeholder. Follow graph feed can be mounted here later.',
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
            top: topInset + 14,
            left: 18,
            right: 18,
            child: const _StatusPillRow(),
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

class _StatusPillRow extends StatelessWidget {
  const _StatusPillRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE43B4E),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            '14:00',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
      ],
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
