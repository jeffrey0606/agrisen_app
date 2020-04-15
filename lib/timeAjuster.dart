class TimeAjuster {


  static String ajust(DateTime timestamp){
    Duration fullTime =
        DateTime.now().difference(timestamp);
        if (fullTime.inMinutes < 60) {
          return 'since ${fullTime.inMinutes} mins';
        } else if (fullTime.inHours < 24) {
          return 'since ${fullTime.inHours} hours';
        } else if (fullTime.inHours >= 24 && fullTime.inDays < 7) {
          return 'since ${fullTime.inDays} days';
        } else if (fullTime.inDays >= 7 && fullTime.inDays < 30) {
          return 'since ${(fullTime.inDays / 7).floor()} weeks';
        } else if (fullTime.inDays >= 30) {
          return 'since ${(fullTime.inDays / 30).floor()} months';
        }
  }
}