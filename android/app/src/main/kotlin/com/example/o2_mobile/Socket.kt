package com.example.o2_mobile

import android.util.Log
import com.github.nkzawa.socketio.client.IO
import com.github.nkzawa.socketio.client.Socket


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

    fun onDataChanged(place_id: String) {
        socket.on(place_id) {
            Log.d("Socket From BG Service", it[0].toString())
        }
    }
}