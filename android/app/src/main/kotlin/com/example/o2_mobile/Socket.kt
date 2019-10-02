package com.example.o2_mobile

import android.util.Log
import io.socket.client.IO
import io.socket.client.Socket
import io.socket.emitter.Emitter

class Socket {
    val optional = IO.Options()
    val socket = IO.socket(EndPoint.domain)
    init {
        optional.apply {
            forceNew = true
            reconnection = true
            query = "token" + AppService.token
        }
    }

    fun connect() {
        socket.connect()
        socket.on(Socket.EVENT_CONNECT, Emitter.Listener {
            Log.d("Socket", "Connected")
        })
    }
}