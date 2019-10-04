package com.example.o2_mobile

import java.lang.Exception

class Validate {
    companion object {
        fun isDouble(value: String): Boolean {
            try {
                value.toDouble()
                return true
            } catch (e: Exception) {
                return false
            }
        }
    }
}