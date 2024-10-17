import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather/config/app_routes.dart';
import 'package:weather/presentation/home/model/home_model.dart';
import 'package:http/http.dart' as http;
import 'package:weather/presentation/home/model/hourly_model.dart';

import '../../../services/loction.dart';

class HomeController extends GetxController {
  WeatherData weatherData = WeatherData();
  HourData hourData = HourData();
  var selectedUnit = 'Celsius'.obs;

  dynamic lat;
  dynamic lon;
  Future<void> fetchData() async {
    try {
      Position position = await getFormattedPosition();
      lat = position.latitude.toDouble();
      lon = position.longitude.toDouble();
      print("lat =$lat ,lon= $lon");
    } catch (e) {
      print(e);
    }
  }

  Future getWeatherData() async {
    try {
      var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=f4f8c17a28834dc12689b7bb28fc68e0'),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseJson = jsonDecode(await response.stream.bytesToString());
        weatherData = WeatherData.fromJson(responseJson);
        update();
        return responseJson;
      } else {
        print("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print(e);
    }
  }

  void weekNav() {
    Get.toNamed(AppRoutes.week, arguments: selectedUnit.value)?.then((result) {
      if (result != null) {
        selectedUnit.value = result;
      }
    });
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

    if (selectedUnit == 'Celsius') {
      double celsius = temp - 273.15;
      return '${celsius.toStringAsFixed(1)} °C';
    }
    double fer = (temp - 273.15) * 9 / 5 + 32;
    return '${fer.toStringAsFixed(1)} °F';
  }

  Future getHourWeatherData() async {
    try {
      var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&hourly=temperature_2m,relative_humidity_2m&temperature_unit=fahrenheit&timezone=GMT&forecast_days=3'),
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

  void changeUnit(String unit) {
    selectedUnit.value = unit;
  }

  String getHourTemperature(double? temp, String selectedUnit) {
    if (temp == null) return '-';

    if (selectedUnit == 'Celsius') {
      double celsius = (temp - 32) * (5 / 9);
      return '${celsius.toStringAsFixed(1)} °C';
    }

    return '${temp.toStringAsFixed(1)} °F';
  }

  Future getTheData() async {
    List data = [];
    await fetchData();
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
