package com.example.o2_mobile

class AQI {
    companion object{
        fun cal(dust: Double, co: Double, smoke: Double, uv: Double): Double {
            return (dust / 1.66) * 0.9 + ((co.toDouble() + smoke.toDouble()) / 2) * 4.84 * 0.5 + uv.toDouble() * 1.2 * 0.5
        }
    }
}