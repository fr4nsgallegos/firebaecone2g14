import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  int id;
  String name;
  String services;
  LatLng position;
  String urlImage;

  PlaceModel({
    required this.id,
    required this.name,
    required this.services,
    required this.position,
    required this.urlImage,
  });
}

List<PlaceModel> places = [
  PlaceModel(
    id: 1,
    name: "barrio costero de Miraflores",
    services:
        "Sal a explorar el hermoso barrio de Miraflores en bicicleta por Lima con la familia",
    position: LatLng(-12.072928431383135, -77.07159367664602),
    urlImage:
        "https://cdn.bfldr.com/UTM69Z3S/at/4k3z8zhzkqvvvct9p74r439/alvaro-palacios-8wGaKutI3IQ-unsplash_-_LOWRES.jpg?disable=upscale&auto=webp&quality=60&format=pjpg&crop=1920%3A1080%2Csmart&width=1920&height=1080",
  ),

  PlaceModel(
    id: 2,
    name: "clase de cocina peruana",
    services: "siéntate con toda la familia a un delicioso festín peruano",
    position: LatLng(-12.07297370771825, -77.07222051289722),
    urlImage:
        "https://cdn.bfldr.com/UTM69Z3S/at/j5mq3rq4k9pttn9sk9rx9w/apardavila_30679745460_76389cff66_o_-_LOWRES.jpg?disable=upscale&auto=webp&quality=60&format=pjpg&crop=1920%3A1080%2Csmart&width=1920&height=1080",
  ),
  PlaceModel(
    id: 3,
    name: "Circuito Mágico del Agua",
    services: "Uno de los mejores parques que visitar en Lima",
    position: LatLng(-12.073605834213124, -77.07161682684847),
    urlImage:
        "https://cdn.bfldr.com/UTM69Z3S/at/vst89m7s7z37sq53k59q6hkg/Avodrocc_Lima__Peru_-_Parque_de_la_Reserva_Park_of_the_Reserve_07_-_LOWRES.jpg?disable=upscale&auto=webp&quality=60&format=pjpg&crop=1920%3A1080%2Csmart&width=1920&height=1080",
  ),
];
