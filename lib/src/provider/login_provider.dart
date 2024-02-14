import 'dart:convert';
import 'package:flutter/material.dart';

import '../model/usuario.dart';

import '../model/validador_item.dart';
import '../utils/constantes.dart';
import '../utils/preferencias_usuario.dart';
import '/src/provider/post_provider.dart';

class LoginProvider extends ChangeNotifier {
  final cliente = ClienteHTTP();

  ValidadorItem _usuario = ValidadorItem('', '');
  ValidadorItem _contrasenia = ValidadorItem('', '');
  ValidadorItem _contrasenia2 = ValidadorItem('', '');
  bool _mostrarContrasenia = false;
  late Usuario usuarioDatos;

  LoginProvider() {
    final datosUsuario = PreferenciasUsuario();
    if (datosUsuario.usuario != "") {
      usuarioDatos = Usuario.fromJsonMap(json.decode(datosUsuario.usuario));
    }
  }
  
  ValidadorItem get usuario => _usuario;
  ValidadorItem get contrasenia => _contrasenia;
  ValidadorItem get contrasenia2 => _contrasenia2;
  bool get mostrarContrasenia => _mostrarContrasenia;

  bool get sonClavesIguales {
    if (_contrasenia.value == _contrasenia2.value) {
      return true;
    }
    return false;
  }

  void changeMostrarContrasenia() {
    _mostrarContrasenia = !_mostrarContrasenia;
    notifyListeners();
  }

  void changeUsuario(String value) {
    _usuario = ValidadorItem(value, '');
  }

  void changeContrasenia(String value) {
    _contrasenia = ValidadorItem(value, '');
  }

  void changeContrasenia2(String value) {
    _contrasenia2 = ValidadorItem(value, '');
    notifyListeners();
  }

  Future<List> login() async {
    var map = <String, dynamic>{};
    map['accion'] = 'login';
    map['usuario'] = _usuario.value;
    map['clave'] = _contrasenia.value;
    
    try {
      
      final decodeData = await cliente.getPost(map, urlServicio);
      if (decodeData["resultado"]) {
        final usuarioDatosLogin = Usuario.fromJsonMap(decodeData['usuario']);
        final preferencias = PreferenciasUsuario();
        preferencias.usuario = jsonEncode(usuarioDatosLogin);
        return [true, decodeData["mensaje"]];
      } else {
        return [false, decodeData["mensaje"]];
      }
    } on Failure catch (f) {
      return [false, f.message];
    }
  }

  Future cerrarSesion() async {
    final usuarioDatosLogin = Usuario.vacio();
    final preferencias = PreferenciasUsuario();
    preferencias.usuario = jsonEncode(usuarioDatosLogin);
  }

  
}
