import 'package:flutter/material.dart';

const double fontSizeElement = 22;
const Color elementColor = Color(0xFF979A9A);

class ForecastCard extends StatelessWidget {
  final String day;
  final String icon;
  final String temp;
  final String wind;

  ForecastCard({this.day, this.icon, this.temp, this.wind});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '$day',
            style: TextStyle(
              fontSize: fontSizeElement,
              color: elementColor,
            ),
          ),
          Image.asset(
            'icons/my${icon ?? 'empty'}.png',
            height: 30,
            width: 30,
            //color: Colors.red,
            color: elementColor,
          ),
          Text(
            '${temp == null ? ' ' : '$temp°'}',
            style: TextStyle(
              fontSize: fontSizeElement,
              color: elementColor,
            ),
          ),
          Text(
            '${wind == null ? ' ' : '$wind°'}',
            style: TextStyle(
              fontSize: fontSizeElement,
              color: elementColor,
            ),
          ),
        ],
      ),
    );
  }
}
