package com.example.o2_mobile

import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log

class AppService: Service() {
    override fun onBind(p0: Intent?): IBinder? {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("Service", "onStartCommand")
        return START_STICKY
    }

    override fun onCreate() {
        Log.d("Service", "onCreate")
        // init Context
        AppContext.context = applicationContext

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            startForeground(Notification.foregroundNotificationId, Notification.Foreground.builder())
        super.onCreate()
    }

    override fun onDestroy() {
        Log.d("Service", "onDestroy")
        super.onDestroy()
    }
}