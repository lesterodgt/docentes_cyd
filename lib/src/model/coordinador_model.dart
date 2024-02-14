
class Coordinadors {
  
  List<Coordinador> coordinadores = [];

  Coordinadors();

  Coordinadors.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final coordinadorItem = Coordinador.fromJsonMap(item);
      coordinadores.add(coordinadorItem);
    }
  }
}

class Coordinador {
  late String id;
  late String nombre;
  late String email;

  Coordinador({
    required this.id,
    required this.nombre,
    required this.email,
  });

  Coordinador.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    email = json['email'];
  }

  Map toJson() => {
    'id': id
  };
  
}
