package com.example.o2_mobile

import android.text.Html
import android.util.Log
import com.github.nkzawa.socketio.client.IO
import com.github.nkzawa.socketio.client.Socket
import org.json.JSONArray
import org.json.JSONObject


class Socket {
    private val optional = IO.Options()
    var socket: Socket? = null
    private val _timeout = 5000.toLong()

    fun setupAndConnect() {
        socket = IO.socket(EndPoint.domain, optional)
        Log.d("Socket From BG Service", "Connecting")

        socket?.connect()
        optional.apply {
            query = "token=" + AppService.token
            transports = arrayOf("websocket")
            reconnection = false
            timeout = _timeout
        }
    }

    fun offEvent() {
        socket?.off(Socket.EVENT_CONNECT)
        socket?.off(Socket.EVENT_DISCONNECT)
        socket?.off(Socket.EVENT_CONNECT_ERROR)
        socket?.off(Socket.EVENT_RECONNECT_FAILED)
    }

    fun event() {
        socket?.on(Socket.EVENT_CONNECT) {
            Log.d("Socket From BG Service", "Connected")
        }

        socket?.on(Socket.EVENT_DISCONNECT) {
            Log.d("Socket From BG Service", "Disconnected. Retry in 5 seconds")
            Thread.sleep(_timeout)
            setupAndConnect()
        }

        socket?.on(Socket.EVENT_CONNECT_ERROR) {
            Log.d("Socket From BG Service", "Connect error. Retry in 5 seconds")
            Thread.sleep(_timeout)
            setupAndConnect()
        }

        socket?.on(Socket.EVENT_RECONNECT_FAILED) {
            Log.d("Socket From BG Service", "Connect failed. Retry in 5 seconds")
            Thread.sleep(_timeout)
            setupAndConnect()
        }

    }

    fun onNotify() {
        socket?.on("notify") {
            val message = it[0].toString()
            Log.d("Socket From BG Service", message)
            if (message.isNotBlank()) {
                Notification.Notify.apply {
                    setParams("Message", message)
                    show()
                }
            }
        }
    }

    private fun reverse(jsonArray: JSONArray): JSONArray {
        val result = JSONArray()

        for (i in jsonArray.length() - 1 downTo 0)
            result.put(jsonArray[i])

        return result
    }

    fun onDataChanged(place_id: String) {
        socket?.on(place_id) {
            val jsonData = JSONObject(it[0].toString())
            val firstPlace = jsonData.getJSONArray("places").getJSONObject(0)
            val firstPlaceName = firstPlace.getString("place_name")
            val firstTimeFromPlace = reverse(firstPlace.getJSONArray("times")).getJSONObject(0)

            val firstTimeValue = firstTimeFromPlace.getString("time")
            val firstTimeData = JSONObject(firstTimeFromPlace.getString("datas"))

            val soil = firstTimeData.getString("soil")
            val uv = firstTimeData.getString("uv")
            val smoke = firstTimeData.getString("smoke")
            val fire = firstTimeData.getString("fire")
            val co = firstTimeData.getString("co")
            val rain = firstTimeData.getString("rain")
            val dust = firstTimeData.getString("dust")
            val temp = firstTimeData.getString("temp")
            val humidity = firstTimeData.getString("humidity")

            // Foreground
            Notification.Foreground.apply {
                setParams("Air Monitor", "Thời gian: $firstTimeValue\n" +
                        " ${Html.fromHtml("&#183;")} " + (if (fire == "1") "CÓ LỬA" else "Không có lửa") + "\n" +
                        " ${Html.fromHtml("&#183;")} " + (if (rain == "1") "Đang mưa" else "Không mưa") + "\n" +
                        " ${Html.fromHtml("&#183;")} Nhiệt độ: $temp ${Html.fromHtml("&#176;").toString() + "C"}\n" +
                        " ${Html.fromHtml("&#183;")} Độ ẩm: $humidity %\n" +
                        " ${Html.fromHtml("&#183;")} Hỗn hợp khí: $smoke ppm\n" +
                        " ${Html.fromHtml("&#183;")} CO: $co ppm\n" +
                        " ${Html.fromHtml("&#183;")} Bụi: $dust ${"mg/m" + Html.fromHtml("&#179;").toString()}\n" +
                        " ${Html.fromHtml("&#183;")} Tia UV: $uv ${"mW/cm" + Html.fromHtml("&#178;").toString()}\n" +
                        " ${Html.fromHtml("&#183;")} Độ ẩm đất: $soil %")
                update()
            }

            // AQI
            if (Validate.isDouble(dust)) {
                var aqi: Double
                dust.toDouble().apply {
                    aqi = if (this < 36.455)
                        0.0
                    else
                        ((this / 1024) - 0.0356) * 120000 * 0.035

                    aqi = String.format("%.2f", aqi).toDouble()

                    val thresholds = Thresholds.aqi(aqi)

                    if (thresholds == Thresholds.bad || thresholds == Thresholds.extreme) {
                        Log.d("Dust from Kotlin", this.toString())
                        Log.d("AQI from Kotlin", aqi.toString())
                        Notification.PushQuality.apply {
                            setParams("AQI tại $firstPlaceName", "${thresholds.toUpperCase()}: $aqi ($firstTimeValue)", Notification.aqiNotificationId)
                            show()
                        }
                    }
                }
            }

            // Fire
            if (Validate.isDouble(fire)) {
                fire.toDouble().apply {
                    if (this == 1.0) {
                        Notification.PushQuality.apply {
                            setParams("Lửa tại $firstPlaceName", "CÓ LỬA ($firstTimeValue)", Notification.fireNotificationId)
                            show()
                        }
                    }
                }
            }

            // Rain
            if (Validate.isDouble(rain)) {
                rain.toDouble().apply {
                    if (this == 1.0) {
                        Notification.PushQuality.apply {
                            setParams("Mưa tại $firstPlaceName", "Đang mưa ($firstTimeValue)", Notification.rainNotificationId)
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
                        Notification.PushQuality.apply {
                            setParams("UV tại $firstPlaceName", "${thresholds.toUpperCase()}: ${String.format("%.2f", uv.toDouble())} ${"mW/cm" + Html.fromHtml("&#178;").toString()} ($firstTimeValue)", Notification.uvNotificationId)
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
                        Notification.PushQuality.apply {
                            setParams("CO tại $firstPlaceName", "${thresholds.toUpperCase()}: ${String.format("%.2f", co.toDouble())} ppm ($firstTimeValue)", Notification.coNotificationId)
                            show()
                        }
                    }
                }
            }
        }
    }
}