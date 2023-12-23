import 'package:chat_online_frontend/service/user_service.dart';
import 'package:chat_online_frontend/view/chat_view.dart';
import 'package:chat_online_frontend/view/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _passwordVisible = ValueNotifier(true);
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
                      'Sign in',
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
                    ValueListenableBuilder(
                      valueListenable: _passwordVisible,
                      builder: (BuildContext context, bool value, Widget? child) => TextFormField(
                        controller: _passwordController,
                        validator: passwordValidator,
                        obscureText: value,
                        decoration: InputDecoration(
                          hintText: 'password',
                          hintStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.white38,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => _passwordVisible.value =
                                !_passwordVisible.value,
                            icon: Icon(
                              value ? Icons.visibility : Icons.visibility_off,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white54,
                        ),
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
                        onPressed: () => signIn(
                            username: _usernameController.text,
                            password: _passwordController.text),
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: TextButton(
                        onPressed: () => navToRegisterView(),
                        child: const Text(
                          'I\'m new here',
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

  void signIn({required String username, required String password}) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      UserService userService = UserService();
      final SharedPreferences shared = await SharedPreferences.getInstance();
      userService
          .authenticateUser(username: username, password: password)
          .then((String token) {
        shared.setString('token', token);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => ChatView(username: username),
          ),
        );
      }).catchError((error, stackTrace) {
        SnackBar snack = SnackBar(content: Text(error.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snack);
      });
    }
  }

  void navToRegisterView() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => const SignUpView(),
      ),
    );
  }

  String? passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    return null;
  }
}
