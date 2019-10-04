class Thresholds {
    companion object {
        const val verybad = "Rất tệ"
        const val bad = "Tệ"
        const val normal = "Bình thường"
        const val medium = "Trung bình"
        const val good = "Tuyệt"
        const val verygood = "Rất tuyệt"

        const val safe = "An toàn"
        const val extreme = "Cực nguy hiểm"

        const val verycool = "Rất lạnh"
        const val cool = "Lạnh"
        const val hot = "Nóng"
        const val veryhot = "Rất nóng"

        const val low = "Thấp"
        const val verylow = "Rất thấp"
        const val high = "Cao"
        const val veryhight = "Rất cao"

        fun aqi(value: Double): String {
            var message = ""

            if (value >= 0 && value < 75) message = verygood
            if (value >= 75 && value < 150) message = good
            if (value >= 150 && value < 300) message = normal
            if (value >= 300 && value < 1050) message = medium
            if (value >= 1050 && value < 3000) message = bad
            if (value >= 3000) message = extreme

            return message
        }

        fun uv(value: Double): String {
            var message = ""

            if (value >= 0 && value < 50) message = safe
            if (value >= 50 && value < 125) message = medium
            if (value >= 125 && value < 175) message = high
            if (value >= 175 && value < 250) message = veryhight
            if (value >= 250) message = extreme

            return message
        }

        fun temp(value: Double): String {
            var message = ""

            if (value < 0) message = extreme
            if (value >= 0 && value < 10) message = verylow
            if (value >= 10 && value < 20) message = low
            if (value >= 20 && value < 25) message = normal
            if (value >= 25 && value < 35) message = high
            if (value >= 35 && value < 40) message = veryhight
            if (value >= 40) message = extreme

            return message
        }

        fun co(value: Double): String {
            var message = ""

            if (value >= 0 && value < 3) message = safe
            if (value >= 3 && value < 7) message = normal
            if (value >= 7 && value < 15) message = medium
            if (value >= 15 && value < 30) message = high
            if (value >= 30 && value < 62) message = veryhight
            if (value >= 62) message = extreme

            return message
        }
    }
}
