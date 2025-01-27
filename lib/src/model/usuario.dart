class Usuario {
  late String idusuario;
  late String usuario;
  late String nombre;
  late String idtipousuario;

  Usuario({
    required this.idusuario,
    required this.usuario,
    required this.nombre,
    required this.idtipousuario,
  });

  Usuario.fromJsonMap(Map<String, dynamic> json) {
    idusuario = json['idusuario'].toString();
    usuario = json['usuario'];
    nombre = json['nombre'];
    idtipousuario = json['idtipousuario'].toString();
  }

  Map<String, dynamic> toJson() => {
    'idusuario': idusuario,
    'usuario': usuario,
    'nombre': nombre ,
    'idtipousuario': idtipousuario ,
  };

  Usuario.vacio() {
    idusuario = "";
    usuario = "";
    nombre = "";
    idtipousuario = "";
  }
}
