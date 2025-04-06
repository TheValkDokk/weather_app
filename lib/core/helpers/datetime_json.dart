DateTime dateFromJson(int epoch) {
  return DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
}

int dateToJson(DateTime date) {
  return date.millisecondsSinceEpoch ~/ 1000;
}
