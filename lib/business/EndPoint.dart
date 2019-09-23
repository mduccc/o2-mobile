class EndPoint {
  static String domain = 'http://45.77.102.151:5000';
  static String _ver = '/v1.1';
  static String login = domain + _ver + '/login';
  static String airData = domain + _ver + '/data/get';
  static String airDataCurrent = domain + _ver + '/data/get/current';
  static String accinfo = domain + _ver + '/data/get/info';
}
