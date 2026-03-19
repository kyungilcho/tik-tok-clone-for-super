String formatSocialCount(int count) {
  if (count >= 1000000) {
    final value = count / 1000000;
    return '${_trimCompactDecimals(value)}M';
  }

  if (count >= 1000) {
    final value = count / 1000;
    return '${_trimCompactDecimals(value)}K';
  }

  return '$count';
}

String _trimCompactDecimals(double value) {
  final decimals = value >= 100 ? 0 : 1;
  final formatted = value.toStringAsFixed(decimals);
  return formatted.endsWith('.0')
      ? formatted.substring(0, formatted.length - 2)
      : formatted;
}
