import 'package:flutter/material.dart';
import 'package:weather/main.dart';
import 'today_weather_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weather/components/forecast_card.dart';
import 'package:weather/screens/today_weather_screen.dart';
import 'package:weather/constants.dart';

TodayWeatherScreen todayWeatherScreen = TodayWeatherScreen();

class ForecastWeatherScreen extends StatelessWidget {
  var date = [];
  var wind = [];
  var temperature = [];
  var abbreviation = [];

  ForecastWeatherScreen(
      {Key key,
      @required this.date,
      @required this.temperature,
      @required this.wind,
      this.abbreviation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Container(
          // margin: EdgeInsets.only(top: size.height * 0.15),
          //height: size.height * 0.80,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 100),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '  Day',
                          style: TextStyle(
                              fontSize: fontSizeElement,
                              color: elementColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'State',
                          style: TextStyle(
                              fontSize: fontSizeElement,
                              color: elementColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Temp',
                          style: TextStyle(
                              fontSize: fontSizeElement,
                              color: elementColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Wind',
                          style: TextStyle(
                              fontSize: fontSizeElement,
                              color: elementColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  forecastRow(0),
                  forecastRow(1),
                  forecastRow(2),
                  forecastRow(3),
                  forecastRow(4),
                  forecastRow(5),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      PageTransition(
                        curve: Curves.linear,
                        type: PageTransitionType.bottomToTop,
                        child: ForecastWeatherScreen(
                          temperature: temperature,
                          wind: wind,
                          date: date,
                          abbreviation: abbreviation,
                        ),
                      ),
                    );
                  },
                  elevation: 2.0,
                  fillColor: Colors.white70,
                  child: Icon(
                    Icons.expand_more,
                    size: 40.0,
                  ),
                  padding: EdgeInsets.all(10.0),
                  shape: CircleBorder(),
                ),
              )
            ],
            // color: Colors.red,
          ),
        ),
      ),
    );
  }

  Column forecastRow(int i) {
    return Column(
      children: [
        ForecastCard(
            day: date[i],
            icon: abbreviation[i],
            temp: temperature[i],
            wind: wind[i]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 55),
          child: Divider(
            height: kDividerHeight,
            color: Colors.white30,
          ),
        ),
      ],
    );
  }
}
