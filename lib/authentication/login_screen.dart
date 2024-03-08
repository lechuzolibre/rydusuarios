import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rydusuarios/authentication/signup_screen.dart';
import 'package:rydusuarios/global/global_var.dart';

import '../methods/common_methods.dart';
import '../pages/home_page.dart';
import '../widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailable()
  {
    cMethods.checkConnectivity(context);
    signUpFormValidation();
  }

  signUpFormValidation(){
    if(!emailTextEditingController.text.contains("@")){
      cMethods.displaySnackBar("Revisa de nuevo tu correo", context);
    }
    else if(passwordTextEditingController.text.trim().length <= 9){
      cMethods.displaySnackBar("Revisa bien tu número de contraseña", context);
    }else{
      signInUser();
    }

  }

  signInUser() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: "Permitir iniciio de sesion"),
    );

    final User? userFirebase = (
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((errorMsg)
        {
          Navigator.pop(context);
          cMethods.displaySnackBar(errorMsg.toString(), context);
        })
    ).user;

    if(!context.mounted) return;
    Navigator.pop(context);

    if(userFirebase != null){
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);
      await usersRef.once().then((snap)
      {
        if(snap.snapshot.value != null){
          if((snap.snapshot.value as Map)["blockStatus"] == "no"){
            userName = (snap.snapshot.value as Map)["name"];
            userPhone = (snap.snapshot.value as Map)["phone"];
            Navigator.push(context, MaterialPageRoute(builder: (c)=> HomePage()));
          }else{
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar("Debes recargar tu cuenta en ruta y destino", context);
          }
        }else{
          FirebaseAuth.instance.signOut();
          cMethods.displaySnackBar("Tu registro no existe como un usuario", context);
        }
      });
    }

  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset(
                  "assets/images/logo.png"
              ),

              const Text(
                "Iniciar Sesion",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              //CAMPOS DE TEXTOS
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [

                    //---------------------------------------//
                    //---------------------------------------//
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Correo",
                        labelStyle: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15
                      ),
                    ),
                    //---------------------------------------//
                    const SizedBox(height: 23,),
                    //---------------------------------------//
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Contrasena",
                        labelStyle: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15
                      ),
                    ),
                    //---------------------------------------//
                    const SizedBox(height: 29,),


                    //BOTON INICIAR SESION
                    ElevatedButton(
                      onPressed: ()
                      {
                        checkIfNetworkIsAvailable();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 23),
                      ),
                      child: const Text(
                          "Iniciar Sesion"
                      ),
                    ),

                    const SizedBox(height: 23,),

                    TextButton(
                      onPressed: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (c)=> SignUpScreen()));
                      },
                      child: const Text(
                        "¿No tienes una cuenta? Registrate Aqui",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    )
                    //BOTON INICIAR SESION

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
