import 'package:flutter/material.dart';
import '../model/share.dart';
import '../model/userDB.dart';
import './homeScreen.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileScreen();
  }
}

class ProfileScreen extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  UserProvider userdb = UserProvider();
  static String quote;
  static Account _account;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController quotefield = TextEditingController();
  bool isUserIn = false;
   bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  int countSpace(String s) {
    int result = 0;
    for (int i = 0; i < s.length; i++) {
      if (s[i] == ' ') {
        result += 1;
      }
    }
    return result;
  }

  void initState() {
    super.initState();
    this.userdb.open();
    print("testdb");
    SharedPreferencesUtil.loadLastLogin().then((value) async {
      await userdb.open();
      await userdb.getAccountByUserId(value).then((values) {
        setState(() {
          _account = values;
          username.text = _account.userid;
          password.text = _account.password;
          name.text = _account.name;
          age.text = _account.age.toString();
        });
      });
    });
    SharedPreferencesUtil.loadQuote().then((value) {
      setState(() {
        ProfileScreen.quote = value;
        quotefield.text = quote;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("PROFILE"),
          backgroundColor: Colors.lightBlueAccent[100],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                    labelText: "User Id",
                    icon: Icon(Icons.account_box,size: 35,),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                  if (value.length < 6 || value.length > 12) {
                    return "Please fill 6-12 character";
                  } if (this.isUserIn) {
                    print("user taken");
                    return "This Username is taken";
                  }
                  }),
                  TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    labelText: "Name",
                    icon: Icon(Icons.account_circle,size: 35,),
                  ),
                  validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill out this form";
                  } else if (countSpace(value) != 1) {
                    return "Please fill space between name";
                  }
                }),
                TextFormField(
                  controller: age,
                  decoration: InputDecoration(
                    labelText: "Age",
                    icon: Icon(Icons.event_note,size: 35,),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please fill Age";
                    } else if (!isNumeric(value) ||
                        int.parse(value) < 10 ||
                        int.parse(value) > 80) {
                     return "Please fill Age between 10-80";
                    }
                }),
                TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                    labelText: "Password",
                    icon: Icon(Icons.lock,size: 35,),
                  ),
                  obscureText: true,
                  validator: (value) {
                  if (value.isEmpty || value.length <= 6) {
                    return "Please fill Password Correctly";
                  }
                  }),
                TextFormField(
                  controller: quotefield,
                  decoration: InputDecoration(
                    labelText: "Quote",
                    icon: Icon(Icons.chat,size: 35,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: RaisedButton(
                          child: Text("SAVE"),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await userdb.open();
                              await userdb.update(Account(
                                  id: _account.id,
                                  userid: username.text,
                                  name: name.text,
                                  age: int.parse(age.text),
                                  password: password.text));

                              _account.userid = username.text;
                              _account.name = name.text;
                              _account.age = int.parse(age.text);
                              _account.password = password.text;

                              await SharedPreferencesUtil.saveQuote(
                                  quotefield.text);
                              Navigator.pushReplacement(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => Home(_account)),
                              );
                            }
                          },  
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
