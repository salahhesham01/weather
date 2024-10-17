import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/presentation/week/controller/week_controller.dart';

import '../../home/controller/home_controller.dart';

class WeekScreen extends StatelessWidget {
  WeekScreen({super.key});
  WeekController weekController = Get.put(WeekController());
  final String selectedUnit = Get.arguments;
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: weekController.getWeatherWeekData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Container(
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
                      ],
                    ),
                  ),
                ),
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
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color(0xFF4B0082),
                      Color(0xFF9370DB),
                      Color(0xFF000000),
                    ])),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  weekController.homeNav();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2.0),
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  child: const Icon(
                                    Icons.keyboard_arrow_left_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Back',
                                  style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Color(0xFFFFFFFF)),
                                ),
                              ),
                            ],
                          ),
                          Container(
                              height: 50.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      homeController.getWeatherIcon(
                                          weatherCode: homeController
                                              .weatherData.weather![0].id)),
                                ),
                              ))
                        ],
                      ),

                      // row of calender of this week
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.calendar_month_outlined,
                                color: Colors.white, size: 30.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'This Week',
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0,
                                    color: const Color(0xFFFFFFFF)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: ListView.builder(
                            padding: const EdgeInsets.all(0.0),
                            itemCount: 7,
                            itemBuilder: (context, index) {
                              return Container(
                                padding:
                                    EdgeInsets.only(bottom: 12.0, top: 5.0),
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 0.4, color: Color(0xFFFFFFFF)),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //show day name and date
                                    Column(
                                      children: [
                                        Text(
                                          weekController.getDayName(
                                              weekController.weekHourWeatherData
                                                  .daily?.time[index]),
                                          style: GoogleFonts.openSans(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFFFFFFF),
                                          ),
                                        ),
                                        Text(
                                          '${weekController.weekHourWeatherData.daily?.time[index]}',
                                          style: GoogleFonts.openSans(
                                            fontSize: 20.0,
                                            // fontWeight: FontWeight.bold,
                                            color: const Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Text(
                                      //day temp with selected unit
                                      '${homeController.getHourTemperature(weekController.weekHourWeatherData.daily?.temperature_2mMax[index], selectedUnit)}',
                                      style: GoogleFonts.openSans(
                                        fontSize: 45.0,
                                        color: const Color(0xFFFFFFFF)
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
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
