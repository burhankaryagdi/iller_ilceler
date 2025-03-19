import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iller_ilceler/il.dart';
import 'package:iller_ilceler/ilce.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Il> iller = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _jsonCozumle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İller ve İlçeler', style: TextStyle(fontSize: 30)),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: iller.length,
        itemBuilder: _listeOgesiniOlustur,
      ),
    );
  }

  Widget _listeOgesiniOlustur(BuildContext context, int index) {
    return Card(
      child: ExpansionTile(
        title: Text(iller[index].isim, style: TextStyle(fontSize: 24)),
        leading: Icon(Icons.location_city),
        trailing: Text(iller[index].plakaKodu),
        children:
            iller[index].ilceler.map((ilce) {
              return ListTile(title: Text(ilce.isim));
            }).toList(),
      ),
    );
  }

  void _jsonCozumle() async {
    String jsonString = await rootBundle.loadString(
      "assets/iller_ilceler.json",
    );
    Map<String, dynamic> illerMap = json.decode(jsonString);

    for (String plakaKodu in illerMap.keys) {
      Map<String, dynamic> ilMap = illerMap[plakaKodu];
      String ilIsmi = ilMap['name'];
      Map<String, dynamic> ilcelerMap = ilMap['districts'];

      List<Ilce> tumIlceler = [];

      for (String ilceKodu in ilcelerMap.keys) {
        Map<String, dynamic> ilceMap = ilcelerMap[ilceKodu];
        String ilceIsmi = ilceMap['name'];
        Ilce ilce = Ilce(ilceIsmi);
        tumIlceler.add(ilce);
      }
      Il il = Il(ilIsmi, plakaKodu, tumIlceler);
      iller.add(il);
    }
    setState(() {});
  }
}
