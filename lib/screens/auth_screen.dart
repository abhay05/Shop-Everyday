import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../models/HttpException.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const routename = '/auth';
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0, 1],
                colors: [
                  Color.fromRGBO(215, 117, 255, 0.5).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade900,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          // color: Colors.black,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      transform: Matrix4.rotationZ(-10 * pi / 180)
                        ..translate(
                            -10.0), // translate doesn't return anything, so we use ".." operator which returns Matrix4.rotation with changes made by translate
                      child: Text(
                        "MyShop",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.normal,
                          //  color: Theme.of(context).accentTextTheme.title.color,
                        ),
                      ),
                      margin: EdgeInsets.only(
                        bottom: 20,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: Auth(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Auth extends StatefulWidget {
  const Auth({Key key}) : super(key: key);
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> with SingleTickerProviderStateMixin {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthMode mode = AuthMode.Login;
  AnimationController _animationController;
  Animation<Size> _heightAnimation; // we are animating size

  //Tween<begin,end>
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;

  void switchMode() {
    //if (mode == AuthMode.Login) {
    // setState(() {
    //   mode = mode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
    // });
    // }
    if (mode == AuthMode.Login) {
      setState(() {
        mode = AuthMode.Signup;
      });
      _animationController.forward();
    } else if (mode == AuthMode.Signup) {
      setState(() {
        mode = AuthMode.Login;
      });
      _animationController.reverse();
    }
  }

  void showErrDialog(var msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(msg),
        actions: [
          FlatButton(
            onPressed: () => {Navigator.of(ctx).pop()},
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (mode == AuthMode.Login) {
        await Provider.of<AuthProvider>(context, listen: false)
            .signin(_authData["email"], _authData["password"]);
      } else {
        await Provider.of<AuthProvider>(context, listen: false)
            .signup(_authData["email"], _authData["password"]);
      }
    } on HttpException catch (err) {
      // catching HttpException
      if (err.message.contains("WEAK_PASSWORD")) {
        const errmsg = "Weak Password";
        showErrDialog(errmsg);
      }
    } catch (error) {
      print(error);
      const msg = "Please try again later..";
      showErrDialog(msg);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _heightAnimation = Tween<Size>(
      begin: Size(
        double.infinity,
        260,
      ),
      end: Size(
        double.infinity,
        320,
      ),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    ); // Size is a class
    _heightAnimation.addListener(() {
      setState(() {});
    });
  }

  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Focus focus = FocusScope.of(context).requestFocus();
    var deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        // decoration: BoxDecoration(

        //   color: Colors.pink,
        // ),
        width: deviceSize.width * 0.8,
        //height: 260, //deviceSize.height * 0.4,
        height: _heightAnimation.value.height,
        constraints: BoxConstraints(
          minHeight: _heightAnimation.value.height,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: usernameController,
                  //focusNode: FocusNode(),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (String val) {
                    if (val.isEmpty) {
                      return 'Username is empty';
                    }
                    return null;
                  },

                  decoration: InputDecoration(
                    hintText: "Username",
                  ),
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  //keyBoardType:TextInputType.visiblePassword,
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(hintText: "Password"),
                  obscureText: true,
                  validator: (String val) {
                    if (val.isEmpty || val.length < 5) {
                      return 'Password is empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (mode == AuthMode.Signup)
                  TextFormField(
                    enabled: mode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: false,
                    validator: mode == AuthMode.Signup
                        ? (value) {
                            // anonymous function with ? something to note
                            if (value != passwordController.text) {
                              return 'Password do not match';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text("${mode == AuthMode.Login ? 'Login' : 'SignUp'}"),
                    onPressed: submitForm,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.all(5),
                  ),
                FlatButton(
                  child: Text(
                      '${mode == AuthMode.Login ? 'SignUp' : 'Login'} INSTEAD'),
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 4,
                  ),
                  onPressed: () {
                    switchMode();
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          ),
        ),
      ),
      // shape: ,
    );
  }
}
