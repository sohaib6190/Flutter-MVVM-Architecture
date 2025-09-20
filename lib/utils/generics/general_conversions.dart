part of 'generics.dart';

String translate(BuildContext context, String key) {
  return Localization.of(context)?.translate(key) ?? "Undefined translation";
}

String formattedDateDMY(DateTime dateTime) {
  String twoDigitString(int value) => value.toString().padLeft(2, '0');

  return '${twoDigitString(dateTime.day)}-${twoDigitString(dateTime.month)}-${dateTime.year}';
}

String formatDay(String durationString) {
  RegExp regex = RegExp(r'(\d+)d');
  Iterable<Match> matches = regex.allMatches(durationString);

  if (matches.isNotEmpty) {
    int days = int.parse(matches.elementAt(0).group(1)!);
    return days.toStringAsFixed(0);
  } else {
    return '0';
  }
}

String formatDate(String dateString) {
  DateTime parsedDate = DateTime.parse(dateString);
  return '${parsedDate.year}/${parsedDate.month}/${parsedDate.day}';
}

String getDaysLeft(DateTime date, {String? text}) {
  DateTime now = DateTime.now();
  int daysLeft = date.difference(now).inDays;

  if (daysLeft < 0) {
    return "";
  } else if (daysLeft == 0) {
    return "Deadline today";
  } else {
    return "$daysLeft$text";
  }
}

double squareMetersToAcres(double squareMeters) {
  const double squareMetersPerAcre = 4046.85642;
  return squareMeters / squareMetersPerAcre;
}

double metersToFeet(double meters) {
  return meters * 3.28084;
}

String timeAgo(DateTime dateTime) {
  Duration difference = DateTime.now().difference(dateTime);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays < 30) {
    return '${(difference.inDays / 7).floor()} weeks ago';
  } else if (difference.inDays < 365) {
    return '${(difference.inDays / 30).floor()} months ago';
  } else {
    return '${(difference.inDays / 365).floor()} years ago';
  }
}