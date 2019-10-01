package com.example.o2_mobile

import android.os.Bundle
import android.util.Log

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StringCodec
import io.flutter.plugins.GeneratedPluginRegistrant
import java.lang.reflect.Method


class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    // Create a channel
    val channel = BasicMessageChannel<String>(flutterView, "cross", StringCodec.INSTANCE)

    // Receive a message from Dart
    channel.setMessageHandler { m, reply ->
      Log.d("Sent from Dart", m)
      reply.reply("Reply from Kotlin")
    }

  }
}
