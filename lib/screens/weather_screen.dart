
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uts_mobile_programming/api/weather_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuaca App'),
      ),
      body: FutureBuilder(
        future:
            _getCurrentLocationWeather(), // Get current location weather data
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final weatherData = snapshot.data!;
              final cityName = weatherData['cityName'];
              final temperature = weatherData['temperature'];
              final weather = weatherData['weather'];
              IconData iconData;

              switch (weather.toLowerCase()) {
                case 'clear':
                  iconData = FontAwesomeIcons.sun;
                  break;
                case 'clouds':
                  iconData = FontAwesomeIcons.cloud;
                  break;
                case 'rain':
                  iconData = FontAwesomeIcons.cloudRain;
                  break;
                case 'thunderstorm':
                  iconData = FontAwesomeIcons.bolt;
                  break;
                case 'drizzle':
                  iconData = FontAwesomeIcons.cloudShowersHeavy;
                  break;
                case 'snow':
                  iconData = FontAwesomeIcons.snowflake;
                  break;
                case 'mist':
                  iconData = FontAwesomeIcons.smog;
                  break;
                default:
                  iconData = FontAwesomeIcons
                      .question; 
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Icon(
                        iconData,
                        size: 50,
                        color:
                            Colors.orange, // You can change the color as needed
                      ),
                      const SizedBox(height: 10),
                      Text(
                        cityName,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Temperature: $temperature°C',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Weather: $weather',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _getCurrentLocationWeather() async {
    try {
      if (!(await Permission.location.status.isGranted)) {
        await Permission.location.request();
      }

      // Cek status izin lokasi
      if (await Permission.location.serviceStatus.isEnabled) {
        // Lakukan pengambilan lokasi jika izin sudah diberikan dan layanan lokasi diaktifkan
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best); // Get current position
        final weatherService = WeatherService();
        final weatherData = await weatherService.fetchWeatherDataByCoordinates(
            position.latitude,
            position.longitude); // Fetch weather data by coordinates
        return {
          'cityName': weatherData['name'],
          'temperature': weatherData['main']['temp'],
          'weather': weatherData['weather'][0]['main']
        };
      } else {
        throw Exception('Location service is disabled');
      }
    } catch (e) {
      return {
        'cityName': 'Unknown',
        'temperature': 'Unknown',
        'weather': 'Unknown'
      };
    }
  }
}
