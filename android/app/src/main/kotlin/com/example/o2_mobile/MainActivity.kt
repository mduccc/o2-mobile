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
            val jsonFromString = JSONObject(any.toString())
            Log.d("Sent from Dart", jsonFromString.get("command").toString())
            val intent = Intent(this, AppService::class.java)
            val args = JSONObject(jsonFromString.get("args").toString())
            val token = args.getString("token")
            val place_id = args.getString("place_id")
            intent.putExtra("token", token)
            intent.putExtra("place_id", place_id)

            when (jsonFromString.get("command").toString()) {
                "start_service" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                        applicationContext.startForegroundService(intent)
                    else
                        applicationContext.startService(intent)
                }
                "stop_service" -> {
                    applicationContext.stopService(intent)
                }
            }
        }


    }
}
