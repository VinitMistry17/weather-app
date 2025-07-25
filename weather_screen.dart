import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_weather_app/Services/weather_service.dart';

import '../Models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService(apiKey: 'd3a8d9f2865d4850bc56ec4cbb042088');
  Weather? _weather;

  //fetch weather
  _fatchWeather() async{
    //get current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for city
    try{
      final weather = await _weatherService.getWeather(cityName: cityName);
      setState(() {
        _weather = weather;
      });
    }

    //any error
    catch(e){
      print(e);
    }
  }
  //weather animation
  String getWeatherAnimation(String? mainCondition){
    if(mainCondition == null) return 'assets/Weather-sunny.json';//default animation
    switch(mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
        return 'assets/Weather-windy.json';
        case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/Weather-partly shower.json';
        case 'thunderstorm':
        return 'assets/Weather-storm.json';
        case 'clear':
        return 'assets/Weather-sunny.json';
        default:
        return 'assets/Weather-sunny.json';
    }
  }
  //initstate to fetch weather
  @override
  void initState(){
    super.initState();
    //fetch weather on startup
    _fatchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(
              _weather?.cityName ?? 'Loading City...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            //temperature
            Text(
              '${_weather?.temperature.round() ?? 'Loding temperature...'}°C',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
              ),
            ),

            //weather condition
            Text(
              _weather?.mainCondition ?? ' ',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ]
        )
      )
    );
  }
}
