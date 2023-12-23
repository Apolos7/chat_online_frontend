import 'package:chat_online_frontend/service/user_service.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 400,
          width: MediaQuery.of(context).size.width * 0.80,
          child: Card(
            color: const Color(0XFF23272a),
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(),
                    const Text(
                      'Sign up',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w600),
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        hintText: 'username',
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.white38,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _passwordController,
                      validator: passwordValidator,
                      obscureText: _passwordVisible,
                      decoration: InputDecoration(
                        hintText: 'password',
                        hintStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.white38,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() {
                            _passwordVisible = !_passwordVisible;
                          }),
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white54,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 250,
                      ),
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        onPressed: () => signUp(
                            username: _usernameController.text,
                            password: _passwordController.text),
                        child: const Text(
                          'Sing up',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: TextButton(
                        onPressed: () => navToSignInView(),
                        child: const Text(
                          'I already have an account',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp({required String username, required String password}) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      UserService userService = UserService();
      userService
          .registerUser(username: username, password: password)
          .then((value) {
        Navigator.pop(context, value);
      }).onError((Object? error, StackTrace stackTrace) {
        SnackBar snack = SnackBar(content: Text(error.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snack);
      });
    }
  }

  void navToSignInView() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  String? passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    return null;
  }
}
