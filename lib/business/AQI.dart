class AQI {
  double cal(double dust, double co, double smoke, double uv) {
    return (dust / 1.66) * 0.9 +
        ((co + smoke) / 2) * 4.84 * 0.05 +
        uv * 1.2 * 0.05;
  }
}

final aqi = AQI();
