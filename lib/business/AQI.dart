class AQI {
  double cal(double y) {
    double aqi;
    y <= 36.455 ? aqi = 0 : aqi = ((y / 1024) - 0.0356) * 120000 * 0.035;
    return aqi;
  }
}

final aqi = AQI();
