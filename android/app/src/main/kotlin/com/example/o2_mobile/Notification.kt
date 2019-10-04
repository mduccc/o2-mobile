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

        val notifyNotificationId = 2
        val qualityNotificationId = 2
        val fireNotificationId = 3
        val rainNotificationId = 4
        val tempNotificationId = 5
        val uvNotificationId = 6
        val aqiNotificationId = 7
        val coNotificationId = 8

        val qualityChannelId = "quality_channel"
        val qualityChannelName = "Quality"
        val qualityChannelDescription = "Quality Channel"
        val qualityChannelImportant = NotificationManager.IMPORTANCE_DEFAULT

        val notifyChannelId = "quality_channel"
        val notifyChannelName = "Quality"
        val notifyChannelDescription = "Quality Channel"
        val notifyChannelImportant = NotificationManager.IMPORTANCE_HIGH
    }

    object Foreground {
        private lateinit var foregroundChannel: NotificationChannel
        private lateinit var builder: NotificationCompat.Builder
        private lateinit var notificationManager: NotificationManager
        private var title = "Air Monitor"
        private var content = "I'm working"

        fun setParams(title: String, content: String) {
            this.title = title
            this.content = content
        }

        // First, create an register a channel
        private fun createForegroundChannel() {
            notificationManager =
                    AppContext.context!!.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                foregroundChannel = NotificationChannel(foregroundChannelId, foregroundChannelName, foregroundChannelImportant)
                foregroundChannel.description = foregroundChannelDescription
                foregroundChannel.setShowBadge(true)
                notificationManager.createNotificationChannel(foregroundChannel)
            }
        }

        // Second, create a notification with a channel via channel id
        fun builder(): Notification {
            createForegroundChannel()
            builder = NotificationCompat.Builder(AppContext.context!!, foregroundChannelId)
            builder.apply {
                setSmallIcon(R.drawable.ic_timeline_24dp)
                setContentTitle(title)
                setContentText(content)
                setSmallIcon(R.drawable.ic_timeline_24dp)
                setPriority(NotificationCompat.PRIORITY_MIN)
                setStyle(NotificationCompat.BigTextStyle().bigText(content))
            }

            return builder.build()
        }

        fun update() {
            AppContext.context?.let {
                if (title.isNotBlank() || content.isNotBlank()) {
                    NotificationManagerCompat.from(it)
                            .notify(foregroundNotificationId, builder())
                }
            }
        }
    }

    object PushQuality {
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
                qualityChannel.description = qualityChannelDescription
                qualityChannel.setShowBadge(true)
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
                if (title.isNotBlank() || content.isNotBlank()) {
                    NotificationManagerCompat.from(it)
                            .notify(notificationId, builder())
                }
            }
        }
    }

    object Notify {
        private lateinit var notifyChannel: NotificationChannel
        private lateinit var builder: NotificationCompat.Builder
        private lateinit var notificationManager: NotificationManager
        private var title: String = ""
        private var content: String = ""

        // First, create an register a channel
        private fun createForegroundChannel() {
            notificationManager =
                    AppContext.context!!.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                notifyChannel = NotificationChannel(notifyChannelId, notifyChannelName, notifyChannelImportant)
                notifyChannel.description = notifyChannelDescription
                notifyChannel.setShowBadge(true)
                notificationManager.createNotificationChannel(notifyChannel)
            }
        }

        fun setParams(title: String, content: String) {
            this.title = title
            this.content = content
        }

        // Second, create a notification with a channel via channel id
        private fun builder(): Notification {
            createForegroundChannel()
            builder = NotificationCompat.Builder(AppContext.context!!, notifyChannelId)
            builder.apply {
                setSmallIcon(R.drawable.ic_message_24dp)
                setContentTitle(title)
                setContentText(content)
                setSmallIcon(R.drawable.ic_message_24dp)
                setPriority(NotificationCompat.PRIORITY_HIGH)
            }

            return builder.build()
        }

        fun show() {
            AppContext.context?.let {
                if (title.isNotBlank() || content.isNotBlank()) {
                    NotificationManagerCompat.from(it)
                            .notify(notifyNotificationId, builder())
                }
            }
        }
    }

}