import 'package:agrisen_app/ProfilePage/hasLogin.dart';
import 'package:agrisen_app/Providers/facebook.dart';
import 'package:agrisen_app/Providers/google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HasNotLogin extends StatefulWidget {
  @override
  _HasNotLoginState createState() => _HasNotLoginState();
}

class _HasNotLoginState extends State<HasNotLogin> {
  bool _isSigningFacebook = false, _isSigningGoogle = false;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final _passwordFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  bool _isSigingin = false, _isSigingup = false, _signup = false;
  String _email, _userName, _password;

  void _signinWithEmailPassword() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isSigingin = true;
      });
      final userData = json.encode({
        'email': _email,
        'password': _password,
      });

      http.post('url', body: {'signin': userData}).then((response) async {
        final data = json.decode(response.body);
        final sharedPref = await SharedPreferences.getInstance();
        final res = await sharedPref.setString(
          'userInfos',
          json.encode({
            'api-key': data['api_key'],
            'subscriber': 'emailAndPassword',
          }),
        );
        if (res) {
          setState(() {
            _isLogin = true;
          });
        }
      }).catchError((err) {
        setState(() {
          _isSigingup = false;
        });
        print('errs: $err');
      });
    }
  }

  void _signupWithEmailPassword() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isSigingup = true;
      });
      final userData = json.encode({
        'user_name': _userName,
        'email': _email,
        'password': _password,
      });

      http.post('url', body: {'signup': userData}).then((response) async {
        final data = json.decode(response.body);
        final sharedPref = await SharedPreferences.getInstance();
        final res = await sharedPref.setString(
            'userInfos',
            json.encode({
              'api-key': data['api_key'],
              'subscriber': 'emailAndPassword',
            }));
        if (res) {
          setState(() {
            _isLogin = true;
          });
        }
      }).catchError((err) {
        setState(() {
          _isSigingup = false;
        });
        print('errs: $err');
      });
    }
  }

  Future _insertingGoogleFacebookUserToDb(
      String email, String name, String profile, String gORf) async {
    try {
      final userdata = json.encode(
        {
          "email": email,
          "name": name,
          "profile_image": profile,
        },
      );
      final response = await http.post(
        'http://192.168.43.150/Agrisen_app/AgrisenMobileAppAPIs/googleAndFacebookSignin.php',
        body: {'user_data': userdata},
      );
      if (response != null) {
        final result = json.decode(response.body);
        final sharedPref = await SharedPreferences.getInstance();

        setState(() {
          _isSigningFacebook = false;
          _isSigningGoogle = false;
        });

        if (result['status'] == 201) {
          final res = await sharedPref.setString(
              'userInfos',
              json.encode({
                'api-key': result['api_key'],
                'subscriber': gORf,
              }));
          if (res) {
            setState(() {
              _isLogin = true;
            });
          }
        } else if (result['status'] == 200) {
          final res = await sharedPref.setString(
              'userInfos',
              json.encode({
                'api-key': result['api_key'],
                'subscriber': gORf,
              }));
          if (res) {
            setState(() {
              _isLogin = true;
            });
          }
        } else {
          snakebar('something went wrong please try again!');
        }
      }
    } catch (e) {
      setState(() {
        _isSigningFacebook = false;
        _isSigningGoogle = false;
      });
      snakebar('something went wrong please try again!');
    }
  }

  void _googleSignin() async {
    setState(() {
      _isSigningGoogle = true;
    });

    await Google.signin().then((userInfos) async {
      await _insertingGoogleFacebookUserToDb(
          userInfos.email, userInfos.displayName, userInfos.photoUrl, 'google');
    }).catchError((onError) {
      snakebar('something went wrong please try again letter!');
      setState(() {
        _isSigningGoogle = false;
      });
    });
  }

  void _facebookSignin() async {
    setState(() {
      _isSigningFacebook = true;
    });

    await Facebook.signin().then((value) async {
      final email = value['email'];
      final name = '${value['first_name']} ${value['last_name']}';
      final profileImage = value['picture']['data']['url'];

      if (value != false) {
        await _insertingGoogleFacebookUserToDb(
            email, name, profileImage, 'facebook');
      }
    }).catchError((err) {
      snakebar('something went wrong please try again letter!');
      setState(() {
        _isSigningFacebook = false;
      });
    });
  }

  snakebar(String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              SizedBox(
                width: 15,
              ),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }

  var _isLogin = false, _isAScreenAvailable = true;

  @override
  void didChangeDependencies() async {
    setState(() {
      _isAScreenAvailable = false;
    });

    final sharedPref = await SharedPreferences.getInstance();

    if (sharedPref.containsKey('userInfos')) {
      setState(() {
        _isAScreenAvailable = true;
        _isLogin = true;
      });
    } else {
      setState(() {
        _isAScreenAvailable = true;
      });
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isAScreenAvailable == false
          ? Container()
          : _isLogin != false
              ? HasLogin()
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 20.0, right: 8.0, left: 8.0, bottom: 8.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton.icon(
                            onPressed: () {
                              setState(() {
                                _signup = !_signup;
                              });
                            },
                            icon: Icon(
                              _signup ? Icons.arrow_back : Icons.exit_to_app,
                              color: Colors.blue,
                            ),
                            label: Text(
                              _signup ? 'Back to Sigin' : 'Sigup instead',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Form(
                          autovalidate: true,
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              if (_signup)
                                TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please a user name is required';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_emailFocusNode);
                                  },
                                  onSaved: (value) {},
                                  style: TextStyle(fontSize: 20),
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.person_outline,
                                    ),
                                    labelText: 'User name',
                                    contentPadding: EdgeInsets.all(0.0),
                                  ),
                                ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                validator: (value) {
                                  RegExp exp = RegExp(
                                      r'[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9]+');
                                  if (value.isEmpty) {
                                    return 'Please an email is required';
                                  }
                                  if (exp.allMatches(value).isEmpty) {
                                    return 'please enter a valid email address';
                                  }
                                  return null;
                                },
                                focusNode: _emailFocusNode,
                                onSaved: (value) {},
                                style: TextStyle(fontSize: 20),
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_passwordFocusNode);
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.email,
                                  ),
                                  labelText: 'Email',
                                  contentPadding: EdgeInsets.all(0.0),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please an password is required';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                onSaved: (value) {},
                                focusNode: _passwordFocusNode,
                                style: TextStyle(fontSize: 20),
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.lock_outline,
                                  ),
                                  labelText: 'Password',
                                  contentPadding: EdgeInsets.all(0.0),
                                  suffix: IconButton(
                                    icon: _obscureText
                                        ? Icon(
                                            Icons.visibility,
                                          )
                                        : Icon(
                                            Icons.visibility_off,
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        if (_obscureText) {
                                          _obscureText = false;
                                        } else {
                                          _obscureText = true;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            onPressed: () {},
                            child: Text(
                              '', //'Forgot Password ?',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _signup
                            ? FloatingActionButton.extended(
                                backgroundColor:
                                    Color.fromRGBO(10, 17, 40, 1.0),
                                label: _isSigingup
                                    ? CircularProgressIndicator(
                                        backgroundColor: Colors.blue,
                                        strokeWidth: 2,
                                      )
                                    : Text(
                                        'Sign up',
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                              237, 245, 252, 1.0),
                                          fontSize: 18,
                                        ),
                                      ),
                                icon: Icon(
                                  Icons.exit_to_app,
                                  color: Color.fromRGBO(237, 245, 252, 1.0),
                                ),
                                onPressed: () => _signupWithEmailPassword(),
                              )
                            : FloatingActionButton.extended(
                                backgroundColor:
                                    Color.fromRGBO(10, 17, 40, 1.0),
                                label: _isSigingin
                                    ? CircularProgressIndicator(
                                        backgroundColor: Colors.blue,
                                        strokeWidth: 2,
                                      )
                                    : Text(
                                        'Sign in',
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                            237,
                                            245,
                                            252,
                                            1.0,
                                          ),
                                          fontSize: 18,
                                        ),
                                      ),
                                icon: Icon(
                                  Icons.exit_to_app,
                                  color: Color.fromRGBO(237, 245, 252, 1.0),
                                ),
                                onPressed: () => _signinWithEmailPassword(),
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'or sign in with',
                              style:
                                  TextStyle(letterSpacing: 2, wordSpacing: 3),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FittedBox(
                          child: Row(
                            children: <Widget>[
                              FloatingActionButton.extended(
                                elevation: 3,
                                label: _isSigningGoogle
                                    ? CircularProgressIndicator(
                                        backgroundColor: Colors.blue,
                                        strokeWidth: 1,
                                      )
                                    : Text(
                                        'google',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(10, 17, 40, 1.0),
                                          fontSize: 18,
                                        ),
                                      ),
                                icon: SvgPicture.asset(
                                  'assets/SVGPics/google.svg',
                                  height: 30,
                                ),
                                onPressed: () => _googleSignin(),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              FloatingActionButton.extended(
                                elevation: 3,
                                label: _isSigningFacebook
                                    ? CircularProgressIndicator(
                                        backgroundColor: Colors.blue,
                                        strokeWidth: 1,
                                      )
                                    : Text(
                                        'facebook',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(10, 17, 40, 1.0),
                                          fontSize: 18,
                                        ),
                                      ),
                                icon: SvgPicture.asset(
                                  'assets/SVGPics/facebook.svg',
                                  height: 30,
                                ),
                                onPressed: () => _facebookSignin(),
                              )
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
