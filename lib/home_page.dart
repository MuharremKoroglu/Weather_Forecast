import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/search_page.dart';
import 'additional.dart';
import 'daily_weather_cards.dart';
import 'search_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var temperature;
  var locationName;
  var windSpeed;
  var humidity;
  var pressure;
  var cityId;
  var locationData;
  var backgroundImage;
  var locationLatLong;
  List dailyCardTemps = List.filled(5, null, growable: false);
  List dailyCardIcons = List.filled(5, null, growable: false);
  List dailyCardDates = List.filled(5, null, growable: false);

  Future<void> getDeviceLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    try {
      _locationData = await location.getLocation();
      setState(() {
        locationLatLong = _locationData;
      });
    } catch (error) {
      print('Error : $error');
    }
  }

  Future<void> getLocationDataLatLong() async {
    locationData = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${locationLatLong.latitude}&lon=${locationLatLong.longitude}&appid=3906a4866955cf4adc5c1e3a08fce93f'),
    );

    locationName = jsonDecode(locationData.body)['name'];
  }

  Future<void> getTemperature() async {
    var response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?id=$cityId&appid=3906a4866955cf4adc5c1e3a08fce93f&units=metric'),
    );

    setState(() {
      temperature = jsonDecode(response.body)['main']['temp'].round();
    });
  }

  Future<void> getLocationData() async {
    locationData = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$locationName&appid=3906a4866955cf4adc5c1e3a08fce93f'),
    );
    cityId = jsonDecode(locationData.body)['id'];
  }

  Future<void> getDailyCardTemps() async {
    var response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$locationName&appid=3906a4866955cf4adc5c1e3a08fce93f&units=metric'),
    );

    for (int i = 0; i < dailyCardTemps.length; i++) {
      dailyCardTemps[i] =
          jsonDecode(response.body)['list'][8 * i + 7]['main']['temp'].round();
      dailyCardIcons[i] =
          jsonDecode(response.body)['list'][8 * i + 7]['weather'][0]['icon'];
      dailyCardDates[i] =
          jsonDecode(response.body)['list'][8 * i + 7]['dt_txt'];
    }
  }

  Future<void> getWindSpeed() async {
    var response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$locationName&appid=3906a4866955cf4adc5c1e3a08fce93f'),
    );
    windSpeed = jsonDecode(response.body)['wind']['speed'].round();
  }

  Future<void> getHumidity() async {
    var response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$locationName&appid=3906a4866955cf4adc5c1e3a08fce93f'),
    );
    humidity = jsonDecode(response.body)['main']['humidity'];
  }

  Future<void> getPressure() async {
    var response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$locationName&appid=3906a4866955cf4adc5c1e3a08fce93f'),
    );
    pressure = jsonDecode(response.body)['main']['pressure'];
  }

  Future<void> getAssets() async {
    var response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$locationName&appid=3906a4866955cf4adc5c1e3a08fce93f'),
    );
    setState(() {
      backgroundImage = jsonDecode(response.body)['weather'][0]['icon'];
    });
  }

  void getAsyncFromSearchPage() async {
    await getLocationData();
    await getWindSpeed();
    await getHumidity();
    await getPressure();
    await getAssets();
    await getDailyCardTemps();
    getTemperature();
  }

  void getAsyncFunc() async {
    await getDeviceLocation();
    await getLocationDataLatLong();
    await getLocationData();
    await getWindSpeed();
    await getHumidity();
    await getPressure();
    await getAssets();
    await getDailyCardTemps();
    getTemperature();
  }

  @override
  void initState() {
    getAsyncFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return temperature == null
        ? Center(
            child: SpinKitSpinningLines(
              color: Colors.white,
              size: 50,
            ),
          )
        : Scaffold(
            backgroundColor: Colors.grey[300],
            body: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/$backgroundImage.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(35),
                        bottomLeft: Radius.circular(35),
                      ),
                    ),
                    child: Stack(
                      children: [
                        AppBar(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          leading: IconButton(
                            onPressed: () async {
                              locationName = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchPage(),
                                ),
                              );
                              getAsyncFromSearchPage();
                              setState(() {
                                locationName = locationName;
                              });
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.magnifyingGlass,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0.0, 0.1),
                  child: SizedBox(
                    height: 10,
                    width: 10,
                    child: OverflowBox(
                      minWidth: 0.0,
                      maxWidth: MediaQuery.of(context).size.width,
                      minHeight: 0.0,
                      maxHeight: (MediaQuery.of(context).size.height / 3),
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            width: double.infinity,
                            height: double.infinity,
                            child: Card(
                              color: Colors.white,
                              elevation: 15,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      top: 15,
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'Today',
                                            style: GoogleFonts.quicksand(
                                              color: Colors.black,
                                              fontSize: 43,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              FittedBox(
                                                child: Text(
                                                  '${temperature}°C',
                                                  style: GoogleFonts.quicksand(
                                                    color: Colors.black,
                                                    fontSize: 65,
                                                  ),
                                                ),
                                                fit: BoxFit.fitWidth,
                                              ),
                                              SizedBox(
                                                width: 90,
                                              ),
                                              Container(
                                                width: 89,
                                                height: 89,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      'https://openweathermap.org/img/wn/$backgroundImage@2x.png',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.locationDot,
                                                color: Colors.black,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text(
                                                  locationName,
                                                  style: GoogleFonts.quicksand(
                                                    color: Colors.black,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 120.0,
                        ),
                        child: Container(
                          width: 370,
                          height: 100,
                          child: Card(
                            elevation: 15,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Additional(
                                    icon: FontAwesomeIcons.wind,
                                    text: '$windSpeed km/h',
                                  ),
                                  Additional(
                                    icon: FontAwesomeIcons.droplet,
                                    text: '$humidity %',
                                  ),
                                  Additional(
                                    icon: FontAwesomeIcons.gauge,
                                    text: '$pressure hPa',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                            child: Align(
                              child: Text(
                                'Next 5 Days',
                                style: GoogleFonts.quicksand(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              alignment: Alignment.topLeft,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 150,
                            padding: EdgeInsets.symmetric(
                              horizontal: 23,
                            ),
                            child: Theme(
                              data: ThemeData(
                                accentColor: Colors.transparent,
                              ),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  DailyWeather(
                                    date: dailyCardDates[0].toString(),
                                    image: dailyCardIcons[0].toString(),
                                    temp: dailyCardTemps[0].toString(),
                                  ),
                                  DailyWeather(
                                    date: dailyCardDates[1].toString(),
                                    image: dailyCardIcons[1].toString(),
                                    temp: dailyCardTemps[1].toString(),
                                  ),
                                  DailyWeather(
                                    date: dailyCardDates[2].toString(),
                                    image: dailyCardIcons[2].toString(),
                                    temp: dailyCardTemps[2].toString(),
                                  ),
                                  DailyWeather(
                                    date: dailyCardDates[3].toString(),
                                    image: dailyCardIcons[3].toString(),
                                    temp: dailyCardTemps[3].toString(),
                                  ),
                                  DailyWeather(
                                    date: dailyCardDates[4].toString(),
                                    image: dailyCardIcons[4].toString(),
                                    temp: dailyCardTemps[4].toString(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
