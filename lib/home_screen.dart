



import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Clea.dart';
import 'Clouds.dart';
import 'DefaultWeather.dart';
import 'Haze.dart';
import 'Humidity.dart';
import 'MainWeather.dart';
import 'Rain.dart';
import 'WindSpeed.dart';
class HomeScreen extends StatefulWidget {
const HomeScreen({Key? key}) : super(key: key);

@override
State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getWeather();
  }

  String cityName = 'London'; //Default City

  final TextEditingController _controller = TextEditingController();

  var temp = '80';
  var description = 'Mostly cloudy';
  var mainWeather = 'Rain';
  var humidity = '80';
  var windSpeed = '0.50';
  var clouds = '65';//These values will change after changing the location

  Future getWeather() async {
    //Getting Weather information from api
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid={553f3e8bce2e23be0f15f54381f5dc0d}'); //Sign in to openweathermap.org then get your api key
    final weather = await http.get(url);
    final response = json.decode(weather.body);

    setState(() {
      temp = response['main']['temp'].toString();
      description = response['weather'][0]['description'];
      mainWeather = response['weather'][0]['main'];
      humidity = response['main']['humidity'].toString();
      windSpeed = response['wind']['speed'].toString();
      clouds = response['clouds']['all'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 8),
                color: Colors.blue.shade400,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8, left: 10),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 25),
                        SizedBox(
                          width: 200,
                          height: 70,
                          child: TextField(
                            controller: _controller,
                            onChanged: (value) {
                              cityName = value;
                              getWeather();
                            },
                            decoration: const InputDecoration(
                              labelText: 'Enter city name',
                              labelStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8, right: 10),
                      child: Icon(
                        Icons.more_vert_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.50,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.lightBlue, Colors.blue, Colors.blueAccent],
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(children: [
                    SizedBox(
                      height: 220,
                      child: mainWeather == 'Rain'
                          ? const Rain()
                          : mainWeather == 'Clear'
                          ? const Clear()
                          : mainWeather == 'Haze'
                          ? const Haze()
                          : const DefaultWeather(), //display image according to Weather
                    ),
                    Text(
                      temp.toString() + '\u00B0',  // u00B0 is unicode for degree symbol
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Location: " + cityName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              Column(
                children: [
                  MainWeather(mainWeather: mainWeather),
                  Clouds(clouds: clouds),
                  Humidity(humidity: humidity),
                  WindSpeed(windSpeed: windSpeed)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

