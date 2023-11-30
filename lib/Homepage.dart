import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worldflags/model/country_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<country>> getdata() async {
    const Url = "https://countriesnow.space/api/v0.1/countries/flag/images";

    var response = await http.get(Uri.parse(Url));

    var jsondata = json.decode(response.body);

    var jsonarrey = jsondata['data'];
    List<country> Countries = [];

    for (var jsoncountry in jsonarrey) {
      country Country =
          country(name: jsoncountry['name'], flag: jsoncountry['flag']);
      Countries.add(Country);
    }
    return Countries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "World",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            Text(
              "Flags🌎",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                  future: getdata(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator()),
                      );
                    } else {
                      List<country> countress = snapshot.data!;
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: countress.length,
                          itemBuilder: (context, index) {
                            country Country = countress[index];
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Card(
                                elevation: 50,
                                shadowColor: Colors.black,
                                color: Color.fromARGB(33, 0, 103, 92),
                                child: SizedBox(
                                  height: 300,
                                  width: 500,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Text('🌎 ${Country.name}',
                                            style: GoogleFonts.permanentMarker(
                                                fontStyle: FontStyle.normal,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 15),
                                        Expanded(
                                          child: SvgPicture.network(
                                            Country.flag,
                                            height: 200,
                                            width: 400,
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                  }))
        ],
      ),
    );
  }
}
