import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather/components/weather_info_card.dart';
import 'forecast_weather_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weather/constants.dart';

class TodayWeatherScreen extends StatefulWidget {
  @override
  _TodayWeatherScreenState createState() => _TodayWeatherScreenState();
}

class _TodayWeatherScreenState extends State<TodayWeatherScreen> {
  double buttonVisibility;
  String weatherState = ' ';
  String location = ' ';
  String humidity = ' ';
  String pressure = ' ';
  String errorMessage = '';
  var consolidatedWeather;
  List<String> date = List<String>(6);
  List<String> wind = List<String>(6);
  List<String> temperature = List<String>(6);
  List<String> abbreviation = List<String>(6);

  bool _loading = false;

  //TODO: initialize weather for your current location and create initialized progress bar

  /*this method happen once i open my app so i can call functions that get
  weather of my location to start my app with
   */
  initState() {
    super.initState();
    buttonVisibility = 0.0;
  }

  int woeid;

  void fetchSearch(String input) async {
    setState(() {
      _loading = true;
    });

    try {
      var searchResult = await http.get(searchApiUrl + input.toLowerCase());

      if (searchResult.statusCode == 200) {
        var jsonsSearchResult = json.decode(searchResult.body)[0];
        setState(() {
          woeid = jsonsSearchResult['woeid'];
          errorMessage = '';
        });
      } else {
        print('Request failed with status: ${searchResult.statusCode}.');
        errorMessage = "Sorry, We didn't have data about this city";
      }
    } catch (error) {
      setState(() {
        errorMessage = "Sorry, We didn't have data about this city";
      });
    }
  }

  void fetchLocation() async {
    var locationResult = await http.get(locationApiUrl + woeid.toString());
    if (locationResult.statusCode == 200) {
      //TODO: stop progress bar
      var jsonLocationResult = json.decode(locationResult.body);
      consolidatedWeather = jsonLocationResult['consolidated_weather'];
      var firstDay = consolidatedWeather[0];
      print('state: ${firstDay['weather_state_name']} \n '
          'wind: ${firstDay['wind_speed']}');

      setState(() {
        _loading = false;
        weatherState = firstDay['weather_state_name'];
        location = jsonLocationResult['timezone'];
        print('location: $location');
        temperature[0] = firstDay['the_temp'].round().toString();
        wind[0] = double.parse((firstDay['wind_speed']).toStringAsFixed(2))
            .toString();
        humidity = firstDay['humidity'].toString() + ' %';
        pressure = firstDay['air_pressure'].toString();
        abbreviation[0] = firstDay['weather_state_abbr'];
        if (temperature != null) buttonVisibility = 1;

        for (int i = 0; i < 6; i++) {
          var forecastDayi = consolidatedWeather[i];
          date[i] = forecastDayi['applicable_date'].toString().substring(5, 10);
          wind[i] =
              double.parse((forecastDayi['wind_speed']).toStringAsFixed(1))
                  .toString();
          temperature[i] = forecastDayi['the_temp'].round().toString();
          abbreviation[i] = forecastDayi['weather_state_abbr'];
        }
      });
    } else {
      //TODO: stop progress bar
      print('Request failed with status: ${locationResult.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        //for flutter bottom overflowed by pixels
        resizeToAvoidBottomInset: false,

        backgroundColor: Color(0xFF212121),
        body: Column(
          children: [
            Container(
              //TODO: search bar
              child: Column(children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    //TODO: create progressbar
                    onSubmitted: (String input) async {
                      await fetchSearch(input);
                      await fetchLocation();
                    },
                    cursorColor: Colors.white,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white70,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white30,
                            width: 1.5,
                          ),
                        ),
                        hintText: 'Search another location..',
                        hintStyle: TextStyle(
                          color: Colors.white30,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white70,
                        )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.redAccent, fontSize: 18),
                ),
              ]),
              height: size.height * 0.15,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: _loading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          'icons/${abbreviation[0] ?? 'empty'}.png',
                                          height: 90,
                                          width: 90,
                                        ),
                                        Text(
                                          '${temperature[0] == null ? ' ' : temperature[0] + '°C'}',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold),
                                        ),
//                                  SizedBox(height: 10),

                                        //  SizedBox(height: 10),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '$weatherState',
                                          style: TextStyle(
                                              color: Colors.white30,
                                              fontSize: 20),
                                        ),

                                        //SizedBox(height: 5),
                                        Text(
                                          '$location',
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white30),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              flex: 3,
                            ),
                            Expanded(
                              child: Opacity(
                                opacity: buttonVisibility,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    WeatherInfoCard(
                                      size: size,
                                      title: 'Wind',
                                      subTitle:
                                          '${wind[0] == null ? ' ' : '${wind[0]} mph'} ',
                                      icon: Icons.waves,
                                      iconColor: Colors.blueGrey[800],
                                    ),
                                    WeatherInfoCard(
                                      size: size,
                                      title: 'Humidity',
                                      subTitle: ' $humidity',
                                      icon: Icons.text_snippet,
                                      iconColor: Colors.cyan[900],
                                    ),
                                    WeatherInfoCard(
                                      size: size,
                                      title: 'Pressure',
                                      subTitle: ' $pressure',
                                      icon: Icons.trending_up,
                                      iconColor: Colors.teal[900],
                                    ),
                                  ],
                                ),
                              ),
                              flex: 2,
                            ),
//                      Expanded(
//                        child: Row(),
//                        flex: 2,
//                      ),
                            SizedBox(
                              height: size.height * 0.1,
                            ),
                            Opacity(
                              opacity: buttonVisibility,
                              child: RawMaterialButton(
                                onPressed: () {
                                  Navigator.push(
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
                                  Icons.expand_less,
                                  size: 40.0,
                                ),
                                padding: EdgeInsets.all(10.0),
                                shape: CircleBorder(),
                              ),
                            )
                          ],
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
