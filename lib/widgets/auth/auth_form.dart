import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm({
    Key key,
    @required this.submitForm,
    this.handleSignInWithGoogle,
    this.isLoading,
  }) : super(key: key);

  final bool isLoading;
  final void Function(
    String email,
    String username,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) submitForm;
  final Function handleSignInWithGoogle;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;

  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  void _trySubmit() {
    // first, we need to validate input.
    final isValid = _formKey.currentState.validate();

    // release all focus.
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();

      // use those values to send our auth request.
      print('$_userEmail');
      print('$_userName');
      print('$_userPassword');
      widget.submitForm(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _isLogin,
        context,
      );
    }
  }

  void _tryGoogleSignIn() {
    widget.handleSignInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                _isLogin ? 'Login' : 'Sign Up',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      onSaved: (value) {
                        // don't need setState
                        // because don't need to rebuild wigets.
                        _userEmail = value;
                      },
                    ),
                    !_isLogin
                        ? TextFormField(
                            key: ValueKey('username'),
                            validator: (value) {
                              if (value.isEmpty || value.length < 4) {
                                return 'Please enter at least 4 characters.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Username',
                            ),
                            onSaved: (value) {
                              _userName = value;
                            },
                          )
                        : Container(),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Password must be at least 7 characters long.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onSaved: (value) {
                        _userPassword = value;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget.isLoading)
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    if (!widget.isLoading)
                      FilledButton(
                        child: Text(
                          _isLogin ? 'LOGIN' : 'SIGN UP',
                        ),
                        onPressed: _trySubmit,
                      ),
                    if (!widget.isLoading)
                      TextButton(
                        child: Text(
                          _isLogin
                              ? 'Create new account'
                              : 'I already have an acount?',
                        ),
                        // textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                      ),
                  ],
                ),
              ),
              Divider(),
              FilledButton(
                child: Text('SIGN IN WITH GOOGLE'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: _tryGoogleSignIn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
