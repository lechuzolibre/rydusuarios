import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rydusuarios/authentication/login_screen.dart';
import 'package:rydusuarios/methods/common_methods.dart';
import 'package:rydusuarios/widgets/loading_dialog.dart';

import '../pages/home_page.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}



class _SignUpScreenState extends State<SignUpScreen>
{
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailable()
  {
    cMethods.checkConnectivity(context);
    signUpFormValidation();
  }

  signUpFormValidation(){
    if(userNameTextEditingController.text.trim().length <= 3){
      cMethods.displaySnackBar("Tu nombre debe ser de 4 letras como mínimo", context);
    }
    else if(phoneTextEditingController.text.trim().length <= 9){
      cMethods.displaySnackBar("Revisa bien tu número de teléfono", context);
    }
    else if(!emailTextEditingController.text.contains("@")){
      cMethods.displaySnackBar("Revisa de nuevo tu correo", context);
    }
    else if(passwordTextEditingController.text.trim().length <= 9){
      cMethods.displaySnackBar("Revisa bien tu número de contraseña", context);
    }else{
      registerNewUser();
    }

  }

  registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: "Registra tu cuenta"),
    );

    final User? userFirebase = (
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
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

    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);
    Map userDataMap =
    {
      "name": userNameTextEditingController.text.trim(),
      "email": emailTextEditingController.text.trim(),
      "phone": phoneTextEditingController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no",
    };
    usersRef.set(userDataMap);

    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomePage()));

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
                "Crea una Cuenta de usuario",
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
                    TextField(
                      controller: userNameTextEditingController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: "Nombre de usuario",
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
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Numero",
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



                    //BOTON REGISTRARSE
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
                        "Registrate"
                      ),
                    ),

                    const SizedBox(height: 23,),

                    TextButton(
                      onPressed: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
                      },
                      child: const Text(
                        "¿Ya tienes una cuenta? Ingresa Aqui",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    )
                    //BOTON REGISTRARSE

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
