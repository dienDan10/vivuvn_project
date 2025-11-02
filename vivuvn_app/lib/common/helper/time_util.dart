class TimeUtil {
  static String secondToTimeText(final int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    } else if (seconds < 3600) {
      // Less than 1 hour
      return '${(seconds / 60).ceil()}p';
    } else if (seconds < 86400) {
      // Less than 1 day
      final hours = (seconds / 3600).floor();
      final minutes = ((seconds % 3600) / 60).ceil();
      if (minutes > 0) {
        return '${hours}h ${minutes}p';
      }
      return '${hours}h';
    } else {
      // 1 day or more
      final days = (seconds / 86400).floor();
      final hours = ((seconds % 86400) / 3600).floor();
      if (hours > 0) {
        return '${days}d ${hours}h';
      }
      return '${days}d';
    }
  }
}
