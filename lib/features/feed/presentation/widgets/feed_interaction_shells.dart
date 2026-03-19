import 'package:flutter/material.dart';

import '../../domain/feed_item.dart';
import 'feed_social_count.dart';

Future<void> showFeedCommentsSheet(BuildContext context, FeedItem item) {
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    builder: (context) => FeedCommentsSheet(item: item),
  );
}

Future<void> showFeedShareSheet(BuildContext context, FeedItem item) {
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    builder: (context) => FeedShareSheet(item: item),
  );
}

Future<void> showFeedMusicSheet(BuildContext context, FeedItem item) {
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    builder: (context) => FeedMusicSheet(item: item),
  );
}

class FeedProfilePage extends StatelessWidget {
  const FeedProfilePage({required this.item, super.key});

  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text('@${item.authorUsername}'),
        centerTitle: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _InteractionPrototypeBanner(
                label: 'Creator profile shell',
                description:
                    'Profile navigation is wired, but follow, tabs, and feed data are intentionally unimplemented.',
                dark: true,
              ),
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0x26FFFFFF)),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      item.authorAvatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(colors: item.sceneColors),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  item.authorDisplayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  '@${item.authorUsername}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.66),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ProfileMetric(
                    value: formatSocialCount(item.likeCount),
                    label: 'Likes',
                  ),
                  const SizedBox(width: 24),
                  _ProfileMetric(
                    value: formatSocialCount(item.commentCount),
                    label: 'Comments',
                  ),
                  const SizedBox(width: 24),
                  _ProfileMetric(
                    value: formatSocialCount(item.shareCount),
                    label: 'Shares',
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: null,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF2D55),
                        disabledBackgroundColor: const Color(0x4DFF2D55),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Follow'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: null,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Message'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const _SectionLabel('Pinned videos'),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white.withValues(alpha: 0.18),
                            size: 34,
                          ),
                        ),
                        if (index == 0)
                          Positioned(
                            left: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.38),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'UI shell',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedCommentsSheet extends StatelessWidget {
  const FeedCommentsSheet({required this.item, super.key});

  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    return _FeedSheetFrame(
      heightFactor: 0.74,
      child: Column(
        children: [
          _SheetHeader(
            title: '${formatSocialCount(item.commentCount)} comments',
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: _InteractionPrototypeBanner(
              label: 'Comments shell',
              description:
                  'The sheet, list, and composer are in place. Loading and posting comments are not implemented.',
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              itemCount: 6,
              separatorBuilder: (_, _) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                return _CommentRow(item: item, index: index);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFF0F0F0),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 18,
                    color: Colors.black.withValues(alpha: 0.42),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Add comment...',
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.38),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.alternate_email_rounded, size: 20),
                const SizedBox(width: 12),
                const Icon(Icons.sentiment_satisfied_alt_rounded, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FeedShareSheet extends StatelessWidget {
  const FeedShareSheet({required this.item, super.key});

  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SheetHeader(title: 'Send to'),
                const _InteractionPrototypeBanner(
                  label: 'Share shell',
                  description:
                      'Routing is wired, but real destinations and share intents are intentionally unimplemented.',
                ),
                const SizedBox(height: 16),
                _SharePreviewCard(item: item),
                const SizedBox(height: 18),
                const Text(
                  'Suggestions',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 102,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      _ShareDestination(
                        label: 'Repost',
                        icon: Icons.repeat_rounded,
                      ),
                      _ShareDestination(
                        label: 'Story',
                        icon: Icons.auto_stories_rounded,
                      ),
                      _ShareDestination(
                        label: 'Copy link',
                        icon: Icons.link_rounded,
                      ),
                      _ShareDestination(
                        label: 'Messages',
                        icon: Icons.mail_outline_rounded,
                      ),
                      _ShareDestination(
                        label: 'Instagram',
                        icon: Icons.photo_camera_back_outlined,
                      ),
                      _ShareDestination(
                        label: 'Direct',
                        icon: Icons.near_me_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.download_rounded),
                        label: const Text('Save video'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.send_rounded),
                        label: const Text('Send now'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeedMusicSheet extends StatelessWidget {
  const FeedMusicSheet({required this.item, super.key});

  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    return _FeedSheetFrame(
      heightFactor: 0.74,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SheetHeader(title: 'Original track'),
            const _InteractionPrototypeBanner(
              label: 'Sound shell',
              description:
                  'The sound entry surface is in place, but track playback and actions are not implemented in this assignment build.',
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: SizedBox(
                    width: 84,
                    height: 84,
                    child: Image.network(
                      item.trackCoverImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(colors: item.sceneColors),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.trackTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.trackArtist,
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.52),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _MetricChip(
                            icon: Icons.favorite_rounded,
                            label: formatSocialCount(item.likeCount),
                          ),
                          _MetricChip(
                            icon: Icons.play_arrow_rounded,
                            label: formatSocialCount(
                              item.shareCount + item.commentCount,
                            ),
                          ),
                          _MetricChip(
                            icon: Icons.bookmark_rounded,
                            label: formatSocialCount(item.bookmarkCount),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.playlist_add_rounded),
                    label: const Text('Add to playlist'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.music_note_rounded),
                    label: const Text('Use sound'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                'This sheet is wired to the rotating disc interaction. Actual sound previews, save state, and sound-detail navigation remain unimplemented.',
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.68),
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedSheetFrame extends StatelessWidget {
  const _FeedSheetFrame({required this.child, this.heightFactor});

  final Widget child;
  final double? heightFactor;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final resolvedHeightFactor = heightFactor ?? 0.74;

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: height * resolvedHeightFactor,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InteractionPrototypeBanner extends StatelessWidget {
  const _InteractionPrototypeBanner({
    required this.label,
    required this.description,
    this.dark = false,
  });

  final String label;
  final String description;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final background = dark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFF4F4F4);
    final border = dark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    final foreground = dark ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.construction_rounded,
            size: 18,
            color: foreground.withValues(alpha: 0.72),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: foreground.withValues(alpha: 0.64),
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.58),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _CommentRow extends StatelessWidget {
  const _CommentRow({required this.item, required this.index});

  final FeedItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final name = switch (index) {
      0 => 'mika.story',
      1 => 'alexgoesout',
      2 => 'toktok_daily',
      3 => 'hannah.archive',
      4 => 'frame.by.frame',
      _ => item.authorUsername,
    };
    final message = switch (index) {
      0 => 'This interaction shell looks right. Waiting for real comments now.',
      1 => 'Love the bottom sheet structure, especially the composer area.',
      2 => 'The prototype tag makes the state clear without breaking the flow.',
      3 => 'Would keep this white-sheet treatment. It matches TikTok closely.',
      4 =>
        'Nice. Real data can slot into this later without changing the layout.',
      _ =>
        'Creator reply preview only. Backend and posting are intentionally missing.',
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Color.lerp(
            item.sceneColors.firstOrNull ?? Colors.black,
            item.sceneColors.lastOrNull ?? Colors.grey,
            0.5,
          ),
          child: Text(
            name.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.44),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(index + 1) * 3}m',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.28),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(message, style: const TextStyle(fontSize: 14, height: 1.35)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Reply',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.44),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'View activity',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.44),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 18,
              color: Colors.black.withValues(alpha: 0.34),
            ),
            const SizedBox(height: 4),
            Text(
              '${(index + 1) * 7}',
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.34),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SharePreviewCard extends StatelessWidget {
  const _SharePreviewCard({required this.item});

  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 56,
              height: 72,
              child: Image.asset(
                item.videoThumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: item.sceneColors),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${item.authorUsername}',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.52),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.68),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareDestination extends StatelessWidget {
  const _ShareDestination({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
