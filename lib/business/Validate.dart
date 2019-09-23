class Validate {
  static isDouble(String input) {
    try {
      return double.parse(input);
    } catch (err) {
      return false;
    }
  }

  static isDoubleAndToString(String input) {
    try {
      return double.parse(input).toStringAsFixed(0);
    } catch (err) {
      return false;
    }
  }
}
