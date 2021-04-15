import 'package:flutter/material.dart';

class WeatherInfoCard extends StatelessWidget {
  final Size size;
  final IconData icon;
  final String title;
  final String subTitle;
  final Color iconColor;

  WeatherInfoCard(
      {this.size, this.icon, this.iconColor, this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            // color: Colors.black45,
            color: Color(0xFF212121),
            width: 3,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(color: Color(0xFF979A9A), fontSize: 16),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            subTitle,
            style: TextStyle(
              color: Colors.white30,
            ),
          )
        ],
      ),
      padding: EdgeInsets.all(5),
      width: size.width * 0.3,
    );
  }
}
