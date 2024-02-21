import 'dart:convert';

import 'curso_model.dart';

class MotivosReporte {
  
  List<GrupoReporte> motivos = [];
  Map<String, GrupoReporte> tipoReporteMap = {};

  MotivosReporte();

  MotivosReporte.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final grupoReporte = GrupoReporte.fromJsonMap(item);
      motivos.add(grupoReporte);
      tipoReporteMap[grupoReporte.descripcion] = grupoReporte;
    }
  }

  Map<String, dynamic> toJson() => {
    'motivos': jsonEncode(motivos),
  };

  MotivosReporte.vacio() {
    motivos = [];
  }

}

class GrupoReporte {
  late String id;
  late String descripcion;
  List<TipoReporte> tipos =[];

  GrupoReporte({
    required this.id,
    required this.descripcion,
  });

  GrupoReporte.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    descripcion = json['descripcion'];
    for (var item in json['respuestas']) {
      final tipo = TipoReporte.fromJsonMap(item);
      tipos.add(tipo);
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'respuestas': jsonEncode(tipos),
    'descripcion': descripcion,
  };

}

class TipoReporte {
  late String id;
  late String descripcion;

  TipoReporte({
    required this.id,
    required this.descripcion,
  });

  TipoReporte.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    descripcion = json['descripcion'].trim();
  }

}

