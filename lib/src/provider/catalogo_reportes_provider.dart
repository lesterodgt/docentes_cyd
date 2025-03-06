import '../model/estado_provider.dart';
import '../model/motivo_reporte_model.dart';
import '../provider/post_provider.dart';
import 'package:flutter/material.dart';

import '../model/provider_model.dart';
import '../utils/constantes.dart';
import '../utils/preferencias_usuario.dart';

class CatalogoReportesProvider extends ChangeNotifier with ProviderModel {
  final cliente = ClienteHTTP();
  List<GrupoReporte> motivosReporte = [];
  Map<String, GrupoReporte> tipoReporteMap = {};

  CatalogoReportesProvider() {
    if (motivosReporte.isEmpty) {
      cargarDatos();
    }
  }

  Future cargarDatos() async {
    setEstado(EstadoProvider.loading);
    motivosReporte = [];

    try {
      final datosUsuario = PreferenciasUsuario().datosUsuario();
      var map = <String, dynamic>{};
      map['accion'] = 'tiporespuestas';
      map['idusuario'] = datosUsuario.idusuario;
      final decodeData = await cliente.getPost(map, urlServicio);
      if (decodeData["resultado"]) {
        MotivosReporte motivos =
            MotivosReporte.fromJsonList(decodeData["tiporespuestas"]);
        motivosReporte = motivos.motivos;
        tipoReporteMap = motivos.tipoReporteMap;
      }
    } on Failure catch (f) {
      setFailure(f);
    }
    setEstado(EstadoProvider.loaded);
  }

  void actualizar() {
    notifyListeners();
  }
}
