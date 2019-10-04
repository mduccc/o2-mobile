package com.example.o2_mobile

import android.app.ActivityManager
import android.content.Context
import android.util.Log

class ServiceRunning {
    companion object {
        fun foregroundServiceIsRunning(): Boolean {
            var isRunning = false
            val activityManager = AppContext.context!!.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            for (service in activityManager.getRunningServices(Int.MAX_VALUE)) {
                if (service.service.className == AppService::class.java.name)
                    isRunning = true
            }

            if (isRunning)
                Log.d("Foreground Service", "Running")
            else
                Log.d("Foreground Service", "Stopped")

            return isRunning
        }
    }
}