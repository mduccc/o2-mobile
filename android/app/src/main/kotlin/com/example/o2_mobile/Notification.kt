package com.example.o2_mobile

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

class Notification {
    companion object {
        val foregroundNotificationId = 1
        val foregroundChannelId = "app_foreground_channel"
        val foregroundChannelName = "Foreground"
        val foregroundChannelDescription = "Foreground Channel"
        val foregroundChannelImportant = NotificationManager.IMPORTANCE_MIN
    }

    object Foreground {
        lateinit var foregroundChannel: NotificationChannel
        private lateinit var builder: NotificationCompat.Builder
        private lateinit var notificationManager: NotificationManager

        // First, create an register a channel
        private fun createForegroundChannel() {
            notificationManager =
                    AppContext.context!!.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                foregroundChannel = NotificationChannel(foregroundChannelId, foregroundChannelName, foregroundChannelImportant)
                foregroundChannel.description = foregroundChannelDescription
                foregroundChannel.setShowBadge(false)
                notificationManager.createNotificationChannel(foregroundChannel)
            }
        }

        // Second, create a notification with a channel via channel id
        fun builder(): Notification {
            createForegroundChannel()
            builder = NotificationCompat.Builder(AppContext.context!!, foregroundChannelId)
            builder.apply {
                setSmallIcon(R.drawable.ic_cloud_circle_black_24dp)
                setContentTitle("Air Monitor")
                setContentText("I'm working")
                setSmallIcon(R.drawable.ic_cloud_circle_black_24dp)
                setPriority(NotificationCompat.PRIORITY_MIN)
            }

            return builder.build()
        }
    }

}