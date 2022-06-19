import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Additional extends StatelessWidget {
  final String text;
  final IconData icon;

  Additional({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            color: Colors.black,
            size: 30,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            text,
            style: GoogleFonts.quicksand(
              color: Colors.black,
              fontSize: 17,
            ),
          )
        ],
      ),
    );
  }
}
