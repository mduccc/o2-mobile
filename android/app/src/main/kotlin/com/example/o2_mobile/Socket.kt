package com.example.o2_mobile

import io.socket.client.IO

class Socket {
    val optional = IO.Options()
    val socket = IO.socket(EndPoint.domain)
    init {
        optional.apply {
            forceNew = true
            reconnection = true

        }
    }
}