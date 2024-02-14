class Grados {
  List<Grado> grados = [];

  Grados();

  Grados.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final grado = Grado.fromJsonMap(item);
      grados.add(grado);
    }
  }
}

class Grado {
  late String id;
  late String nombre;
  late String plandiario;

  Grado({
    required this.id,
    required this.nombre,
    required this.plandiario,
  });

  Grado.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    plandiario = json['plandiario'];
  }
}
