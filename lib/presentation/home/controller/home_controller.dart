import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather/config/app_routes.dart';
import 'package:weather/presentation/home/model/home_model.dart';
import 'package:http/http.dart' as http;
import 'package:weather/presentation/home/model/hourly_model.dart';

class HomeController extends GetxController {
  WeatherData weatherData = WeatherData();
  HourData hourData = HourData();
  Future getWeatherData() async {
    try {
      var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?lat=29.992008&lon=31.171794&appid=f4f8c17a28834dc12689b7bb28fc68e0'),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseJson = jsonDecode(await response.stream.bytesToString());
        weatherData =
            WeatherData.fromJson(responseJson); // Update your model parsing
        update();
        return responseJson;
      } else {
        print("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print(e);
    }
  }

  void weekNav(String selectedUnit) {
    Get.offAllNamed(AppRoutes.week, arguments: selectedUnit);
  }

  String getFormattedDate(int timestamp) {
    // Convert the UNIX timestamp to DateTime object
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    // Format the date as 'Monday, 10 Oct 2024, 10:00 AM'
    String formattedDate = DateFormat('EEEE, d MMM yyyy, h:mm a').format(date);

    return formattedDate;
  }

  String getTemperature(double? temp, String selectedUnit) {
    if (temp == null) return '-';

    // Check if the user selected Fahrenheit
    if (selectedUnit == 'Celsius') {
      double celsius = temp - 273.15;
      return '${celsius.toStringAsFixed(1)} °C';
    }
    double fer = (temp - 273.15) * 9 / 5 + 32;
    // Default to Kelvin
    return '${fer.toStringAsFixed(1)} °F';
  }

  String getHourTemperature(double? temp, String selectedUnit) {
    if (temp == null) return '-';

    // Check if the user selected Fahrenheit
    if (selectedUnit == 'Celsius') {
      double celsius = (temp - 32) * (5 / 9);
      return '${celsius.toStringAsFixed(1)} °C';
    }

    return '${temp.toStringAsFixed(1)} °F';
  }

  Future getHourWeatherData() async {
    try {
      var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.open-meteo.com/v1/forecast?latitude=29.992008&longitude=31.171794&hourly=temperature_2m,relative_humidity_2m&temperature_unit=fahrenheit&timezone=GMT&forecast_days=3'),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseJson = jsonDecode(await response.stream.bytesToString());
        hourData = HourData.fromJson(responseJson); // Update your model parsing
        update();
        return responseJson;
      } else {
        print("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print(e);
    }
  }

  Future getTheData() async {
    List data = [];
    await Future.wait([getWeatherData(), getHourWeatherData()]).then((v) {
      data.addAll(v);
      print("All API is here");
    });
    return {'weather': data[0], 'hour': data[1]};
  }

  int getStart() {
    DateTime currentTime = DateTime.now();

    // Find the index of the current time in the hourData list
    int startIndex = hourData.hourly!.time.indexWhere((time) {
      DateTime hourTime = DateTime.parse(time);
      return hourTime.isAfter(currentTime) ||
          hourTime.isAtSameMomentAs(currentTime);
    });

    // If no exact match for current hour, start from the next available hour
    if (startIndex == -1) startIndex = 0;

    return startIndex;
  }

  String getWeatherIcon({
    required int weatherCode,
  }) {
    late final String weatherCondition;

    if (weatherCode == 801) {
      weatherCondition = 'assets/icons/02d.png';
    } else if (weatherCode == 802) {
      weatherCondition = 'assets/icons/03d.png';
    } else if (weatherCode == 803) {
      weatherCondition = 'assets/icons/04d.png';
    } else if (weatherCode == 804) {
      weatherCondition = 'assets/icons/04d.png';
    } else if (weatherCode == 800) {
      weatherCondition = 'assets/icons/01d.png';
    } else if (weatherCode > 700) {
      weatherCondition = 'assets/icons/50d.png';
    } else if (weatherCode >= 600) {
      weatherCondition = 'assets/icons/13d.png';
    } else if (weatherCode >= 500) {
      weatherCondition = 'assets/icons/10d.png';
    } else if (weatherCode >= 300) {
      weatherCondition = 'assets/icons/09d.png';
    } else if (weatherCode >= 200) {
      weatherCondition = 'assets/icons/11d.png';
    }

    return weatherCondition;
  }
}
