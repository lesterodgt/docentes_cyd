import 'package:flutter/material.dart';

class Loading{

  showAlertDialog(BuildContext context, String texto){
    AlertDialog alert=AlertDialog(
      content: Row(
          children: [
              const CircularProgressIndicator(),
              Container(margin: const EdgeInsets.only(left: 5),child:Text(texto )),
          ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
}