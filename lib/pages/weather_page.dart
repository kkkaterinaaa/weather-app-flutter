import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:new_app/models/weather_model.dart';
import 'package:new_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('your-api-key');
  Weather? _weather;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  /// Fetches weather based on the user's current location.
  Future<void> _fetchWeather() async {
    try {
      final cityName = await _weatherService.getCity();
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Fetches weather for the city typed in the search bar.
  Future<void> _fetchWeatherByCity(String city) async {
    try {
      final weather = await _weatherService.getWeather(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<Color> _getBackgroundGradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'clouds':
        return [Colors.grey.shade400, Colors.grey.shade700];
      case 'mist':
      case 'fog':
      case 'haze':
      case 'smoke':
      case 'dust':
        return [Colors.blueGrey.shade200, Colors.blueGrey.shade500];
      case 'rain':
      case 'drizzle':
        return [Colors.blueGrey.shade600, Colors.blueGrey.shade900];
      case 'thunderstorm':
        return [Colors.deepPurple.shade600, Colors.deepPurple.shade900];
      case 'clear':
        return [Colors.orange.shade200, Colors.orange.shade400];
      case 'snow':
        return [Colors.lightBlue.shade100, Colors.lightBlue.shade300];
      default:
        return [Colors.blue.shade200, Colors.blue.shade500];
    }
  }

  Widget _buildWeatherAnimation(String condition) {
    switch (condition.toLowerCase()) {
      case 'clouds':
        return Lottie.asset('assets/cloud.json', width: 300, height: 300);
      case 'mist':
      case 'fog':
      case 'haze':
      case 'smoke':
      case 'dust':
        return Lottie.asset('assets/fog.json', width: 300, height: 300);
      case 'rain':
      case 'drizzle':
        return Lottie.asset('assets/rain.json', width: 300, height: 300);
      case 'thunderstorm':
        return Lottie.asset('assets/thunder.json', width: 300, height: 300);
      case 'clear':
        return Lottie.asset('assets/sunny.json', width: 300, height: 300);
      case 'snow':
        return Lottie.asset('assets/snow.json', width: 300, height: 300);
      default:
        return Lottie.asset('assets/sun.json', width: 300, height: 300);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _weather != null
        ? _getBackgroundGradient(_weather!.condition)
        : [Colors.blue.shade200, Colors.blue.shade500];

    return Scaffold(
      appBar: null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 4,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search city',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          _fetchWeatherByCity(value);
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _fetchWeatherByCity(_searchController.text);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.my_location),
                      onPressed: () {
                        _fetchWeather();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: _weather != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _weather!.city,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${_weather!.temperature.round()}°C',
                              style: const TextStyle(
                                fontSize: 32,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildWeatherAnimation(_weather!.condition),
                            const SizedBox(height: 20),
                            Text(
                              _weather!.condition,
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
