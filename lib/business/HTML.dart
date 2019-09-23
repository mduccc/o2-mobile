import 'package:html_unescape/html_unescape.dart';

class HTML {
  static var _unescape = new HtmlUnescape();
  static String decode(String input) {
    return HTML._unescape.convert(input);
  }
}
