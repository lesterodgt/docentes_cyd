import 'dart:convert';

import '../model/alumno_model.dart';
import '../model/usuario.dart';
import '../provider/post_provider.dart';
import 'package:flutter/material.dart';

import '../model/provider_model.dart';
import '../utils/preferencias_usuario.dart';

class ReportesProvider extends ChangeNotifier with ProviderModel {
  final cliente = ClienteHTTP();

  Future<bool> enviarReporte(List<Alumno> alumnosEnviar, String idcurso, String bimestre, 
    String observacion, String idtipotarea
  ) async {
    
    const url = "https://sistemaestecapc.com/ws_asistencia.php";
    try {
      final preferencias = PreferenciasUsuario();
      Usuario usuario = preferencias.datosUsuario();
      debugPrint(jsonEncode(alumnosEnviar));
      var map = <String, dynamic>{};
      map['accion'] = 'crearreporte';
      map['alumnos'] = jsonEncode(alumnosEnviar);
      map['idcurso'] = idcurso;
      map['bimestre'] = bimestre;
      map['observacion'] = observacion;
      map['idusuario'] = usuario.idusuario;
      map['nusuario'] = usuario.nombre;
      map['idtipotarea'] = idtipotarea;

      final decodeData = await cliente.getPost(map, url);
      debugPrint(decodeData["mensaje"]);
       return decodeData["resultado"];
    } on Failure {
      return false;
    }
  }

}
