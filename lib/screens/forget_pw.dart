import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forget Password'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: "Email"
              ),
              validator: (String value) {
                return (value.isEmpty) ? "Please input correct Email" : null;
              },
            ),
            FlatButton(onPressed: () async{
              await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
              final snacBar = SnackBar(
                content: Text('Check your email for pw reset.'),
              );
              // snackbar : scaffold 안에서 쓸 수 있음. 그래서 scaffold 안에 있는 context 가져와야 함.
              // 여기서는 _formkey 를 사용해서 가져오는게 맞다.
              Scaffold.of(_formKey.currentContext).showSnackBar(snacBar);
            }, child: Text('Reset Password'),)
          ],
        ),
      ),
    );
  }
}