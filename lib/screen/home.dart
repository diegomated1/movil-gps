import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home>{

  Future<String> obtenerGps() async {
    bool bGpsHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!bGpsHabilitado) {
      return Future.error('Por favor habilite el servicio de ubicación.');
    }
    LocationPermission bGpsPermiso = await Geolocator.checkPermission();
    if (bGpsPermiso == LocationPermission.denied) {
      bGpsPermiso = await Geolocator.requestPermission();
      if (bGpsPermiso == LocationPermission.denied) {
        return Future.error('Se denegó el permiso para obtener la ubicación.');
      }
    }
    if (bGpsPermiso == LocationPermission.deniedForever) {
      return Future.error(
          'Se denegó el permiso para obtener la ubicación de forma permanente.');
    }
    var data = await Geolocator.getCurrentPosition();
    return 'http://www.google.com/maps/place/${data.latitude},${data.longitude}';
  }

  Future<void> abrirUrl() async {
    final url = await obtenerGps();
    final Uri oUri = Uri.parse(url);
    try {
      await launchUrl(
          oUri,
          mode: LaunchMode.externalApplication);
    } catch (oError) {
      print(oError);
      return Future.error('No fue posible abrir la url: $url.');
    }
  }

  @override
  void initState() {
    super.initState();
    abrirUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: obtenerGps(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Text(snapshot.data!);
            }else{
              return const Text('a');
            }
          },
        )
      ),
    );
  }
}


