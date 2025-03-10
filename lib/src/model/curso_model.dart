
class Cursos {
  
  List<Curso> cursos = [];

  Cursos();

  Cursos.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final cursoItem = Curso.fromJsonMap(item);
      cursos.add(cursoItem);
    }
  }
}

class Curso {
  late String id;
  late String nombre;

  Curso({
    required this.id,
    required this.nombre,
  });

  Curso.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'].toString();
    nombre = json['nombre'].trim();
  }

  Map toJson() => {
    'id': id
  };
  
}
