import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:o2_mobile/blocs/AirStream.dart';
import 'package:o2_mobile/business/Validate.dart';
import 'package:o2_mobile/models/AirModel.dart';
import 'package:o2_mobile/models/ChartModel.dart';

class ChartFrag extends StatefulWidget {
  String charName;
  ChartFrag(this.charName);
  @override
  State<StatefulWidget> createState() {
    return ChartState(this.charName);
  }
}

class ChartState extends State<ChartFrag> {
  String chartName;
  ChartState(this.chartName);
  LineChartBarData _drawChart(List<FlSpot> input, Color primaryLineColor,
      Color dotColor, double barWidth) {
    return LineChartBarData(
      dotData: FlDotData(
        show: true,
        dotColor: dotColor,
        dotSize: 2,
      ),
      isCurved: false,
      // Put data here
      spots: input,
      colors: [primaryLineColor],
      barWidth: barWidth,
      isStrokeCapRound: true,

      belowBarData: BelowBarData(
        show: false,
      ),
    );
  }

  Widget _chart(List<FlSpot> input,
      [List<FlSpot> limit,
      List<FlSpot> limit2,
      List<FlSpot> limit3,
      List<FlSpot> limit4,
      List<FlSpot> limit5]) {
    return FlChart(
      chart: LineChart(
        LineChartData(
            minX: input == null ? 0 : input[input.length - 1].copyWith().x,
            maxX: input == null ? 1 : input[0].copyWith().x,
            minY: 0,
            lineTouchData: LineTouchData(enableNormalTouch: false),
            gridData: FlGridData(
              show: false,
            ),
            borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.purple,
                    width: 2,
                  ),
                  left: BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  right: BorderSide(
                    color: Colors.transparent,
                  ),
                  top: BorderSide(
                    color: Colors.transparent,
                  ),
                )),
            titlesData: FlTitlesData(
                leftTitles: SideTitles(
                  margin: 5,
                  showTitles: false,
                  textStyle: TextStyle(
                    fontSize: 8,
                    color: Colors.white,
                  ),
                ),
                bottomTitles: SideTitles(
                    margin: 5,
                    showTitles: true,
                    textStyle: TextStyle(
                        fontSize: 6,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                    getTitles: (value) {
                      String valueString = value.toString();
                      int dotIndex = valueString.indexOf('.');
                      String newTitle = '';
                      if (dotIndex != -1) {
                        String h = valueString.substring(0, dotIndex);
                        String m = valueString.substring(
                            dotIndex + 1, valueString.length);
                        newTitle = h + 'h' + m;
                      } else
                        newTitle = valueString;
                      return newTitle;
                    }),
                rightTitles: SideTitles(showTitles: false)),
            // List data here
            lineBarsData: [
              input == null
                  ? _drawChart(
                      [FlSpot(0, 0), FlSpot(1, 1)],
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.0),
                      1)
                  : _drawChart(input, Colors.white, Colors.white, 0.5),
              limit == null
                  ? _drawChart(
                      [FlSpot(0, 0), FlSpot(1, 1)],
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.0),
                      1)
                  : _drawChart(limit, Colors.yellow.withOpacity(0.4),
                      Colors.transparent, 0.2),
              limit2 == null
                  ? _drawChart(
                      [FlSpot(0, 0), FlSpot(1, 1)],
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.0),
                      1)
                  : _drawChart(limit2, Colors.red.withOpacity(0.4),
                      Colors.transparent, 0.2)
            ]),
      ),
    );
  }

  Widget _buildAQIChart(AirModel airModel) {
    List<FlSpot> aoi = List();
    List<FlSpot> limit = List();
    List<FlSpot> limit2 = List();
    List<FlSpot> limit3 = List();
    List<FlSpot> limit4 = List();
    List<FlSpot> limit5 = List();
    int maxLength = 12;
    int index = -1;
    dynamic minX = false;
    dynamic maxX = false;
    // reversed and get 12 last value (newest)
    var reversed = airModel.places[0].times.reversed.toList();
    reversed.forEach((time) {
      index++;
      if (index <= maxLength) {
        print(index);
        String newTime = time.time
            .substring(time.time.indexOf(' '), time.time.length)
            .replaceAll(':', '.');

        index == 0 ? maxX = Validate.isDouble(newTime) : false;
        index == maxLength || index == reversed.length - 1
            ? minX = Validate.isDouble(newTime)
            : false;

        var x = Validate.isDouble(newTime);
        var y = Validate.isDouble(time.datas.dust);
        if (x != false && y != false) {
          //print(x.toString() + ' ' + y.toString());
          double aqi = 0;
          y <= 36.455 ? aqi = 0 : aqi = ((y / 1024) - 0.0356) * 120000 * 0.035;
          print('AQI: ' + aqi.toString());
          aoi.add(FlSpot(x, aqi));
        }
      }
    });

    print('minX: ' + minX.toString());
    print('maxX: ' + maxX.toString());

    if (minX != false && maxX != false) {
      limit.add(FlSpot(minX, 300));
      limit.add(FlSpot(maxX, 300));
      limit2.add(FlSpot(minX, 1050));
      limit2.add(FlSpot(maxX, 1050));
    }
    // Cannot draw line if only have one point, therefor check it before draw
    if (aoi.length > 1 && limit.length > 1)
      return _chart(aoi, limit, limit2);
    else
      return _chart(null);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: airTodayStream.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasError) {
          if (snapshot.hasData) {
            AirModel airModel = snapshot.data;
            if (chartName == ChartModel.aqi) return _buildAQIChart(airModel);
          } else
            print('No chart data');
        }

        return _chart(null);
      },
    );
  }
}
