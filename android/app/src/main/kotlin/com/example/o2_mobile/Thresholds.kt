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

            if (value >= 0 && value < 51) message = verygood
            if (value >= 51 && value < 101) message = normal
            if (value >= 101 && value < 151) message = medium
            if (value >= 151 && value < 201) message = bad
            if (value >= 201 && value < 301) message = verybad
            if (value >= 301) message = extreme

            return message
        }

        fun uv(value: Double): String {
            var message = ""

            if (value >= 0 && value < 2) message = safe
            if (value >= 2 && value < 4) message = medium
            if (value >= 4 && value < 7) message = high
            if (value >= 7 && value < 10) message = veryhight
            if (value >= 10) message = extreme

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
