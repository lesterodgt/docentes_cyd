
class Periodos {
  
  List<Periodo> periodos = [];

  Periodos();

  Periodos.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final periodoItem = Periodo.fromJsonMap(item);
      periodos.add(periodoItem);
    }
  }
}

class Periodo {
  late String id;
  late String nombre;

  Periodo({
    required this.id,
    required this.nombre,
  });

  Periodo.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
  }

  Map toJson() => {
    'id': id
  };
  
}
