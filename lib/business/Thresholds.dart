class Thresholds {
  static final String verybad = 'Very bad';
  static final String bad = 'Bad';
  static final String medium = 'Medium';
  static final String normal = 'Normal';
  static final String good = 'Good';
  static final String verygood = 'Very Good';

  static final String safe = 'Safe';
  static final String extreme = 'Extreme';

  static final String verycool = 'Very cool';
  static final String cool = 'Cool';
  static final String hot = 'Hot';
  static final String veryhot = 'Very hot';

  static final String low = "Low";
  static final String verylow = "Very low";
  static final String high = "High";
  static final String veryhight = 'Very high';

  static String aqi(double value) {
    String message = '';

    if (value >= 0 && value < 75) message = Thresholds.verygood;
    if (value >= 75 && value < 150) message = Thresholds.good;
    if (value >= 150 && value < 300) message = Thresholds.normal;
    if (value >= 300 && value < 1050) message = Thresholds.medium;
    if (value >= 1050 && value < 3000) message = Thresholds.bad;
    if (value >= 3000) message = Thresholds.extreme;

    return message;
  }

  static String uv(double value) {
    String message = '';

    if (value >= 0 && value < 50) message = Thresholds.safe;
    if (value >= 50 && value < 125) message = Thresholds.medium;
    if (value >= 125 && value < 175) message = Thresholds.high;
    if (value >= 175 && value < 250) message = Thresholds.veryhight;
    if (value >= 250) message = Thresholds.extreme;

    return message;
  }

  static String temp(double value) {
    String message = '';

    if (value < 0) message = Thresholds.extreme;
    if (value >= 0 && value < 10) message = Thresholds.verylow;
    if (value >= 10 && value < 20) message = Thresholds.low;
    if (value >= 20 && value < 25) message = Thresholds.normal;
    if (value >= 25 && value < 30) message = Thresholds.high;
    if (value >= 30 && value < 40) message = Thresholds.veryhight;
    if (value >= 40) message = Thresholds.extreme;

    return message;
  }

  static String co(double value) {
    String message = '';

    if (value >= 0 && value < 3) message = Thresholds.safe;
    if (value >= 3 && value < 7) message = Thresholds.normal;
    if (value >= 7 && value < 15) message = Thresholds.medium;
    if (value >= 15 && value < 30) message = Thresholds.high;
    if (value >= 30 && value < 62) message = Thresholds.veryhight;
    if (value >= 62) message = Thresholds.extreme;

    return message;
  }
}
