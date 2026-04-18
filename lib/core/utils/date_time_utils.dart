import 'package:intl/intl.dart';

String getRelativeDateAndTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}d ago';
  } else if (difference.inDays < 30) {
    return '${difference.inDays ~/ 7}w ago';
  } else if (difference.inDays < 365) {
    return '${difference.inDays ~/ 30}mo ago';
  } else {
    return '${difference.inDays ~/ 365}y ago';
  }
}

String getAbsoluteDateAndTime(DateTime dateTime) {
  return DateFormat('MMM d, h:mm a').format(dateTime);
}

String getFormattedHistoryTimestamp(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} mins ago';
  } else if (difference.inHours < 24 && dateTime.day == now.day) {
    return '${difference.inHours} hours ago';
  }

  // Check if it was yesterday
  final yesterday = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
  final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
  if (date == yesterday) {
    return 'Yesterday';
  }

  if (difference.inDays <= 3) {
    return '${difference.inDays} days ago';
  }

  return DateFormat('MMM d, yyyy').format(dateTime);
}
