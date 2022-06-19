import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var selectedCity;
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            'assets/images/search.png',
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(38.0),
                child: TextField(
                  controller: myController,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  decoration: InputDecoration(
                    suffix: FaIcon(FontAwesomeIcons.magnifyingGlass,
                        color: Colors.white),
                    hintText: 'Location Name'.toUpperCase(),
                    hintStyle: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  var response = await http.get(
                    Uri.parse(
                        'https://api.openweathermap.org/data/2.5/weather?q=${myController.text}&appid=3906a4866955cf4adc5c1e3a08fce93f'),
                  );
                  jsonDecode(response.body)['cod'] == '404'
                      ? AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'Error',
                          desc:
                              'The city you are looking for was not found. Please try again.',
                          btnCancelOnPress: () {},
                        ).show()
                      : Navigator.pop(context, myController.text);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(width: 3.0, color: Colors.white),
                ),
                child: Text(
                  'Search',
                  style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
