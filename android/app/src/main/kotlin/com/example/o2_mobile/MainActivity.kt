package com.example.o2_mobile

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.*
import io.flutter.plugins.GeneratedPluginRegistrant
import org.json.JSONObject
import java.lang.reflect.Method


class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        // Create channels
        val channel = BasicMessageChannel<String>(flutterView, "cross", StringCodec.INSTANCE)
        val backgroundChannel = BasicMessageChannel<Any>(flutterView, "backgroundService", JSONMessageCodec.INSTANCE)

        // Receive a message from Dart
        channel.setMessageHandler { m, reply ->
            Log.d("Sent from Dart", m)
            reply.reply("Reply from Kotlin")
        }

        // Receive a json from Dart
        backgroundChannel.setMessageHandler { any, _ ->
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                applicationContext.startForegroundService(Intent(this, AppService::class.java))
            else
                applicationContext.startService(Intent(this, AppService::class.java))
            val jsonFromString = JSONObject(any.toString())
            Log.d("Sent from Dart", jsonFromString.get("title").toString())
        }


    }
}
