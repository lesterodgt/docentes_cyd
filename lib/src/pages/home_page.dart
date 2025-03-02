import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

import '../utils/constantes.dart';
import '../utils/preferencias_usuario.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blueAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              _logoCYD(),
              const SizedBox(height: 8),
              _perfilUsuario(),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //_menuItem(context, 'Reservas', 'assets/imagenes/reservas.png', 'reservas'),
                      //const SizedBox(height: 20),
                      _menuItem(context, 'Reportes', 'assets/imagenes/reportes.png', 'reporte', Colors.blue),
                    ],
                  ),
                ),
              ),
              _footerImagen(),
              const SizedBox(height: 20),
              _botonCerrarSesion(context),
              const SizedBox(height: 10),
              Text("Versión $VERSION",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoCYD() {
    return Image.asset(
      'assets/imagenes/logo_cyd.png',
      height: 150,
    );
  }

  Widget _perfilUsuario() {
    final datosUsuario = PreferenciasUsuario().datosUsuario();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Row(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Image.asset('assets/imagenes/pizarra.png', height: 50),
              SizedBox(height: 40),
            ],
          ),
          Image.asset('assets/imagenes/docente.png', height: 70),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              datosUsuario.nombre,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(BuildContext context, String titulo, String imagePath, String route, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 65),
            const SizedBox(width: 15),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _footerImagen() {
    return Image.asset('assets/imagenes/footer.png', height: 70);
  }

  Widget _botonCerrarSesion(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.logout, size: 25, color: Colors.white),
      onPressed: () {
        Navigator.pushNamed(context, "login");
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      label: const Text(
        "Cerrar sesión",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
