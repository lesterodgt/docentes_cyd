import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../provider/catalogo_reportes_provider.dart';
import '../provider/grados_provider.dart';
import '../provider/login_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
 
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool cargado = false;

  @override
  Widget build(BuildContext context) {
    
    if(!cargado){
      Provider.of<CatalogoReportesProvider>(context);
      Provider.of<GradosProvider>(context);
      cargado = true;
    }
    ToastContext().init(context);
    
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        child: ListView(
          children: [
            menu("Reportes", Icons.report_gmailerrorred, 'reporte', Colors.blue[900]!),
            const SizedBox(height: 50),
            cerrarSesion()
          ],
        ),
      ),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0), // here the desired height
      child: AppBar(
        centerTitle: true,
        title: const Text("Docentes CYD"),
      ),
    );
  }

  Widget menu(nombre, IconData icono, ruta, Color color){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton.icon(
        icon: Icon(
          icono,
          size: 35,
          color: Colors.white,
        ),
        onPressed: () {
          //Provider.of<IngresoProvider>(context, listen: false).datos=null;
          Navigator.pushNamed(context, ruta);
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: color),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(nombre, style: const TextStyle(fontSize: 20)),
        )
      ),
    ); 
  }

  Widget cerrarSesion(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton.icon(
        icon: const Icon( Icons.logout, size: 35, color: Colors.white),
        onPressed: () {
          Provider.of<LoginProvider>(context, listen: false).cerrarSesion();
          Navigator.pushNamed(context, "login");
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red),
        label: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Text("Cerrar sesión", style: TextStyle(fontSize: 20)),
        )
      ),
    );
    
  }

}
