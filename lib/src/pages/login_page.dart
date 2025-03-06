import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../provider/login_provider.dart';
import '../utils/constantes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imagenLogin),
            fit: BoxFit.cover,
          ),
        ),
      ),
      ListView(
        primary: true,
        children: <Widget>[
          const SizedBox(height: 300.0),
          _loginForm(context),
        ],
      ),
    ])));
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loginProvider = Provider.of<LoginProvider>(context);
    return Form(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 5.0,
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            width: size.width * 0.85,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 10.0),
                  Text("Versión $VERSION"),
                  const SizedBox(height: 10.0),
                  _crearUsuario(loginProvider, context),
                  const SizedBox(height: 20.0),
                  _crearPassword(loginProvider, context),
                  const SizedBox(height: 20.0),
                  _crearBoton(context),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Container(
              height: 5.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearUsuario(LoginProvider loginProvider, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        style: const TextStyle(color: Colors.green, fontSize: 20),
        decoration: const InputDecoration(
          labelText: "Usuario",
          icon: Icon(Icons.account_circle),
          fillColor: Colors.white,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.amber),
          ),
        ),
        onChanged: (String value) {
          loginProvider.changeUsuario(value);
        },
      ),
    );
  }

  Widget _crearPassword(LoginProvider loginProvider, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        style: const TextStyle(color: Colors.green, fontSize: 20),
        obscureText: !loginProvider.mostrarContrasenia,
        decoration: const InputDecoration(
          icon: Icon(Icons.lock_open),
          labelText: "Contraseña",
          fillColor: Colors.white,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.amber),
          ),
        ),
        onChanged: (String value) {
          loginProvider.changeContrasenia(value);
        },
      ),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 15.0),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
        ),
        onPressed: () async {
          final loginProvider =
              Provider.of<LoginProvider>(context, listen: false);
          List resultado = await loginProvider.login();
          if (resultado[0]) {
            Toast.show(resultado[1] + "....",
                duration: Toast.lengthLong, gravity: Toast.center);
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, 'home');
          } else {
            Toast.show(resultado[1],
                duration: Toast.lengthLong, gravity: Toast.center);
          }
        },
        child: const Text('INICIAR'),
      ),
    );
  }
}
