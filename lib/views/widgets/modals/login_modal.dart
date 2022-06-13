import 'package:flutter/material.dart';
import 'package:hungry/views/screens/clientes/cliente_page_switcher.dart' as cliente_page_switcher;
import 'package:hungry/views/screens/empleados/empleado_page_switcher.dart' as empleado_page_switcher;
import 'package:hungry/views/utils/AppColor.dart';
import 'package:hungry/views/widgets/custom_text_field.dart';
import 'package:hungry/views/widgets/custom_alert_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class LoginModal extends StatefulWidget {

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {

  final correo = CustomTextField(title: 'Correo', hint: 'youremail@email.com',controller: TextEditingController());
  final passwd = CustomTextField(title: 'Contraseña', hint: '**********', obsecureText: true, margin: EdgeInsets.only(top: 16),controller: TextEditingController());
  /*
  getClienteSingIn() async{
    http.Response response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/empleados/'),
       headers: {"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MjhmZTBjNWM0ODEzZWRkNjA0NzA3NjkiLCJjb3JyZW8iOiJlamVtcGxvQGVqZW1wbG8uY29tIiwidGlwbyI6ImFkbWluIiwiaWF0IjoxNjU1MDg0NjExLCJleHAiOjE2NTUxMTM0MTF9.EbLooLGiLdbcLiPIQG7mud4ARfKnAPu_Kdz1X1umJns"}
    );
    debugPrint(response.body);
  }
*/
 Future getClienteSingIn(String correo, String passwd) async {
  
    Map data = {
      "correo": "$correo",
      "passwd": "$passwd"
    };

    Map dataResponse;

    //encode Map to JSON
    String body = json.encode(data);
    int status = 0;

    http.Response response = await http.post(Uri.parse('http://10.0.2.2:3000/api/authCliente/clienteSingIn'),
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

  Future getEmpleadoSingIn(String correo, String passwd) async {
  
    Map data = {
      "correo": "$correo",
      "passwd": "$passwd"
    };

    Map dataResponse;

    //encode Map to JSON
    String body = json.encode(data);
    int status = 0;

    http.Response response = await http.post(Uri.parse('http://10.0.2.2:3000/api/authEmpleado/EmpleadoSingIn'),
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

/*
  Future<dynamic> get(String url) async {

    return http.post(url, headers: {"Authorization": "Some token"}).then(
        (http.Response response) {
      final int statusCode = response.statusCode;
      LogUtils.d("====response ${response.body.toString()}");

      if (statusCode < 200 || statusCode >= 400 || json == null) {
        throw new ApiException(jsonDecode(response.body)["message"]);
      }
      return _decoder.convert(response.body);
    });
  }
*/
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
                  'Iniciar Sesion',
                  style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'inter'),
                ),
              ),
              // Form
              correo,
              passwd,
              // Log in Button
              Container(
                margin: EdgeInsets.only(top: 32, bottom: 6),
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    getClienteSingIn(correo.controller.text,passwd.controller.text).then((value){
                      if(value != "null"){
                        //Ingresa como cliente
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => cliente_page_switcher.PageSwitcher()));
                      }
                      else{
                        getEmpleadoSingIn(correo.controller.text,passwd.controller.text).then((value){
                          if(value != "null"){
                            //Ingresa como empleado
                            
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => empleado_page_switcher.PageSwitcher()));
                            
                          }
                          else{
                            //Usuario no registrado
                            alertDialog("Error","Correo o contraseña incorrectos");
                          }
                        });
                      }
                    }); 
                  },
                  child: Text('Iniciar Sesion', style: TextStyle(color: AppColor.secondary, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'inter')),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    primary: AppColor.primarySoft,
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
