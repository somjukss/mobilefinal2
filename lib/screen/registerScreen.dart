import 'package:flutter/material.dart';
import '../model/userDB.dart';
// import 'package:toast/toast.dart';

class Register extends StatefulWidget {
  @override
  RegisterScreen createState() => RegisterScreen();
}

class RegisterScreen extends State<Register> {

  final _formkey = GlobalKey<FormState>();

  UserProvider user = UserProvider();

  final TextEditingController userid = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController password = TextEditingController();

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
    this.user.open();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Colors.lightBlueAccent[100],
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 30, 0),
          children: <Widget>[
            TextFormField(
                decoration: InputDecoration(
                  labelText: "User Id",
                  hintText: "User Id must be between 6 to 12",
                  icon: Icon(Icons.account_box, size: 40, color: Colors.grey),
                ),
                controller: userid,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill out this form";
                  } else if (value.length < 6 || value.length > 12) {
                    return "Please fill UserId Correctly";
                  } if (this.isUserIn) {
                    print("user taken");
                    return "This Username is taken";
                  }
                  // else if () {
                  //   ถ้ามีเงื่อนไขเพิ่มก็ifเอา
                  // }
                }),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "ex. 'John Snow'",
                  icon:
                      Icon(Icons.account_circle, size: 40, color: Colors.grey),
                ),
                controller: name,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill out this form";
                  } else if (countSpace(value) != 1) {
                    return "Please fill Name Correctly";
                  }
                }),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Age",
                  hintText: "Please fill Age Between 10 to 80",
                  icon: Icon(Icons.event_note, size: 40, color: Colors.grey),
                ),
                controller: age,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill Age";
                  } else if (!isNumeric(value) ||
                      int.parse(value) < 10 ||
                      int.parse(value) > 80) {
                    return "Please fill Age correctly";
                  }
                  // else if () {
                  //   ถ้ามีเงื่อนไขเพิ่มก็ifเอา
                  // }
                }),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Password must be longer than 6",
                  icon: Icon(Icons.lock, size: 40, color: Colors.grey),
                ),
                controller: password,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty || value.length <= 6) {
                    return "Please fill Password Correctly";
                  }
                  // else if () {
                  //   ถ้ามีเงื่อนไขเพิ่มก็ifเอา
                  // }
                }),
            Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
            RaisedButton(
                child: Text("REGISTER NEW ACCOUNT"),
                onPressed: () async {
                  // if (password.text != repassword.text) {
                  //   // print("ERROR");
                  //   Toast.show("PASS NOT MATCH", context);
                  // }
                  if (this._formkey.currentState.validate()) {
                    await user.open();
                    print("OPEN");
                    await user.insert(Account(
                        userid: userid.text,
                        name: name.text,
                        age: int.parse(age.text),
                        password: password.text));
                    Navigator.of(context).pushReplacementNamed('/');
                  }
                }),
          ],
        ),
      ),
    );
  }
}
