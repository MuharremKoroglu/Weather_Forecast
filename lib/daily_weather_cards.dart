import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyWeather extends StatelessWidget {
  final String image;
  final String date;
  final String temp;

  const DailyWeather({
    required this.date,
    required this.image,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    String weekday = weekdays[DateTime.parse(date).weekday - 1];

    return Container(
      height: 150,
      width: 150,
      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://openweathermap.org/img/wn/$image@2x.png',
                  ),
                ),
              ),
            ),
            Text(
              weekday,
              style: GoogleFonts.quicksand(
                color: Colors.black,
                fontSize: 25,
              ),
            ),
            Text(
              '$temp°C',
              style: GoogleFonts.quicksand(
                color: Colors.black,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
