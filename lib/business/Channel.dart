import 'package:flutter/services.dart';

final channel = BasicMessageChannel<String>('cross', StringCodec());
final serviceBackgroudChannel =
    BasicMessageChannel<dynamic>('backgroundService', JSONMessageCodec());
