package com.example.o2_mobile

import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log

class AppService : Service() {
    companion object {
        var token: String? = null
        var socket: Socket? = null
    }

    override fun onBind(p0: Intent?): IBinder? {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("Service", "onStartCommand")
        // get token
        intent?.getStringExtra("token")?.let {
            token = it
            Log.d("Token from Kotlin", token)
            // init socket
            if (socket == null)
                socket = Socket()

            // Connect to host with new Thread
            object : Thread() {
                override fun run() {
                    socket?.offEvent()
                    socket?.setupAndConnect()
                    socket?.event()
                    socket?.onNotify()
                    intent.getStringExtra("place_id")?.let {
                        Log.d("place_id from Kotlin", it)
                        socket?.onDataChanged(it)
                    }
                    join()
                }
            }.start()
        }
        return START_STICKY
    }

    override fun onCreate() {
        Log.d("Service", "onCreate")
        // init Context
        AppContext.context = applicationContext

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            startForeground(Notification.foregroundNotificationId, Notification.Foreground.builder())
        super.onCreate()
    }

    override fun onDestroy() {
        Log.d("Service", "onDestroy")
        // Disconnect event
        socket?.socket?.off()
        token = null
        super.onDestroy()
    }
}