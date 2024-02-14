import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/usuario.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (err) {
      // ignore: invalid_use_of_visible_for_testing_member
      SharedPreferences.setMockInitialValues({});
      // ignore: no_leading_underscores_for_local_identifiers
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      this._prefs = await _prefs;
      this._prefs.setString("usuario", jsonEncode(Usuario.vacio()));
    }
  }

  Usuario datosUsuario() {
    return Usuario.fromJsonMap(json.decode(usuario));
  }

  // GET y SET del alumno
  String get usuario {
    return _prefs.getString('usuario') ?? jsonEncode(Usuario.vacio());
  }

  set usuario(String value) {
    _prefs.setString('usuario', value);
  }

}
