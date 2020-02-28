class TimeAjuster {


  static String ajust(DateTime timestamp){
    Duration fullTime =
        DateTime.now().difference(timestamp);
        if (fullTime.inMinutes < 60) {
          return 'il y ${fullTime.inMinutes} mins';
        } else if (fullTime.inHours < 24) {
          return 'il y ${fullTime.inHours} hours';
        } else if (fullTime.inHours >= 24 && fullTime.inDays < 7) {
          return 'il y ${fullTime.inDays} jour';
        } else if (fullTime.inDays >= 7 && fullTime.inDays < 30) {
          return 'il y ${(fullTime.inDays / 7).floor()} semaine';
        } else if (fullTime.inDays >= 30) {
          return 'il y ${(fullTime.inDays / 30).floor()} mois';
        }
  }
}