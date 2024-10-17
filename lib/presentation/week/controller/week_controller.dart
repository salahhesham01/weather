import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather/presentation/week/model/week_model.dart';

import 'package:http/http.dart' as http;

import '../../../services/loction.dart';

class WeekController extends GetxController {
  WeekData weekHourWeatherData = WeekData();
  RxString selectedUnit = ''.obs; // RxString for reactivity

  @override
  void onInit() {
    super.onInit();
    // Ensure you're receiving the string value
    selectedUnit.value =
        Get.arguments ?? 'Celsius'; // Fallback to Celsius if no argument
  }

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

  void homeNav() {
    Get.back(result: selectedUnit.value); // Return the actual string value
  }

  Future getWeatherWeekData() async {
    try {
      await fetchData();
      // print("$lat : $lon");
      var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.open-meteo.com/v1/forecast?current=&daily=temperature_2m_max&temperature_unit=fahrenheit&timezone=auto&latitude=${lat}&longitude=${lon}'),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("Week DATA RETRIEVED SUCCESSFULLY");
        var responseJson = jsonDecode(await response.stream.bytesToString());
        weekHourWeatherData = WeekData.fromJson(responseJson);
        update();

        print("Data Passed to model");

        return responseJson;
      } else {
        print(
            "error : ${response.reasonPhrase} \n ${await response.stream.bytesToString()}");
      }
    } catch (e) {
      print(e);
    }
  }

  String getDayName(String? dateString) {
    if (dateString == null) return '';

    DateTime date = DateTime.parse(dateString);

    return DateFormat('EEEE').format(date);
  }
}
