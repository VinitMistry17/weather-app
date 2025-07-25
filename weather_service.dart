import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:simple_weather_app/Models/weather_model.dart';
import 'package:http/http.dart'as http;

class WeatherService{
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;
  WeatherService({required this.apiKey});

  Future<Weather> getWeather({required String cityName})async{
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));
    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to load weather data');
    }
  }
  Future<String> getCurrentCity() async{
    //get permission from user
    LocationPermission permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }
    //get current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //get city name from location
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    //extract the city name from the first placemark
    String city = placemarks[0].locality!;
    return city ?? '';
  }
}