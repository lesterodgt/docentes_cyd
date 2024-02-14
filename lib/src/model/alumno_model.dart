
class Alumnos {
  
  List<Alumno> alumnosTodos = [];

  Alumnos();

  Alumnos.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final alumno = Alumno.fromJsonMap(item);
      alumnosTodos.add(alumno);
    }
  }
}

class Alumno {
  late String idalumno;
  late String nombreAlumno;
  late String plandiario;
  late String estado;
  late String descripcionestado;
  late bool marcado = false;

  Alumno({
    required this.idalumno,
    required this.nombreAlumno,
    required this.plandiario,
    required this.estado,
    required this.descripcionestado
  });

  Alumno.fromJsonMap(Map<String, dynamic> json) {
    idalumno = json['idalumno'];
    nombreAlumno = json['nombreAlumno'];
    plandiario = json['plandiario']??'';
    estado = json['estado'];
    descripcionestado = json['descripcionestado'];
  }

  Map toJson() => {
    'idAlumno': idalumno
  };
  
}
