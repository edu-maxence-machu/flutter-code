import 'package:flutter/material.dart';
import 'package:meteo_app/api/api_geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  String key = "villes";
  List<String> villes = [];
  String? villeChoisie;

  @override
  void initState() {
    obtenir();
    super.initState();
  }

  void ajouter(String value) async {
    if (villes.contains(value)) {
      // Eviter les doublons
      return;
    }
    villes.add(value);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, villes);
    obtenir();
  }

  void supprimer(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    villes.remove(value);
    await prefs.setStringList(key, villes);
    obtenir();
  }

  void obtenir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? liste = prefs.getStringList("villes");
    if (liste != null) {
      setState(() {
        villes = liste;
      });
    }
    print(liste);
    print('Obtenir les villes en SharedPreferences');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                ),
                child: Text('Ajouter une ville'),
                onPressed: () {
                  print('Je clique et j\'ajoute');
                  ajouter('Paris');
                })));
  }
}
