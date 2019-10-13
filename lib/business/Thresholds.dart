class Thresholds {
  static final String verybad = 'Rất tệ';
  static final String bad = 'Tệ';
  static final String normal = 'Bình thường';
  static final String medium = 'Trung bình';
  static final String good = 'Tuyệt';
  static final String verygood = 'Rất tuyệt';

  static final String safe = 'An toàn';
  static final String extreme = 'Cực nguy hiểm';

  static final String verycool = 'Rất lạnh';
  static final String cool = 'Lạnh';
  static final String hot = 'Nóng';
  static final String veryhot = 'Rất nóng';

  static final String low = "Thấp";
  static final String verylow = "Rất thấp";
  static final String high = "Cao";
  static final String veryhight = 'Rất cao';

  static String aqi(double value) {
    String message = '';

    if (value >= 0 && value < 51) message = Thresholds.verygood;
    if (value >= 51 && value < 101) message = Thresholds.normal;
    if (value >= 101 && value < 151) message = Thresholds.medium;
    if (value >= 151 && value < 201) message = Thresholds.bad;
    if (value >= 201 && value < 301) message = Thresholds.verybad;
    if (value >= 301) message = Thresholds.extreme;

    return message;
  }

  static String uv(double value) {
    String message = '';

    if (value >= 0 && value < 2) message = Thresholds.safe;
    if (value >= 2 && value < 4) message = Thresholds.medium;
    if (value >= 4 && value < 7) message = Thresholds.high;
    if (value >= 7 && value < 10) message = Thresholds.veryhight;
    if (value >= 10) message = Thresholds.extreme;

    return message;
  }

  static String temp(double value) {
    String message = '';

    if (value < 0) message = Thresholds.extreme;
    if (value >= 0 && value < 10) message = Thresholds.verylow;
    if (value >= 10 && value < 20) message = Thresholds.low;
    if (value >= 20 && value < 25) message = Thresholds.normal;
    if (value >= 25 && value < 35) message = Thresholds.high;
    if (value >= 35 && value < 40) message = Thresholds.veryhight;
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
