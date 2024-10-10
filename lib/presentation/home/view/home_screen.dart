import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather/presentation/home/controller/home_controller.dart';

import '../../../widget/gradientText.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());

  String selectedUnit = 'Celsius';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: homeController.getTheData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text(snapshot.error.toString()),
              ),
            );
          } else {
            return Scaffold(
              body: Container(
                height: context.height,
                width: context.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      const Color(0xFFFFA500),
                      const Color(0xFF8A2BE2).withOpacity(0.7),
                      const Color(0xFF000000),
                    ])),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                                style: GoogleFonts.openSans(height: 1.1),
                                children: <TextSpan>[
                                  //time
                                  TextSpan(
                                    text: "GMT",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFFFFFF)
                                            .withOpacity(0.7)),
                                  ),
                                ]),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.thermostat_outlined,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            onSelected: (String result) {
                              setState(() {
                                selectedUnit = result;
                              });
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: 'Celsius',
                                child: Text('Celsius'),
                              ),
                              const PopupMenuItem(
                                value: 'Fahrenheit',
                                child: Text('Fahrenheit'),
                              ),
                            ],
                          ),

                          // icon of weather
                          GestureDetector(
                            onTap: () {
                              homeController.weekNav(selectedUnit);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2.0),
                              height: 40.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                border:
                                    Border.all(width: 0.4, color: Colors.white),
                              ),
                              child: const Icon(
                                Icons.more_vert_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // insert image
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://openweathermap.org/img/wn/${homeController.weatherData.weather?[0].icon}@2x.png'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.openSans(height: 1.2),
                            children: <TextSpan>[
                              //temperature
                              TextSpan(
                                text:
                                    "${homeController.getTemperature(homeController.weatherData.main?.temp, selectedUnit)}\n",
                                style: TextStyle(
                                    fontSize: 75.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFFFFF)),
                              ),

                              // humidity

                              TextSpan(
                                text:
                                    '${homeController.weatherData.main?.humidity} % \n',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFFFFF)),
                              ),
                              // date and time
                              TextSpan(
                                text:
                                    '${homeController.getFormattedDate(homeController.weatherData.dt!)}.\n',
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFFFFFF)
                                        .withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // hourly forecast
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            gradientText(
                                "Hourly forecast", 20.0, FontWeight.bold),
                            Container(
                              padding: const EdgeInsets.all(2.0),
                              height: 30.0,
                              width: 30.0,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(100.0)),
                              child: const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: Color(0xFF000000),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(0.0),
                          itemCount: 24, // Display only next 24 hours
                          itemBuilder: (context, index) {
                            int i = homeController.getStart();
                            int start = i + index;

                            return Container(
                              padding: EdgeInsets.only(bottom: 12.0, top: 5.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 0.4,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('h a').format(DateTime.parse(
                                        homeController.hourData.hourly!.time[
                                            start])), // Show the time formatted as '8 AM', '9 AM', etc.
                                    style: GoogleFonts.openSans(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFFFFFFF),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Humidity',
                                        style: GoogleFonts.openSans(
                                          fontSize: 15.0,
                                          color: const Color(0xFFFFFFFF)
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                      Text(
                                        '${homeController.hourData.hourly!.relativeHumidity_2m[start]} %',
                                        style: GoogleFonts.openSans(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${homeController.getHourTemperature(homeController.hourData.hourly!.temperature_2m[start], selectedUnit)}', // Display the temperature
                                    style: GoogleFonts.openSans(
                                      fontSize: 45.0,
                                      color: const Color(0xFFFFFFFF)
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
