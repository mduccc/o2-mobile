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

        val qualityNotificationId = 2
        val fireNotificationId = 3
        val rainNotificationId = 4
        val tempNotificationId = 5
        val uvNotificationId = 6
        val aqiNotificationId = 7
        val qualityChannelId = "quality_channel"
        val qualityChannelName = "Quality"
        val qualityChannelDescription = "Quality Channel"
        val qualityChannelImportant = NotificationManager.IMPORTANCE_HIGH
    }

    object Foreground {
        private lateinit var foregroundChannel: NotificationChannel
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

    object PushqQuality {
        private lateinit var qualityChannel: NotificationChannel
        private lateinit var builder: NotificationCompat.Builder
        private lateinit var notificationManager: NotificationManager
        private var title: String = ""
        private var content: String = ""
        private var notificationId = qualityNotificationId

        // First, create an register a channel
        private fun createForegroundChannel() {
            notificationManager =
                    AppContext.context!!.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                qualityChannel = NotificationChannel(qualityChannelId, qualityChannelName, qualityChannelImportant)
                qualityChannel.description = foregroundChannelDescription
                qualityChannel.setShowBadge(false)
                notificationManager.createNotificationChannel(qualityChannel)
            }
        }

        fun setParams(title: String, content: String, notificationId: Int) {
            this.title = title
            this.content = content
            this.notificationId = notificationId
        }

        // Second, create a notification with a channel via channel id
        private fun builder(): Notification {
            createForegroundChannel()
            builder = NotificationCompat.Builder(AppContext.context!!, qualityChannelId)
            builder.apply {
                setSmallIcon(R.drawable.ic_global_warming)
                setContentTitle(title)
                setContentText(content)
                setSmallIcon(R.drawable.ic_global_warming)
                setPriority(NotificationCompat.PRIORITY_HIGH)
            }

            return builder.build()
        }

        fun show() {
            AppContext.context?.let {
                if (title != "" || content != "") {
                    NotificationManagerCompat.from(it)
                            .notify(notificationId, builder())
                }
            }
        }

    }

}