import 'package:chat_online_frontend/service/user_service.dart';
import 'package:chat_online_frontend/view/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF36393f),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 400,
              width: MediaQuery.of(context).size.width * 0.80,
              child: Card(
                color: const Color(0XFF23272a),
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
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
                          margin: const EdgeInsets.only(bottom: 50),
                          child: ElevatedButton(
                            onPressed: () => login(
                                username: _usernameController.text,
                                password: _passwordController.text),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void login({required String username, required String password}) async {
    if (_formKey.currentState!.validate()) {
      UserService userService = UserService();
      userService
          .authenticateUser(username: username, password: password)
          .then((token) {

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ChatView(username: username, token: token),
          ),
        );
      });
    }
  }

  String? passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    return null;
  }
}
