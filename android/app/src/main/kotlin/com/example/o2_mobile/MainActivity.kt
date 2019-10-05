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

        // init Context
        AppContext.context = applicationContext

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

            when (jsonFromString.get("command").toString()) {
                "start_service" -> {
                    val args = JSONObject(jsonFromString.get("args").toString())
                    val token = args.getString("token")
                    val place_id = args.getString("place_id")
                    intent.putExtra("token", token)
                    intent.putExtra("place_id", place_id)

                    // Not for first open, each open app, check connection and connect
                    if (AppService.socket != null && AppService.socket!!.socket != null && !AppService.socket!!.socket!!.connected())
                        object : Thread() {
                            override fun run() {
                                AppService.socket?.setupAndConnect()
                                join()
                            }
                        }.start()

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        if (!ServiceRunning.foregroundServiceIsRunning())
                            applicationContext.startForegroundService(intent)
                    } else {
                        if (!ServiceRunning.foregroundServiceIsRunning())
                            applicationContext.startService(intent)
                    }
                }
                "stop_service" -> {
                    applicationContext.stopService(intent)
                }
            }
        }


    }
}
