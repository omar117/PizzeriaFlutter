import 'package:flutter/material.dart';
import 'package:hungry/views/screens/page_switcher.dart';
import 'package:hungry/views/utils/AppColor.dart';
import 'package:hungry/views/widgets/custom_text_field.dart';
import 'package:hungry/views/widgets/modals/login_modal.dart';
import 'package:hungry/views/widgets/custom_alert_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class RegisterModal extends StatefulWidget {


  @override
  State<RegisterModal> createState() => _RegisterModalState();
}

class _RegisterModalState extends State<RegisterModal> {
  
  final nombre = CustomTextField(title: 'Nombre', hint: 'Juan',controller: TextEditingController());
  final apepat = CustomTextField(title: 'Apellido Paterno', hint: 'Perez',controller: TextEditingController());
  final apemat = CustomTextField(title: 'Apellido Materno', hint: 'Garcia',controller: TextEditingController());
  final cumple = CustomTextField(title: 'Cumpleaños', hint: '01-07-22',controller: TextEditingController());
  final telefono = CustomTextField(title: 'Telefono', hint: '4491234567',controller: TextEditingController());
  final correo = CustomTextField(title: 'Correo', hint: 'youremail@email.com',controller: TextEditingController());
  final contra = CustomTextField(title: 'Contraseña', hint: '**********', obsecureText: true, margin: EdgeInsets.only(top: 16),controller: TextEditingController());
  final calle = CustomTextField(title: 'Calle', hint: 'Av Aguascalientes',controller: TextEditingController());
  final num_int = CustomTextField(title: 'Num_int', hint: '17',controller: TextEditingController());
  final num_ext = CustomTextField(title: 'Num_ext', hint: '0',controller: TextEditingController());
  final colonia = CustomTextField(title: 'Colonia', hint: 'Carboneras',controller: TextEditingController());
  final estado = CustomTextField(title: 'Estado', hint: 'Aguascalientes',controller: TextEditingController());
  final cp = CustomTextField(title: 'Codigo Postal', hint: '20600',controller: TextEditingController());

  Future getFindCorreo(String correo) async {
  
    Map data = {
      "correo": "$correo",
    };

    Map dataResponse;

    //encode Map to JSON
    String body = json.encode(data);
    int status = 0;

    http.Response response = await http.post(Uri.parse('http://10.0.2.2:3000/api/authCliente/findCorreo'),
        headers: {"Content-Type": "application/json"},
        body: body
    );

    status = response.statusCode;
    if (status < 200 || status >= 400 || json == null) {
      //Error 
      return "null";
    }

    dataResponse = jsonDecode(response.body);
    return dataResponse['existe'].toString();
  }

  Future postClienteSingUp(String nombre,String apepat, String apemat,String cumple,String telefono,String correo,String contra,String calle,String num_ext,String num_int,String colonia,String estado,String cp) async {

    Map data = {
      "nombre": "$nombre",
      "apepat": "$apepat",
      "apemat": "$apemat",
      "cumpleaños":"$cumple",
      "telefono": "$telefono",
      "correo": "$correo",
      "passwd": "$contra",
      "direcciones": [
        {
          "calle": "$calle",
          "num_ext": "$num_ext",
          "num_int": "$num_int",
          "colonia": "$colonia",
          "estado": "$estado",
          "cp": "$cp"
        }
      ]
    };

    Map dataResponse;

    //encode Map to JSON
    String body = json.encode(data);
    int status = 0;

    http.Response response = await http.post(Uri.parse('http://10.0.2.2:3000/api/authCliente/clienteSingUp'),
        headers: {"Content-Type": "application/json"},
        body: body
    );

    status = response.statusCode;
    if (status < 200 || status >= 400 || json == null) {
      //Error 
      return "null";
    }

    dataResponse = jsonDecode(response.body);
    return dataResponse['token'].toString();
  }

  void alertDialog(String title, String text){
     showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            title: "$title",
            description: "$text",
          );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 85 / 100,
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            physics: BouncingScrollPhysics(),
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 35 / 100,
                  margin: EdgeInsets.only(bottom: 20),
                  height: 6,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
                ),
              ),
              // header
              Container(
                margin: EdgeInsets.only(bottom: 24),
                child: Text(
                  'Registarse',
                  style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'inter'),
                ),
              ),
              // Form
              nombre,
              apepat,
              apemat,
              cumple,
              telefono,
              correo,
              contra,
              calle,
              num_int,
              num_ext,
              colonia,
              estado,
              cp,
              // Register Button
              Container(
                margin: EdgeInsets.only(top: 32, bottom: 6),
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    if(
                      nombre.controller.text != "" &&
                      apepat.controller.text != "" &&
                      apemat.controller.text != "" &&
                      cumple.controller.text != "" &&
                      telefono.controller.text != "" &&
                      correo.controller.text != "" &&
                      contra.controller.text != "" &&
                      calle.controller.text != "" &&
                      num_ext.controller.text != "" &&
                      num_int.controller.text != "" &&
                      colonia.controller.text != "" &&
                      estado.controller.text != "" &&
                      cp.controller.text != "")
                    {
                      
                      getFindCorreo(correo.controller.text).then((value){
                        if(value == "null"){
                            //Error en la comunicacion en la base de datos
                            alertDialog("Error","Error de la red");
                          }
                          else if(value == "true"){
                            //Correo Existente
                            alertDialog("Correro Existente","El correro que intentas usar ya existe");
                          }
                          else if(value == "false"){
                            //El correo no existe
                             postClienteSingUp(
                              nombre.controller.text,
                              apepat.controller.text,
                              apemat.controller.text,
                              cumple.controller.text,
                              telefono.controller.text,
                              correo.controller.text,
                              contra.controller.text,
                              calle.controller.text,
                              num_ext.controller.text,
                              num_int.controller.text,
                              colonia.controller.text,
                              estado.controller.text,
                              cp.controller.text).then((value)
                            {
                              if(value != "null"){
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PageSwitcher()));
                              }
                              else{
                                alertDialog("Error","Usuario no registrado intente mas tarde.");
                              }
                            }); 
                          }
                      });
                    }else{
                          alertDialog("Error","Favor de completar todos los datos");
                    }
                  },
                  child: Text('Registrar', style: TextStyle(color: AppColor.secondary, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'inter')),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    primary: AppColor.primarySoft,
                  ),
                ),
              ),
              // Login textbutton
              TextButton(
                onPressed: () {
                    Navigator.of(context).pop();
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                      isScrollControlled: true,
                      builder: (context) {
                        return LoginModal();
                      },
                    );
                },
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                child: RichText(
                  text: TextSpan(
                    text: 'Ya tienes una cuenta? ',
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                          style: TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'inter',
                          ),
                          text: 'Iniciar Sesion')
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
