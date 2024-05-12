bool useCoinToCheckPost(int? price, int? coins) {
  if (price == null && coins == null) return false;
  var percent = price! * 0.5;
  if (coins! >= percent) {
    return true;
  }
  return false;
}