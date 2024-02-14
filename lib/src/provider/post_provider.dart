import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ClienteHTTP {
  static final ClienteHTTP _singleton = ClienteHTTP._internal();

  factory ClienteHTTP() {
    return _singleton;
  }

  ClienteHTTP._internal();
  
  Future<dynamic> getPost(Map<String, dynamic> parametros, String url) async {
    try {
      final http.Response respuesta = await http.post(
        Uri.parse(url),
        body: parametros,
      );
      if (respuesta.statusCode == 200) {
        return json.decode(respuesta.body);
      } else if (respuesta.statusCode == 404) {
        throw Failure(3,
            "No pudimos comunicarnos, verifica que tu app esta actualizada 🙇");
      } else {
        throw Failure(3,
            "Nuestros servidores no respondieron bien, intenta más tarde 🙇");
      }
    } on SocketException {
      throw Failure(1, 'No pudimos conectarnos, verifica tu conexión 😩');
    } on HttpException {
      throw Failure(2, "No hemos podido encontrar información 😱");
    } on FormatException {
      throw Failure(
          3, "Nuestros servidores no respondieron bien, intenta más tarde 🙇");
    } on Exception catch (e) {
      throw Failure(1, 'Ha ocurrido un problema, intenta mas tarde 😩 $e');
    }
  }
}

class Failure {
  final String message;
  final int codigo;
  Failure(this.codigo, this.message);
  @override
  String toString() => message;
}
