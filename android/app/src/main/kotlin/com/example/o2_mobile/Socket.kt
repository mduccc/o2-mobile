package com.example.o2_mobile

import android.util.Log
import com.github.nkzawa.socketio.client.IO
import com.github.nkzawa.socketio.client.Socket
import org.json.JSONArray
import org.json.JSONObject


class Socket {
    private val optional = IO.Options()
    private var socket: Socket

    init {
        optional.apply {
            query = "token=" + AppService.token
            transports = arrayOf("websocket")
        }
        socket = IO.socket(EndPoint.domain, optional)
    }

    fun connect() {
        Log.d("Socket From BG Service", "Connecting")

        socket.connect()

        socket.on(Socket.EVENT_CONNECT) {
            Log.d("Socket From BG Service", "Connected")
        }

        socket.on(Socket.EVENT_DISCONNECT) {
            Log.d("Socket From BG Service", "Disconnected")
        }

        socket.on(Socket.EVENT_CONNECT_ERROR) {
            Log.d("Socket From BG Service", "Connect error")
        }

        socket.on(Socket.EVENT_CONNECT_TIMEOUT) {
            Log.d("Socket From BG Service", "Connect timeout")
        }
    }

    fun onNotify() {
        val eventName = "notify"
        socket.on(eventName) {
            Log.d("Socket From BG Service", it[0].toString())
        }
    }

    private fun reverse(jsonArray: JSONArray): JSONArray {
        val result = JSONArray()

        for (i in jsonArray.length() - 1 downTo 0)
            result.put(jsonArray[i])

        return result
    }

    fun onDataChanged(place_id: String) {
        socket.on(place_id) {
            val jsonData = JSONObject(it[0].toString())
            val firstPlace = jsonData.getJSONArray("places").getJSONObject(0)
            val firstPlaceName = firstPlace.getString("place_name")
            val firstTimeFromPlace = reverse(firstPlace.getJSONArray("times")).getJSONObject(0)

            val firstTimeValue = firstTimeFromPlace.getString("time")
            val firstTimeData = JSONObject(firstTimeFromPlace.getString("dates"))

            val soild = firstTimeData.getString("soil")
            val uv = firstTimeData.getString("uv")
            val smoke = firstTimeData.getString("smoke")
            val fire = firstTimeData.getString("fire")
            val co = firstTimeData.getString("co")
            val rain = firstTimeData.getString("rain")
            val dust = firstTimeData.getString("dust")
            val temp = firstTimeData.getString("temp")
            val humidity = firstTimeData.getString("humidity")

            // AQI
            if (Validate.isDouble(dust)) {
                var aqi: Double
                dust.toDouble().apply {
                    aqi = if (this < 36.455)
                        0.0
                    else
                        ((this / 1024) - 0.0356) * 120000 * 0.035

                    val thresholds = Thresholds.aqi(aqi)

                    if (thresholds == Thresholds.bad || thresholds == Thresholds.extreme) {
                        Notification.PushqQuality.apply {
                            setParams("AQI in $firstPlaceName", "$thresholds ($firstTimeValue)", Notification.aqiNotificationId)
                            show()
                        }
                    }
                }
            }

            // Fire
            if (Validate.isDouble(fire)) {
                fire.toDouble().apply {
                    if (this == 1.0) {
                        Notification.PushqQuality.apply {
                            setParams("Fire in $firstPlaceName", "Detected Fire ($firstTimeValue)", Notification.fireNotificationId)
                            show()
                        }
                    }
                }
            }

            // Rain
            if (Validate.isDouble(rain)) {
                rain.toDouble().apply {
                    if (this == 1.0) {
                        Notification.PushqQuality.apply {
                            setParams("Rain in $firstPlaceName", "Raining ($firstTimeValue)", Notification.rainNotificationId)
                            show()
                        }
                    }
                }
            }

            // UV
            if (Validate.isDouble(uv)) {
                uv.toDouble().apply {
                    val thresholds = Thresholds.uv(this)

                    if (thresholds == Thresholds.high || thresholds == Thresholds.veryhight || thresholds == Thresholds.extreme) {
                        Notification.PushqQuality.apply {
                            setParams("UV in $firstPlaceName", "$thresholds ($firstTimeValue)", Notification.aqiNotificationId)
                            show()
                        }
                    }
                }
            }

            // CO
            if (Validate.isDouble(co)) {
                co.toDouble().apply {
                    val thresholds = Thresholds.co(this)

                    if (thresholds == Thresholds.high || thresholds == Thresholds.veryhight || thresholds == Thresholds.extreme) {
                        Notification.PushqQuality.apply {
                            setParams("CO in $firstPlaceName", "$thresholds ($firstTimeValue)", Notification.aqiNotificationId)
                            show()
                        }
                    }
                }
            }
        }
    }
}