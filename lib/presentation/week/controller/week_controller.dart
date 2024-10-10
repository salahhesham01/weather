import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather/presentation/week/model/week_model.dart';

import '../../../config/app_routes.dart';
import 'package:http/http.dart' as http;

class WeekController extends GetxController {
  WeekData weekHourWeatherData = WeekData();

  void homeNav() {
    Get.offAllNamed(AppRoutes.home);
  }

  Future getWeatherWeekData() async {
    try {
      // print("$lat : $lon");
      var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.open-meteo.com/v1/forecast?current=&daily=temperature_2m_max&temperature_unit=fahrenheit&timezone=auto&latitude=29.9008&longitude=31.171794'),
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

    // Parse the string to a DateTime object
    DateTime date = DateTime.parse(dateString);

    // Get the day name using DateFormat
    return DateFormat('EEEE')
        .format(date); // EEEE gives full day name, E for short
  }
}
