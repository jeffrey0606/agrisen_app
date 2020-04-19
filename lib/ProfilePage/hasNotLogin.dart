import 'package:agrisen_app/ProfilePage/hasLogin.dart';
import 'package:agrisen_app/Providers/facebook.dart';
import 'package:agrisen_app/Providers/google.dart';
import 'package:agrisen_app/Providers/userInfos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HasNotLogin extends StatefulWidget {
  final Function alert;
  final GlobalKey<ScaffoldState> globalKey;
  HasNotLogin({@required this.alert, @required this.globalKey});
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
      final userData = {
        'email': _email,
        'password': _password,
      };

      http
          .post('http://192.168.43.150/agrisen-api/index.php/Profile/sign_in',
              body: userData)
          .then((response) async {
        if (response != null) {
          final result = json.decode(response.body);
          print('object: $result');
          if (result != null) {
            if (DateTime.parse(result['creation_date'].toString())
                    .add(Duration(days: 3))
                    .compareTo(DateTime.now()) <
                0) {
              http.post('http://192.168.43.150/agrisen-api/index.php/Profile/delete_user', body: userData).then((_) {
                    setState(() {
                      _isSigingin = false;
                    });
                    snakebar(
                    'Your Account has been Deleted Since you did not verified your Email');
              }).catchError((_) {
                setState(() {
                  _isSigingin = false;
                });
                snakebar(
                    'User was not found please try again with the correct credentials.');
              });
            } else {
              final sharedPref = await SharedPreferences.getInstance();
              final res = await sharedPref.setString(
                'userInfos',
                json.encode({
                  'api-key': result['api_key'],
                  'subscriber': 'emailAndPassword',
                }),
              );
              final res1 = await sharedPref.setString(
                'verification',
                result['creation_date'].toString(),
              );

              if (res || res1) {
                setState(() {
                  _isLogin = true;
                });
              } else {
                print('shared');
              }
            }
          } else {
            setState(() {
              _isSigingin = false;
            });
            snakebar(
                'User was not found please try again with the correct credentials.');
          }
        } else {
          setState(() {
            _isSigingin = false;
          });
          snakebar('Something went wrong please try again later.');
        }
      }).catchError((err) {
        setState(() {
          _isSigingin = false;
        });
        print('object: $err');
        snakebar('Something when wrong please try again.');
      });
    }
  }

  void _signupWithEmailPassword() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isSigingup = true;
      });
      final userData = {
        'user_name': _userName,
        'email': _email,
        'password': _password,
      };

      http
          .post('http://192.168.43.150/agrisen-api/index.php/Profile/sign_up',
              body: userData)
          .then((response) async {
        if (response != null) {
          final result = json.decode(response.body);

          if (result == null) {
            setState(() {
              _isSigingup = false;
            });
            snakebar(
                'A user with this email already exits try with another please.');
          } else if (result == false) {
            setState(() {
              _isSigingup = false;
            });
            snakebar(
                'Something went wrong please try again. A verification mail could not be send to your address.');
          } else {
            final sharedPref = await SharedPreferences.getInstance();
            final res = await sharedPref.setString(
              'userInfos',
              json.encode(
                {
                  'api-key': json.decode(response.body),
                  'subscriber': 'emailAndPassword',
                },
              ),
            );
            final res1 = await sharedPref.setString(
              'verification',
              DateTime.now().toString(),
            );

            if (res && res1) {
              setState(() {
                _isLogin = true;
              });
            }
          }
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
    final userdata = {
      "email": email,
      "user_name": name,
      "profile_image": profile,
    };

    await http
        .post('http://192.168.43.150/agrisen-api/index.php/Profile/sign_up',
            body: userdata)
        .then((response) async {
      if (response != null) {
        final sharedPref = await SharedPreferences.getInstance();
        final res = await sharedPref.setString(
            'userInfos',
            json.encode({
              'api-key': json.decode(response.body),
              'subscriber': gORf,
            }));
        if (res) {
          setState(() {
            _isSigningFacebook = false;
            _isSigningGoogle = false;
            _isLogin = true;
          });
        } else {
          setState(() {
            _isSigningFacebook = false;
            _isSigningGoogle = false;
          });
          snakebar('something went wrong please try again!');
        }
      }
    }).catchError((error) {
      setState(() {
        _isSigningFacebook = false;
        _isSigningGoogle = false;
      });
      snakebar('something went wrong please try again!');
    });
  }

  void _googleSignin() async {
    setState(() {
      _isSigningGoogle = true;
    });

    await Google.signin().then((userInfos) async {
      await _insertingGoogleFacebookUserToDb(
        userInfos.email,
        userInfos.displayName,
        userInfos.photoUrl,
        'google',
      );
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
          email,
          name,
          profileImage,
          'facebook',
        );
      }
    }).catchError((err) {
      snakebar('something went wrong please try again letter!');
      setState(() {
        _isSigningFacebook = false;
      });
    });
  }

  snakebar(String message) {
    _globalKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(child: Text(message)),
          ],
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

  final _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isLogin == false
          ? AppBar(
              title: Text('Agrisen'),
              centerTitle: true,
            )
          : PreferredSize(
              preferredSize: Size(0, 0),
              child: Container(),
            ),
      key: _globalKey,
      body: _isAScreenAvailable == false
          ? Container()
          : _isLogin != false
              ? HasLogin(
                  alert: widget.alert,
                  globalKey: widget.globalKey,
                )
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
                                  onSaved: (value) {
                                    setState(() {
                                      _userName = value;
                                    });
                                  },
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
                                onSaved: (value) {
                                  setState(() {
                                    _email = value;
                                  });
                                },
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
                                onSaved: (value) {
                                  setState(() {
                                    _password = value;
                                  });
                                },
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
                                backgroundColor: _isSigingup
                                    ? Color.fromRGBO(10, 17, 40, 0.4)
                                    : Color.fromRGBO(10, 17, 40, 1.0),
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
                                elevation: _isSigingup ? 0 : 8,
                                onPressed: _isSigingup
                                    ? null
                                    : () => _signupWithEmailPassword(),
                              )
                            : FloatingActionButton.extended(
                                elevation: _isSigingin ? 0 : 8,
                                backgroundColor: _isSigingin
                                    ? Color.fromRGBO(10, 17, 40, 0.4)
                                    : Color.fromRGBO(10, 17, 40, 1.0),
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
                                onPressed: _isSigingin
                                    ? null
                                    : () => _signinWithEmailPassword(),
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
                                elevation: _isSigningGoogle ? 0 : 3,
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
                                onPressed: _isSigningGoogle
                                    ? null
                                    : () => _googleSignin(),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              FloatingActionButton.extended(
                                elevation: _isSigningFacebook ? 0 : 3,
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
                                onPressed: _isSigningFacebook
                                    ? null
                                    : () => _facebookSignin(),
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
