import 'package:flutter/material.dart';
import '../screen/homeScreen.dart';
import '../screen/registerScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/share.dart';
import '../model/userDB.dart';
import 'package:toast/toast.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginScreen();
  }
}

class LoginScreen extends State<Login> {
  UserProvider userdb = UserProvider();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userid = TextEditingController();
  final TextEditingController password = TextEditingController();

  void initState() {
    super.initState();
    this.userdb.open();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ListView(
                children: <Widget>[
                  Image.asset(
                    "image/lock.png",
                    height: 180,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "User Id",
                      icon: Icon(Icons.account_box,
                      size: 30,),
                    ),
                    controller: userid,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill out this form";
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Password", icon: Icon(Icons.lock,
                        size: 30,)
                    ),
                    obscureText: true,
                    controller: password,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill out this form";
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    child: Text("LOGIN"),
                    color: Colors.lightBlueAccent[100],
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await userdb.open();
                        userdb.getAccountByUserId(userid.text).then((account) {
                          if (account == null ||
                              password.text != account.password) {
                            print("LOGIN FAIL");
                            Toast.show("Invalid user or password", context);
                          } else {
                            print("LOGIN PASS");
                            SharedPreferencesUtil.saveLastLogin(userid.text);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home(account)),
                            );
                          }
                        });
                      }
                    },
                  ),
                  Container(
                    child: FlatButton(
                      child: Text("Register New Account"),
                      onPressed: () {
                        Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()),
                            );
                      },
                    ),
                    alignment: Alignment.topRight,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
