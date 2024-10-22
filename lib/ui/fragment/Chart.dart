import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:o2_mobile/blocs/AirStream.dart';
import 'package:o2_mobile/business/AQI.dart' as prefix0;
import 'package:o2_mobile/business/Validate.dart';
import 'package:o2_mobile/models/AirModel.dart';
import 'package:o2_mobile/models/ChartModel.dart';

class ChartFrag extends StatefulWidget {
  double _width, _height;
  ChartFrag(this.charName, this._width, this._height);
  String charName;
  @override
  State<StatefulWidget> createState() {
    return _ChartState(this.charName, this._width, this._height);
  }
}

class _ChartState extends State<ChartFrag> {
  String chartName;
  double _width, _height;
  _ChartState(this.chartName, this._width, this._height);
  LineChartBarData _drawChart(List<FlSpot> input, Color primaryLineColor,
      Color dotColor, double barWidth) {
    return LineChartBarData(
      dotData: FlDotData(
        show: true,
        dotColor: dotColor,
        dotSize: 0.5,
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
            lineTouchData: LineTouchData(enableNormalTouch: false),
            gridData: FlGridData(
              show: false,
            ),
            borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.green,
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
                    margin: 2,
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
                      if (newTitle.length <= 5)
                        return newTitle;
                      else
                        return '';
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
                  : _drawChart(input, Colors.white, Colors.white, 1),
              limit == null
                  ? _drawChart(
                      [FlSpot(0, 0), FlSpot(1, 1)],
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.0),
                      1)
                  : _drawChart(limit, Colors.yellow, Colors.transparent, 0.2),
              limit2 == null
                  ? _drawChart(
                      [FlSpot(0, 0), FlSpot(1, 1)],
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.0),
                      1)
                  : _drawChart(limit2, Colors.red, Colors.transparent, 0.2)
            ]),
      ),
    );
  }

  Widget _buildAQIChart(AirModel airModel) {
    List<FlSpot> aois = List();
    List<FlSpot> limit = List();
    List<FlSpot> limit2 = List();
    List<FlSpot> limit3 = List();
    List<FlSpot> limit4 = List();
    List<FlSpot> limit5 = List();
    int maxLength = 15;
    int index = -1;
    // for draw limit
    dynamic minX = false;
    dynamic maxX = false;
    // reversed and get 12 last value (newest)
    var reversed = airModel.places[0].times.reversed.toList();
    reversed.forEach((time) {
      index++;
      if (index <= maxLength) {
        print(index);
        // convert hh:mm to double
        String newTime = time.time
            .substring(time.time.indexOf(' '), time.time.length)
            .replaceAll(':', '.');

        // set maxX, minX
        index == 0 ? maxX = Validate.isDouble(newTime) : false;
        index == maxLength || index == reversed.length - 1
            ? minX = Validate.isDouble(newTime)
            : false;

        // X is time value converted, Y is value of AQI from dust
        var x = Validate.isDouble(newTime);
        var dust = Validate.isDouble(time.datas.dust);
        var co = Validate.isDouble(time.datas.co);
        var smoke = Validate.isDouble(time.datas.smoke);
        var uv = Validate.isDouble(time.datas.uv);

        // If x, y is double number
        if (x != false &&
            dust != false &&
            co != false &&
            smoke != false &&
            uv != false) {
          //print(x.toString() + ' ' + y.toString());
          double aqi = prefix0.aqi.cal(dust, co, smoke, uv);

          print('AQI: ' + aqi.toString());

          // add a point to chart
          aois.add(FlSpot(x, aqi));
        }
      }
    });

    print('minX: ' + minX.toString());
    print('maxX: ' + maxX.toString());

    // If minX, minY is double number
    if (minX != false && maxX != false) {
      limit.add(FlSpot(minX, 101));
      limit.add(FlSpot(maxX, 101));
      limit2.add(FlSpot(minX, 151));
      limit2.add(FlSpot(maxX, 151));
    }
    // Cannot draw line if only have one point, therefor check it before draw
    if (aois.length > 1)
      return Column(
        children: <Widget>[
          // Description
          Expanded(
            flex: 1,
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: FractionalOffset.centerLeft,
                      child: Text(
                        'Thời gian qua',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 10),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: this._width / 25,
                          height: 1,
                          color: Colors.yellow,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Cảnh báo.',
                              style: TextStyle(
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 10),
                            ),
                          ),
                        ),
                        Container(
                          width: this._width / 25,
                          height: 1,
                          color: Colors.red,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Nguy hiểm.',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 10),
                            ),
                          ),
                        ),
                        Container(
                          width: this._width / 25,
                          height: 1,
                          color: Colors.white,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'AQI.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          // Chart
          Expanded(
            flex: 10,
            child: Container(
              width: double.infinity,
              child: _chart(aois, limit, limit2),
            ),
          ),
        ],
      );
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
            if (airModel.code == 200) if (chartName == ChartModel.aqi)
              return _buildAQIChart(airModel);
          } else
            print('No chart data');
        }

        return _chart(null);
      },
    );
  }
}
