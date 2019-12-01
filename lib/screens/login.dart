import 'package:firebase_auth/firebase_auth.dart';
import 'package:aventura/helper/login_background.dart';
import 'package:aventura/data/join_or_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aventura/screens/forget_pw.dart';

class AuthPage extends StatelessWidget {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // unique 한 id 를 주는 것. form 에 id를 주고 상태변화를 가져오려고 사용
  static final TextEditingController _emailController = TextEditingController();
  static final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // phone 의 화면크기 context는 휴대전화 정보 담긴 파라미터 , final 이면 변경 불가능하게 선언

    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CustomPaint(
          size: size,
          painter:
              LoginBackground(isJoin: Provider.of<JoinOrLogin>(context).isJoin),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _logoImage,
            Stack(
              children: <Widget>[
                _inputForm(size),
                _authButton(size),
              ],
            ),
            Container(
              height: size.height * 0.1,
            ),
            Consumer<JoinOrLogin>(
              builder: (context, joinOrLogin, child) => GestureDetector(
                  onTap: () {
                    joinOrLogin.toggle();
                  },
                  child: Text(
                    joinOrLogin.isJoin
                        ? "Already Have an Account? Sign in!"
                        : "Don't have an Account? Create One!",
                    style: TextStyle(
                        color: joinOrLogin.isJoin ? Colors.red : Colors.blue),
                  )),
            ),
            Container(
              height: size.height * 0.05,
            )
          ],
        )
      ],
    ));
  }

  void _register(BuildContext context) async {
    final AuthResult result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
    final FirebaseUser user = result.user;

    if (user == null) {
      final snacBar = SnackBar(
        content: Text("Please try again later."),
      );
      Scaffold.of(context).showSnackBar(snacBar);
    }

    // Navigator 로 보내는 방법.
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(email : user.email) ));
  }

  void _login(BuildContext context) async {
    final AuthResult result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
    final FirebaseUser user = result.user;

    if (user == null) {
      final snacBar = SnackBar(
        content: Text("Please try again later."),
      );
      Scaffold.of(context).showSnackBar(snacBar);
    }

    // Navigator 로 보내는 방법.
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(email : user.email) ));
  }

  // param 이 따로 없는 경우 get 앞에 붙여주면 사용 시 () 없이 호출 가능
  Widget get _logoImage => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
          child: FittedBox(
            fit: BoxFit.contain,
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/login.gif"),
            ),
          ),
        ),
      );

  Widget _authButton(Size size) => Positioned(
        left: size.width * 0.15,
        right: size.width * 0.15,
        bottom: 0,
        child: SizedBox(
            height: 50,
            child: Consumer<JoinOrLogin>(
              builder: (context, value, child) => RaisedButton(
                  child: Text(value.isJoin ? "Join" : "Login",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  color: value.isJoin ? Colors.red : Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      value.isJoin ? _register(context) : _login(context);
                    }
                    FocusScope.of(context).unfocus(); // hide keyboard
                  }),
            )),
      );

  Widget _inputForm(Size size) => Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_circle), labelText: "Email"),
                    validator: (String value) {
                      return (value.isEmpty)
                          ? "Please input correct Email"
                          : null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key), labelText: "Password"),
                    validator: (String value) {
                      return (value.isEmpty)
                          ? "Please input correct Password"
                          : null;
                    },
                  ),
                  Container(
                    height: 8,
                  ),
                  Consumer<JoinOrLogin>(
                    builder: (context, value, child) => Opacity(
                      opacity: value.isJoin ? 0 : 1,
                      child: GestureDetector(
                          onTap: value.isJoin
                              ? null
                              : () {
                                  goToForgetPw(context);
                                },
                          child: Text("Forgot Password ?")),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  goToForgetPw(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgetPassword()));
  }
}
